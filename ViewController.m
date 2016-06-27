//
//  ViewController.m
//  ViewControllerTest
//

#import <UIKit/UIDevice.h>
#import <GameKit/Gamekit.h>

#import "ViewController.h"
#import "GameController.h"

@implementation ViewController


- (id)initWithSparrowView:(SPView *)sparrowView
{
    if ((self = [super init]))
    {
        loggedin = NO;
        mSparrowView = sparrowView;
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(onApplicationDidBecomeActive:) 
                   name:UIApplicationDidBecomeActiveNotification object:nil];
        [nc addObserver:self selector:@selector(onApplicationWillResignActive:) 
                   name:UIApplicationWillResignActiveNotification object:nil];
        
        //Sign into game center
        localPlayer = [GKLocalPlayer localPlayer];
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (localPlayer.isAuthenticated)
            {
                // Player was successfully authenticated.
                // Perform additional tasks for the authenticated player.
                loggedin = YES;
            }
            else {
                NSLog(@"error: %@  a.H", [error userInfo]);
            }
        }]; 
    }   
    return self;
}
- (void) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL)
	{
        
        leaderboardController.category = @"mainLeaderboard";
        leaderboardController.timeScope = GKLeaderboardTimeScopeToday;
        leaderboardController.leaderboardDelegate = (id)self;
		[self presentModalViewController: leaderboardController animated: YES];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{ // May need to chagne slightly (see apple docs for iOS 6), specifically the params
    [self dismissModalViewControllerAnimated:YES];
}

-(void) submitScore: (int) score {
    if (loggedin) {
        GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"mainLeaderboard"];
        scoreReporter.value = score;
        scoreReporter.context = 0;
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            // Do something interesting here.
        }];
    }
}

- (id)init
{
    [NSException raise:SP_EXC_INVALID_OPERATION format:@"ViewController requires Sparrow View"];
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [SPPoint purgePool];
    [SPRectangle purgePool];
    [SPMatrix purgePool];   
    
    [super didReceiveMemoryWarning];
}

#pragma mark - view lifecycle

- (void)loadView
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.view = [[SPOverlayView alloc] initWithFrame:screenBounds];
}

#pragma mark - notifications

- (void)onApplicationDidBecomeActive:(NSNotification *)notification
{
    [mSparrowView start];

    
    
}

- (void)onApplicationWillResignActive:(NSNotification *)notification
{
    [mSparrowView stop];
}

@end
