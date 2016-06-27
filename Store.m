//
//  Store.m
//  Air Pod
//
//  Created by Souleiman Benhida on 12/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Store.h"
#import "Game.h"
#import "Menu.h"

@implementation Store

- (id)init {
    if ((self = [super init])) {
        SPImage *bg = [SPImage imageWithContentsOfFile:@"Store.png"];
        [self addChild:bg];
        
        SPTextureAtlas *UIAtlas = [SPTextureAtlas atlasWithContentsOfFile:@"UIAtlas.xml"];
        
        /*SPButton *unlockButton = [SPButton buttonWithUpState:[UIAtlas textureByName:@"buyNowBtn"]];
        unlockButton.x = 81;
        unlockButton.y = 200;
        [unlockButton addEventListener:@selector(unlockPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED]; */
        
        SPButton *backButton = [SPButton buttonWithUpState:[UIAtlas textureByName:@"backBtn"]];
        backButton.x = 115;
        backButton.y = [SPStage mainStage].height - 53;
        [backButton addEventListener:@selector(backBtnPressed:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
        
        //[self addChild:unlockButton];
        [self addChild:backButton];
    }
    return self;
}

-(void) unlockPressed:(SPEvent *)event {
    NSLog(@"Unlock All!");
}

-(void) backBtnPressed:(SPEvent *)event {
    Menu *menuScene = [[Menu alloc] init];
    [(Game *)[SPStage mainStage] showScene:menuScene];
}

@end
