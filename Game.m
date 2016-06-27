//
//  Game.m
//  AppScaffold
//

#import "Game.h" 
#import "Menu.h"
#import "Play.h"
#import <OpenGLES/ES1/gl.h>
#import <GameKit/GameKit.h>
//#import "ViewController.h"
#import "AppDelegate.h"





// --- class implementation ------------------------------------------------------------------------

@implementation Game 

- (id)init
{
    if ((self = [super init]))
    {
        [SPAudioEngine start];
        //[self playSong];

        Menu *menuScene = [[Menu alloc] init];
        [self showScene:menuScene];
    }
    return self;
}


- (void)playSong
{
    tehMusic = [[SPSound alloc] initWithContentsOfFile:@"TheSignal.aifc"];
    musicChannel = [tehMusic createChannel];
    musicChannel.volume = 1.0f;
    musicChannel.loop = YES;
    
    [musicChannel play];
}

- (void)showScene:(SPSprite *)scene
{
    if ([self containsChild:currentScene]) {
        [self removeChild:currentScene];
    }
    
    //if going to gameplay scene, stop music
    if ([scene isKindOfClass:[Play class]]){
        [musicChannel stop];
    } 
    else if ([currentScene isKindOfClass:[Play class]]) //otherwise, if you're coming from a gameplay scene, pick a new song
    {
        [musicChannel play];
    }
    
    [self addChild:scene];
    
    currentScene = scene;
}
@end

