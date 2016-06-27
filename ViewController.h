//
//  ViewController.h
//  ViewControllerTest
//

#import <UIKit/UIKit.h>

#import "GameController.h"

@interface ViewController : UIViewController
{
    
    GKLocalPlayer *localPlayer;
 
    bool loggedin;
    SPView *mSparrowView;

}

-(void) showLeaderboard;   
- (id)initWithSparrowView:(SPView *)sparrowView;
-(void) submitScore:(int)score;
@end
