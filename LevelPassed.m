#import "LevelPassed.h"
#import "Game.h"
#import "Menu.h"
#import "Play.h"
#import "ScoreData.h"

@implementation LevelPassed

- (id) initWithLevel:(int)_level andScore:(int)_score andGameMode:(GameMode)_mode
{
    if ((self = [super init]))
    {
        level = _level;

        SPQuad *tint = [[SPQuad alloc] initWithWidth:320 height:480];
        tint.color = 0x000000;
        tint.alpha = 0.67;
        [self addChild:tint];
        
        mode = _mode;
        
        //Save it to file
        ScoreData *ourdata = [[ScoreData alloc] init];
        [ourdata setScoreforLevel:level andScore:_score andGameMode:mode];
        
        //Add text using bitmap font for level and score :P
        [SPTextField registerBitmapFontFromFile:@"levelpassed.fnt"];
        NSString *msg = [NSString stringWithFormat:@"Level %i passed!", level];
        SPTextField *messageText = [SPTextField textFieldWithText:msg];
        messageText.fontName = @"Orbitron-Bold";
        messageText.color = 0xffffff;
        
        messageText.x = 35;
        messageText.y = 135;
        messageText.fontSize = 22;
        messageText.width = 256;
        [self addChild:messageText];
        
        NSString *scoremsg = [NSString stringWithFormat:@"Score: %i", _score];
        SPTextField *scoremessageText = [SPTextField textFieldWithText:scoremsg];
        scoremessageText.fontName = @"Orbitron-Bold";
        scoremessageText.color = 0xefff00;
        scoremessageText.alpha = 1;
        
        scoremessageText.x = 30;
        scoremessageText.y = 165;
        scoremessageText.fontSize = 22;
        scoremessageText.width = 256;
        [self addChild:scoremessageText];
        
        SPImage *bgImage = [[SPImage alloc] initWithContentsOfFile:@"levelPassedScreen.png"];
        bgImage.alpha = 0.84;
        bgImage.x = 40;
        bgImage.y = 116;
        [self addChild:bgImage];
        
        SPQuad *menuButton = [SPQuad quadWithWidth:125  height:30];
        menuButton.alpha=0;
        menuButton.x = bgImage.x +55;
        menuButton.y = bgImage.y + 227;
        [menuButton addEventListener:@selector(menuButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addChild:menuButton];
        
        SPQuad *retryButton = [SPQuad quadWithWidth:105 height:45];
        retryButton.alpha=0;
        retryButton.x = bgImage.x + 80;
        retryButton.y = bgImage.y + 182;
        [retryButton addEventListener:@selector(retryButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addChild:retryButton];
        
        //50 135 185 95, 80 90 165 55, 55 45 180 15
        SPQuad *continueButton = [SPQuad quadWithWidth:135 height:40];
        continueButton.alpha=0;
        continueButton.x = bgImage.x + 50;
        continueButton.y = bgImage.y + 137;
        [continueButton addEventListener:@selector(continueButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addChild:continueButton];
    }
    
    return self;
}

-(void) continueButtonTriggered:(SPTouchEvent *)event {
    Play *playScene = [[Play alloc] initWithLevel:level+1 andGameMode:mode];
    [(Game *)[SPStage mainStage] showScene:playScene];
}

-(void) retryButtonTriggered:(SPTouchEvent *)event {
    Play *playScene = [[Play alloc] initWithLevel:level andGameMode:mode];
    [(Game *)[SPStage mainStage] showScene:playScene];
}
-(void) menuButtonTriggered:(SPTouchEvent *)event {
    SPTouch *touchEnded = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    if (!touchEnded)
        return;
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = nil;
    Menu *menuScene = [[Menu alloc] init];
    [(Game *)[SPStage mainStage] showScene:menuScene];
}
@end