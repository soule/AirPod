//
//  GameController.m
//  AppScaffold
//

#import <OpenGLES/ES1/gl.h>
#import "GameController.h"


@interface GameController ()

- (UIInterfaceOrientation)initialInterfaceOrientation;

@end


@implementation GameController

- (id)init
{
    if ((self = [super init]))
    {
        mGame = [[Game alloc] init];
        
        [self addChild:mGame];
    }
    
    return self;
}


- (UIInterfaceOrientation)initialInterfaceOrientation
{
    // In an iPhone app, the 'statusBarOrientation' has the correct value on Startup; 
    // unfortunately, that's not the case for an iPad app (for whatever reason). Thus, we read the
    // value from the app's plist file.
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *initialOrientation = [bundleInfo objectForKey:@"UIInterfaceOrientation"];
    if (initialOrientation)
    {
        if ([initialOrientation isEqualToString:@"UIInterfaceOrientationPortrait"])
            return UIInterfaceOrientationPortrait;
        else if ([initialOrientation isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"])
            return UIInterfaceOrientationPortraitUpsideDown;
        else if ([initialOrientation isEqualToString:@"UIInterfaceOrientationLandscapeLeft"])
            return UIInterfaceOrientationLandscapeLeft;
        else
            return UIInterfaceOrientationLandscapeRight;
    }
    else 
    {
        return [[UIApplication sharedApplication] statusBarOrientation];
    }
}



// Enable this method for the simplest possible universal app support: it will display a black
// border around the iPhone (640x960) game when it is started on the iPad (768x1024); no need to 
// modify any coordinates. 
/*
- (void)render:(SPRenderSupport *)support
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        glEnable(GL_SCISSOR_TEST);
        glScissor(64, 32, 640, 960);
        [super render:support];
        glDisable(GL_SCISSOR_TEST);
    }
    else 
        [super render:support];
}
*/

@end
