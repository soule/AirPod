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
