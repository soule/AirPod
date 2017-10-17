#import "Menu.h"
#import "Game.h"
#import "AppDelegate.h"
#import "LevelSelect.h"

@implementation Menu

- (id)init {
    if ((self = [super init])) {
        
        SPImage *menubg = [SPImage imageWithContentsOfFile:@"BlueBG.png"];
        [self addChild:menubg];
        
        SPTextureAtlas *menuAtlas = [SPTextureAtlas atlasWithContentsOfFile:@"UIAtlas.xml"];
        
        SPImage *title = [SPImage imageWithTexture:[menuAtlas textureByName:@"AirPodTitle"]];
        title.x = 34;
        title.y = 24;
        [self addChild:title];
        
        SPButton *playButton = [SPButton buttonWithUpState:[menuAtlas textureByName:@"playBtn"]];
        playButton.x = 96;
        playButton.y = 148;
        playButton.name = @"ModePick";
        [playButton addEventListener:@selector(buttonPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        
        SPButton *storeButton = [SPButton buttonWithUpState:[menuAtlas textureByName:@"storeBtn"]];
        storeButton.x = 102;
        storeButton.y = 214;
        storeButton.name = @"Store";
        [storeButton addEventListener:@selector(buttonPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        SPButton *helpButton = [SPButton buttonWithUpState:[menuAtlas textureByName:@"helpBtn"]];
        helpButton.x = 114;
        helpButton.y = 276;
        helpButton.name = @"Help";
        [helpButton addEventListener:@selector(buttonPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        SPButton *scoresButton = [SPButton buttonWithUpState:[menuAtlas textureByName:@"scoresBtn"]];
        scoresButton.x = 100;
        scoresButton.y = [SPStage mainStage].height - 59;
        [scoresButton addEventListener:@selector(scoresButtonPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        [self addChild:playButton];
        [self addChild:storeButton];
        [self addChild:helpButton];
        [self addChild:scoresButton];
    }
    return self;
}

-(void) buttonPressed:(SPEvent *)event {
    SPButton *button = (SPButton *)event.target;
    
    Class sceneClass = NSClassFromString(button.name);
    
    id newScene = [[sceneClass alloc] init];
    [(Game *)[SPStage mainStage] showScene:newScene];
}

-(void) scoresButtonPressed:(SPEvent *)event {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLeaderboard];
}

@end
