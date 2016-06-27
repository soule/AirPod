//
//  Help.m
//  Air Pod
//
//  Created by Souleiman Benhida on 12/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Help.h"
#import "Game.h"
#import "Menu.h"

@implementation Help

- (id)init {
    if ((self = [super init])) {
        SPImage *bg = [[SPImage alloc] initWithContentsOfFile:@"Help.png"];
        [self addChild:bg];
        
        SPTextureAtlas *UIAtlas = [SPTextureAtlas atlasWithContentsOfFile:@"UIAtlas.xml"];
        
        SPButton *backButton = [SPButton buttonWithUpState:[UIAtlas textureByName:@"backBtn"]];
        backButton.x = 115;
        backButton.y = [SPStage mainStage].height - 53;
        [backButton addEventListener:@selector(backBtnPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        [self addChild:backButton];
        
    }
    return self;
}

-(void) backBtnPressed:(SPEvent *)event {
    Menu *menuScene = [[Menu alloc] init];
    [(Game *)[SPStage mainStage] showScene:menuScene];
}

@end
