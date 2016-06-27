//
//  Play.h
//  AppScaffold
//
#import <Foundation/Foundation.h>
#import "Map.h"
#import "Pod.h"
#import "Menu.h"


@interface Play : SPSprite <UIAccelerometerDelegate, UIAlertViewDelegate>
{
    SPSprite *world;
    SPSprite *HUD;
    SPJuggler *juggler;
    Pod *jetPod;
    
    GameMode mode;
    
    float podX; //default jetpod x
    float podY; //default jetpod y
    
    float camX; //default cam x
    float camY; //default cam y
    
    bool shouldScrollX;
    bool shouldScrollY;
    
    int level;
    int score;
    int coincount;
    
    bool isExploding;
    
    //explosions
    SPSprite *particles;
    SPTexture *particleTex;
    
    int timeLeft;
    int maxTime;
    float secondTimer;
    
    float accelTime;
    float fallTime;
    
    Map *map;
    
    bool isFlying;
    bool gasTouched;
    
    bool isDrifting;
    
    SPSoundChannel *flyChannel;
    SPSoundChannel *timerChannel;
    SPTexture *cloudTex;
    
    SPButton *pauseButton;
    SPSoundChannel *explosion;
    SPSoundChannel *coinChannel;
    
    SPTextField *coinText;
    SPSprite *pauseScreen;
    SPSprite *clouds;
    SPTextField *timerText;

    
}

@property (nonatomic) float accelX;

- (id)initWithLevel:(int)_level andGameMode:(GameMode)_mode;
-(void) checkAllCollisions:(SPDisplayObject *)obj;
-(void) onEnterFrameEvent:(SPEnterFrameEvent *)event;
-(void) explodePodatPos:(SPPoint *)pos;
-(void) resetPositions;
-(void) drawHUD;
-(void) addMapAndPod;
-(void) addSounds;

- (SPPoint *)movementWithDistance:(float)distance directionRadians:(float)direction factor:(float)factor;

@end