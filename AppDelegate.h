//
//  AppDelegate.h
//  AppScaffold
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> 
{
  @private 
    UIWindow *mWindow;
    ViewController *mViewController;
    UIImageView *splashView;
}

-(void) showLeaderboard;
-(void) submitScore:(int)score;

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end
