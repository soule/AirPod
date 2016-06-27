#import "LevelSelect.h"
#import "Game.h"
#import "Play.h"
#import "ScoreData.h"

#define numMaps 2

@implementation LevelSelect {
    SPSprite *buttonSprite;
    int currentPage;
    SPButton *nextButton;
    SPButton *prevButton;
    
    GameMode modePicked;
}

-(id) initWithGameMode:(GameMode)_mode {
    if ((self = [super init])) {
        //----Add the background, title, and back button----- (UI)
        SPImage *bg = [SPImage imageWithContentsOfFile:@"BlueBG.png"];
        [self addChild:bg];
        
        SPTextureAtlas *UIAtlas = [SPTextureAtlas atlasWithContentsOfFile:@"UIAtlas.xml"];
        
        SPImage *title = [SPImage imageWithTexture:[UIAtlas textureByName:@"levelTitle"]];
        title.x = 71;
        title.y = 23;
        [self addChild:title];
        
        SPButton *backButton = [SPButton buttonWithUpState:[UIAtlas textureByName:@"backBtn"]];
        backButton.x = 115;
        backButton.y = [SPStage mainStage].height - 53;
        [backButton addEventListener:@selector(backBtnPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:backButton];
        
        //---- UI Done, now let's init some stuff ---- (Code)
        modePicked = _mode;
        ScoreData *ourdata = [[ScoreData alloc] initWithGameMode:modePicked];
        [ourdata setScoreforLevel:9 andScore:3000 andGameMode:UNFAIR];
        buttonSprite = [[SPSprite alloc] init];

        [SPTextField registerBitmapFontFromFile:@"Blocked32.fnt"];

        [SPTextField registerBitmapFontFromFile:@"orbitron18.fnt"];
        [ourdata updateTotalScoreforMode:modePicked];
        SPTextField *totalText = [[SPTextField alloc] initWithWidth:320 height:20 text:[NSString stringWithFormat:@"Total Score: %i", [ourdata getTotalScoreforMode:modePicked]]];
        totalText.fontName = @"Orbitron-Bold";
        totalText.color = 0xffffff;
        totalText.fontSize = 18.0;
        totalText.x =0;
        totalText.y= 90;
        [self addChild:totalText];
        
        
        nextButton = [[SPButton alloc] initWithUpState:[SPTexture textureWithContentsOfFile:@"nextbtn.png"]];
        nextButton.x = 280;
        nextButton.y = 235;
        nextButton.name = @"next";
        [self addChild:nextButton];
        [nextButton addEventListener:@selector(nextButtonPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        prevButton = [SPButton buttonWithUpState:[SPTexture textureWithContentsOfFile:@"prevbtn.png"]];
        prevButton.x = 20;
        prevButton.y = 240;
        prevButton.name = @"prev";
        [self addChild:prevButton];
        [prevButton addEventListener:@selector(prevButtonPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        prevButton.visible = NO;
        
                currentPage = 1;
        
        SPTexture *tex = [SPTexture textureWithContentsOfFile:@"LevelButton.png"];

        int xOffset;
        int yOffset;
        int levelOffset;
        
        for (int p=0; p<numMaps; p++) //each page
        {
            xOffset = 60 + (p * 320);
            yOffset = 123;
            levelOffset = 1 + (p * 9);

            for (int i=0; i<3; i++) //each row
            {
                for (int i=0; i<3; i++)
                {
                    SPButton *_button = [SPButton buttonWithUpState:tex text:[NSString stringWithFormat:@"%i", levelOffset]];
                    
                    _button.fontColor = 0xFFFFFF;
                    _button.fontSize = 32;
                    _button.fontName = @"Blocked";
                    _button.x = xOffset;
                    _button.y = yOffset;
                    _button.name = [NSString stringWithFormat:@"%i", levelOffset];
                    [buttonSprite addChild:_button];
                    
                    [_button addEventListener:@selector(onButtonPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
                    
                    
                    
                    SPTextField *scoreText = [[SPTextField alloc] initWithWidth:100 height:20 text:[ourdata getScoreforLevel:levelOffset andGameMode:modePicked]];
                    scoreText.color = 0xffffff;
                    scoreText.fontName=@"Orbitron-Bold";
                    scoreText.x = xOffset -25;
                    scoreText.y = yOffset+ 60;
                    [buttonSprite addChild:scoreText];
                    xOffset +=75;
                    
                    levelOffset +=1;
                }
                
                xOffset = 60 + (p * 320);
                yOffset +=100;
            }
        }

    }    

    [self addChild:buttonSprite];

    return self;
}

-(void)nextButtonPressed:(SPEvent *)event {
    buttonSprite.x -=320;
    currentPage +=1;
    
    if (currentPage == numMaps) {
        nextButton.visible = NO;
    } else {
        nextButton.visible = YES;
    }
    prevButton.visible = YES;
}

-(void)prevButtonPressed:(SPEvent *)event {
    buttonSprite.x +=320;
    currentPage -=1;
    
    if (currentPage == 1) {
        prevButton.visible = NO;
    } else {
        prevButton.visible = YES;
    }
    nextButton.visible = YES;
}

-(void)onButtonPressed:(SPEvent *)event
{
    SPButton *button = (SPButton *)event.target;

    //PROTIP : Class sceneClass = NSClassFromString!!

    Play *playScene = [[Play alloc] initWithLevel:button.name.intValue andGameMode:modePicked];
    [(Game *)[SPStage mainStage] showScene:playScene];
}

-(void) backBtnPressed:(SPEvent *)event {
    Menu *menuScene = [[Menu alloc] init];
    [(Game *)[SPStage mainStage] showScene:menuScene];
}

@end
