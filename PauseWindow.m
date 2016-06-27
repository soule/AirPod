#import "PauseWindow.h"
#import "Game.h"
#import "Menu.h"

@implementation PauseWindow
- (id)initWithColor:(NSString *)color
{
    if ((self = [super init]))
    {
        SPQuad *tint = [[SPQuad alloc] initWithWidth:320 height:480];
        tint.color = 0x000000;
        tint.alpha = 0.67;
        [self addChild:tint];
        
        NSString *pauseString =[NSString stringWithFormat:@"%@PauseWindow.png",color];
        SPImage *bgImage = [[SPImage alloc] initWithContentsOfFile:pauseString];
        bgImage.alpha = 0.84;
        bgImage.x = 40;
        bgImage.y = 116;
        [self addChild:bgImage];

        SPQuad *menuButton = [SPQuad quadWithWidth:140 height:30];
        menuButton.alpha=0;
        menuButton.x = bgImage.x +50;
        menuButton.y = bgImage.y + 88;
        [menuButton addEventListener:@selector(menuButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addChild:menuButton];

        SPQuad *resumeButton = [SPQuad quadWithWidth:110 height:25];
        resumeButton.alpha=0;
        resumeButton.x = bgImage.x + 60;
        resumeButton.y = bgImage.y + 133;
        [resumeButton addEventListener:@selector(resumeButtonTriggered:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self addChild:resumeButton];
    }
    
    return self;
}

-(void) resumeButtonTriggered:(SPTouchEvent *)event {
    self.visible = NO;
}
-(void) menuButtonTriggered:(SPTouchEvent *)event {
    SPTouch *touchEnded = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
    if (!touchEnded)
        return;
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = nil;
    Menu *menuScene = [[Menu alloc] init];
    [(Game *)[SPStage mainStage] showScene:menuScene];
}
@end
