//
//  JetPod.m
//  Jet Pod
//
//  Created by Souleiman Benhida on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pod.h"
#import "Map.h"

@implementation Pod

- (id)init {
    if ((self = [super init])) {
        SPImage *pod = [SPImage imageWithContentsOfFile:@"BluePod.png"];
        //image.x = -image.width/2;
        //image.y = -image.height/2;
        [self addChild:pod];        
    }
    return self;
}

@end
