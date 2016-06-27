#import "SPSprite.h"

@interface LevelPassed : SPSprite {
    int level;
    GameMode mode;
}

-(id) initWithLevel:(int)level andScore:(int)score andGameMode:(GameMode)_mode;

@end
