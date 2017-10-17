#import "ModePick.h"
#import "Game.h"
#import "Menu.h"
#import "LevelSelect.h"

@implementation ModePick 

- (id)init {
    if ((self = [super init])) {
        SPImage *bg = [SPImage imageWithContentsOfFile:@"ModePick.png"];
        [self addChild:bg];
        
        SPTextureAtlas *UIAtlas = [SPTextureAtlas atlasWithContentsOfFile:@"UIAtlas.xml"];
        
        SPButton *peacefulBtn = [SPButton buttonWithUpState:[UIAtlas textureByName:@"peacefulBtn"]];
        peacefulBtn.x = 69;
        peacefulBtn.y = 136;
        peacefulBtn.name = @"peaceful";
        [peacefulBtn addEventListener:@selector(peacefulBtnPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        SPButton *unfairBtn = [SPButton buttonWithUpState:[UIAtlas textureByName:@"unfairBtn"]];
        unfairBtn.x = 95;
        unfairBtn.y = 270; //10+ from PS
        unfairBtn.name = @"unfair";
        [unfairBtn addEventListener:@selector(unfairBtnPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        SPButton *backButton = [SPButton buttonWithUpState:[UIAtlas textureByName:@"backBtn"]];
        backButton.x = 115;
        backButton.y = [SPStage mainStage].height - 53;
        [backButton addEventListener:@selector(backBtnPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        [self addChild:peacefulBtn];
        [self addChild:unfairBtn];
        [self addChild:backButton];
    }
    
    return self;
}

-(void) peacefulBtnPressed:(SPEvent *)event {
    LevelSelect *levelSelectScene = [[LevelSelect alloc] initWithGameMode:PEACEFUL]; // there's an enum in the PCH file in Other Sources
    [(Game *)[SPStage mainStage] showScene:levelSelectScene];
}

-(void) unfairBtnPressed:(SPEvent *)event {
    LevelSelect *levelSelectScene = [[LevelSelect alloc] initWithGameMode:UNFAIR];
    [(Game *)[SPStage mainStage] showScene:levelSelectScene];
}


-(void) backBtnPressed:(SPEvent *)event {
    Menu *menuScene = [[Menu alloc] init];
    [(Game *)[SPStage mainStage] showScene:menuScene];
}

@end
