//
//  Game.h
//  AppScaffold
//
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface Game : SPStage {
    SPSprite *currentScene;
    SPSoundChannel *musicChannel;
    SPSound *tehMusic;
}

- (void) playSong;
- (void) showScene:(SPSprite *) scene;
@end
