#import "Play.h"
#import "Map.h" 
#import "Pod.h"
#import "Game.h"
#import "Menu.h"
#import "PauseWindow.h"
#import "LevelPassed.h"
#import <GameKit/GameKit.h>
#import "ScoreData.h"

#define NUM_CLOUDS 1
#define NUM_PARTICLES 8

@implementation Play
@synthesize accelX;
#pragma mark init---
- (id)initWithLevel:(int)_level andGameMode:(GameMode)_mode;
{
    if ((self = [super init]))
    {
        UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
        accelerometer.updateInterval = 1.0/60.0;
        accelerometer.delegate = self;
        
        juggler = [[SPJuggler alloc] init];
        
        world = [[SPSprite alloc] init];
        [self addChild:world];
        
        mode = _mode;
        level = _level;
        
        [self addMapAndPod];
        [self addSounds];
        
        HUD = [[SPSprite alloc] init];
        [self addChild:HUD];
        [self drawHUD];
        
        cloudTex = [[SPTexture alloc] initWithContentsOfFile:@"Cloud.png"];
        clouds = [[SPSprite alloc] init];
        [world addChild:clouds];
        
        particleTex = [[SPTexture alloc] initWithContentsOfFile:@"newparticle.png"];
        particles = [[SPSprite alloc] init];
        [world addChild:particles];

        [self addEventListener:@selector(onEnterFrameEvent:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
}

#pragma mark end init
-(void) onEnterFrameEvent:(SPEnterFrameEvent *)event
{
    float dt = event.passedTime;
    
    [timerChannel pause];
    if (!pauseScreen.visible) {
    [juggler advanceTime:dt];

    
    if (gasTouched) {
        //timer stuff
        if (mode == UNFAIR) { 
            [timerChannel play]; 
            secondTimer += dt;
            if (secondTimer > 1.0f) {
                timeLeft -=1;
                timerText.text = [NSString stringWithFormat:@"Time %i",timeLeft];
                secondTimer = 0;
            }
            if (timeLeft == 0) {
                [self explodePodatPos:[SPPoint pointWithX:(jetPod.x+(jetPod.width/2)) y:(jetPod.y+(jetPod.height/2))]];
            }
        }
        if (isFlying) { // Accelerating!
            [flyChannel play];
            accelTime += dt;
            fallTime = 0;
            jetPod.y -= 3+round(accelTime);
            if (shouldScrollY) { world.y += 3+round(accelTime); }
            for (int i=0; i<NUM_CLOUDS; i++) //make clouds
            {
                //Add the left cloud
                SPImage *_cloudL = [SPImage imageWithTexture:cloudTex];
                [clouds addChild:_cloudL];
                
                
                _cloudL.x = jetPod.x-3;
                _cloudL.y = jetPod.y+(jetPod.height)+2;
                
                //Add the right cloud
                SPImage *_cloudR = [SPImage imageWithTexture:cloudTex];
                [clouds addChild:_cloudR];
                
                _cloudR.x = jetPod.x+(jetPod.width)-6;
                _cloudR.y = jetPod.y+(jetPod.height)+2;
                
                
            }
        }
        else { //sinking
            [flyChannel pause];
            accelTime = 0;
            fallTime +=dt;
            jetPod.y+=2+round(fallTime);
            if (shouldScrollY) { world.y -=2+round(fallTime); }
        }
        
        
        for (int i=0; i<clouds.numChildren; i++) //dissolve/remove both left and right old clouds
        {
            SPDisplayObject *_cloud = [clouds childAtIndex:i];
            if (_cloud.alpha == 0) {
                [clouds removeChild:_cloud];
            }
            else
            {
                _cloud.alpha -=0.2;
            }
        }
        
        if (shouldScrollX) { world.x -=round(accelX * 300 * dt); }
        
        jetPod.x +=round(accelX * 300 * dt);
        
        [self checkAllCollisions:jetPod];
    }
    }
}


-(void) explodePodatPos:(SPPoint *)pos {
    isExploding = YES;
    isFlying = 0;
    gasTouched = 0;
    jetPod.visible = 0;
    //stop flying/timer sounds
    [flyChannel pause];
    [timerChannel pause];
    
    //remove coins ;) BUG SQUASHED! :)
    coincount =0;
    coinText.text = [NSString stringWithFormat:@"Stars: %i",coincount];
    
    //reset timer
    timeLeft = maxTime;
    timerText.text = [NSString stringWithFormat:@"Time: %i", maxTime];
    
    //destroy clouds
    [clouds removeAllChildren];
    
    //explode!
    [explosion play];
    
    
    
    float angleOffset = 0;
    for (int i=0; i<NUM_PARTICLES; i++) {
        SPImage *_particle = [SPImage imageWithTexture:particleTex];
        _particle.x = pos.x;
        _particle.y = pos.y;

        SPPoint *_movement = [self movementWithDistance:75 directionRadians:SP_D2R(angleOffset) factor:1];
        
        SPTween *_tween = [SPTween tweenWithTarget:_particle time:0.3f];
        [_tween moveToX:(_particle.x +_movement.x) y:(_particle.y + _movement.y)];
        
        [juggler addObject:_tween];
        
                
        [particles addChild:_particle];

        [[juggler delayInvocationAtTarget:particles byTime:0.3] removeChild:_particle]; 
        
        angleOffset +=45;
    }
    [[juggler delayInvocationAtTarget:self byTime:0.5] resetPositions]; 
    
}

-(void) resetPositions {
    isExploding = NO;
    jetPod.visible = 1;
    jetPod.x = podX;
    jetPod.y = podY;
    accelX = 0;
    accelTime = 0;
    fallTime = 0;
    isFlying = 0;
    world.x = camX;
    world.y = camY;
}

- (void) checkAllCollisions:(SPDisplayObject *)obj
{
    SPRectangle *bounds = obj.bounds;
    SPPoint *topRight = [SPPoint pointWithX:(bounds.x+bounds.width) y:bounds.y];
    SPPoint *bottomLeft = [SPPoint pointWithX:bounds.x y:bounds.bottom];
    
    score = (200 * coincount) + (mode == UNFAIR ? (100 * timeLeft) : 0);
    
    
    NSString *filestring = [NSString stringWithFormat:@"Level%i", level+1];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:filestring ofType:@"csv"]];
    
    NSArray *positions = [NSArray arrayWithObjects:bounds.topLeft, topRight, bottomLeft, bounds.bottomRight, nil];


    for (SPPoint *pos in positions) {
        float row = (pos.x / map.tileWidth);
        float col = (pos.y / map.tileHeight);
        
        NSMutableArray *platforms = [map getPlatforms:pos];
        
        for (id platform in platforms) { //platform could be an array of positions or 
            //NSLog(@"Platform: %@", platform);
            if ([platform isKindOfClass:[NSMutableArray class]]) { //windmill
                //printf("Is an array");
                for (SPDisplayObject *wall in (NSMutableArray *)platform) {
                    //printf("loopin!");
                    if ([map isPoint:pos inRotatedObject:wall]) {
                        [self explodePodatPos:pos];
                    }
                }
            } else if ([((SPDisplayObject *)platform).bounds containsPoint:pos]) { // normal platform, we cast to display obj
                [self explodePodatPos:pos];
            }
            
        }
        switch ([map getTileID:pos]) {
            case 16: //coin!
                [map removeCoinAtColumn:col andRow:row];
                [coinChannel play];
                coincount +=1;
                coinText.text = [NSString stringWithFormat:@"Stars: %i",coincount];
                return;
                break;
                
            case 18: //finish line!
                [flyChannel pause];
                [timerChannel pause];
                
                gasTouched = 0;
                
                if (fileExists) {
                    LevelPassed *passScene = [[LevelPassed alloc] initWithLevel:level andScore:score andGameMode:mode];
                    [HUD addChild:passScene];
                   // Play *playScene = [[Play alloc] initWithLevel:level+1];
                    //[(Game *)[SPStage mainStage] showScene:playScene];
                }
                else{
                    //Game Completed scene
                    //Save it to file

                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"You've beat all the levels. For now :) Try to get #1 on Game Center and leave a review for my game. Thanks!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    ScoreData *ourdata = [[ScoreData alloc] initWithGameMode:mode];
                    [ourdata setScoreforLevel:level andScore:score andGameMode:mode];
                }
                return;
                break;
                
            case 19: // air
                break;
                
            default: //collision!
                [self explodePodatPos:pos];
                return;
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = nil;
    
    Menu *menuScene = [[Menu alloc] init];
    [(Game *)[SPStage mainStage] showScene:menuScene];
}

-(void) drawHUD {
    SPQuad *topHUD = [SPQuad quadWithWidth:320 height:35];
    topHUD.color = 0x000000;
    topHUD.alpha = 0.6;
    [HUD addChild:topHUD];
    
    //SXFPSMeter *meter = [[SXFPSMeter alloc] initWithText:@""];
    //[self addChild:meter];
    
    SPQuad *gasBounds = [SPQuad quadWithWidth:320 height:445]; //whole screen sans menubar
    gasBounds.alpha = 0;
    gasBounds.x = 0;
    gasBounds.y = 35;
    [HUD addChild:gasBounds];
    [gasBounds addEventListener:@selector(onGasButtonTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    
    [SPTextField registerBitmapFontFromFile:@"Score24.fnt"];
    
    if (mode == UNFAIR) {
        timerText = [[SPTextField alloc] initWithWidth:100 height:20 text:[NSString stringWithFormat:@"Time: %i", maxTime]];
        timerText.fontName = @"04b03";
        timerText.color = 0xffff00;
        timerText.fontSize = 24.0f;
        timerText.y = 10;
        timerText.x = 170;
        [HUD addChild:timerText];
    }
    
    coinText = [[SPTextField alloc] initWithWidth:130 height:20 text:@"Stars: 0"];
    coinText.fontName = @"04b03";
    coinText.color = 0x00ffff;
    coinText.fontSize = 24.0f;
    coinText.y = 10;
    coinText.x = mode == PEACEFUL ? 100 : 35; //center it in peaceful
    [HUD addChild:coinText];
    
    SPTexture *pauseTexture = [SPTexture textureWithContentsOfFile:@"newpause.png"];
    // Make pause button just two small vertical lines in the  far right of the bar
    pauseButton = [[SPButton alloc] initWithUpState:pauseTexture];
    pauseButton.x = 277;
    pauseButton.y = 0;
    pauseButton.alpha = 0.67;
    [pauseButton addEventListener:@selector(onPauseButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [HUD addChild:pauseButton];
    
    pauseScreen = [[PauseWindow alloc] initWithColor:@"blue"];
    pauseScreen.visible = NO;
    [self addChild:pauseScreen];
    }

-(void) onGasButtonTouched:(SPTouchEvent *)event {
    if ([[[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] allObjects] count]) {
        if (!isExploding) {
        gasTouched = true;
            isFlying = true; }
    }
    if ([[[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] allObjects] count])
        isFlying = false;
}

-(void) onPauseButtonTriggered:(SPEvent *)event {
    pauseScreen.visible = YES;
}
         
-(void) addSounds {
    SPSound *coinSound = [SPSound soundWithContentsOfFile:@"coin.caf"];
    coinChannel = [coinSound createChannel];
    
    SPSound *explodeSound = [SPSound soundWithContentsOfFile:@"explode.caf"];
    explosion = [explodeSound createChannel];
    
    SPSound *flySound = [SPSound soundWithContentsOfFile:@"flying.caf"];
    flyChannel = [flySound createChannel];
    flyChannel.loop = YES;
    flyChannel.volume = 0.2;
    
    SPSound *timerSound = [SPSound soundWithContentsOfFile:@"normaltimer.caf"];
    timerChannel = [timerSound createChannel];
    timerChannel.loop = YES;
    timerChannel.volume = 0.4;
}
         
-(void) addMapAndPod {
    NSString *mapName = [NSString stringWithFormat:@"Level%i", level];
    map = [[Map alloc] initWithCSV:mapName tileSize:CGSizeMake(16, 16) andTileImage:@"MTBlue.png"];
    [world addChild:map];
    //NSLog(@"%f %f %i", map.width, map.height, mode);
    
    shouldScrollX = map.width > 320; //they're both booleans :P
    shouldScrollY = map.height > 480;
    podX = 100;
    podY = 410;
    maxTime = 10;
    switch (level) {
        case 1:
            podX = 151.5;
            break;
        case 3:
            podX = 79;
            podY = 430;
            break;
        case 4:
            //camY = 95;
            podY = 190;
            //camX = 40;
            podX = 40;
            break;
        case 5:
            podX = 145;
            podY =70;
            break;
        case 6:
            podY = 270;
            podX = 40;
            break;
        case 7:
            podX = 544;
            podY = 416;
            camX = -320;
            maxTime = 25;
            break;
        case 8:
            podX = 150;
            podY = 425;
            break;
        case 9:
            podX = 260;
            podY = 425;
            camX = -75;
            camY = -25;
            break;
        case 10:
            podX = 100;
            podY = 360;
            break;
        case 12:
            timeLeft = 5;
            break;
        case 13:
            podX = 35;
            break;
        case 17:
            podY = 395;
            podX = 150;
            break;
        case 18:
            podX = 150;
            break;
        default:
            //cam is default at 0,0
            podX = 100;
            podY = 410;
            break;
    }
       timeLeft = maxTime;
    world.x = camX;
    world.y = camY;
    
    jetPod = [[Pod alloc] init];
    [world addChild:jetPod];
    jetPod.x = podX;
    jetPod.y = podY;

}


#pragma mark small functions (one liners)
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    accelX = acceleration.x;
}

- (SPPoint *)movementWithDistance:(float)distance directionRadians:(float)direction factor:(float)factor {
    return [SPPoint pointWithX:sin(direction)*distance*factor y:-cos(direction)*distance*factor];
}
@end
