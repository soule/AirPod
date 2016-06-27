//
//  AppDelegate.m
//  AppScaffold
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <GameKit/GameKit.h>

@implementation AppDelegate
void onUncaughtException(NSException *exception) 
{
    NSLog(@"uncaught exception: %@", exception);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    mWindow = [[UIWindow alloc] initWithFrame:screenBounds];
    
    // Customize your Sparrow settings below
    // ---------------------------------------------------------------------------------------------
    
    // 'supportHighResolutions' enables retina display support. It will cause '@2x' textures to be 
    // loaded automatically.
    // 
    // 'doubleOnPad' allows you to handle the iPad as if it were an iPhone with a retina display
    // and a resolution of '384x512' points (half of '768x1024'). It will load '@2x' textures on 
    // iPad 1 & 2. If the iPad has a retina screen, it will load '@4x' textures instead.
    
    [SPStage setSupportHighResolutions:YES doubleOnPad:YES];
    
    // Your game will have a different size depending on where it's running!
    // If your game is landscape only set "Initial Interface Orientation" to 
    // a landscape orientation in App-Info.plist.
    
    SPView *sparrowView = [[SPView alloc] initWithFrame:screenBounds];
    
    sparrowView.multipleTouchEnabled = NO; // enable multitouch here if you need it.
    sparrowView.frameRate = 30;            // possible fps: 60, 30, 20, 15, 12, 10, etc.
    [mWindow addSubview:sparrowView];
    
    Game *gameController = [[Game alloc] init];
    sparrowView.stage = gameController;
    
    

    // ---------------------------------------------------------------------------------------------
    
    mViewController = [[ViewController alloc] initWithSparrowView:sparrowView];
    
    if ([mWindow respondsToSelector:@selector(setRootViewController:)])
        [mWindow setRootViewController:mViewController];
    else
        [mWindow addSubview:mViewController.view];

    [mWindow makeKeyAndVisible];
    
    /* Make this interesting.
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, [SPStage mainStage].height)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [mWindow addSubview:splashView];
    [mWindow bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:mWindow cache:YES];
    [UIView setAnimationDelegate:self]; 
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    [UIView commitAnimations];  */
    
    
    return YES;
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
}


-(void) showLeaderboard {
    [mViewController showLeaderboard];
}

-(void) submitScore:(int) score {
    [mViewController submitScore:(int)score];
}
@end
