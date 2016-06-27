//
//  ScoreData.h
//  airpod
//
//  Created by Souleiman Benhida on 12/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPSprite.h"

@interface ScoreData : NSObject 

-(NSString *) dataFilePathforMode:(GameMode)mode;
-(NSString *)getScoreforLevel:(int)level andGameMode:(GameMode)mode;
-(void)setScoreforLevel:(int)level andScore:(int)score andGameMode:(GameMode)mode;
-(void)checkAndCreateSettingforMode:(GameMode)mode;
-(void)writePlistforMode:(GameMode)mode;
-(id) initWithGameMode:(GameMode)mode;

-(void) updateTotalScoreforMode:(GameMode)mode;
-(int) getTotalScoreforMode:(GameMode)mode;
@end
