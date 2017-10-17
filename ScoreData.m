#import "ScoreData.h"
#import "AppDelegate.h"

@implementation ScoreData // 0 in the array is the total score

-(id) initWithGameMode:(GameMode)mode {

    self = [super init];
    if (self) {
        [self checkAndCreateSettingforMode:(GameMode)mode];
    }
    return self;
}

-(NSString *) dataFilePathforMode:(GameMode)mode
{ 
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); NSString *documentDirectory = [path objectAtIndex:0]; 
    if (mode == UNFAIR) {
        return [documentDirectory stringByAppendingPathComponent:@"Scores.plist"];
    } else {
        return [documentDirectory stringByAppendingPathComponent:@"ScoresPeaceful.plist"];
    }
}

-(NSString *)getScoreforLevel:(int)level andGameMode:(GameMode)mode
{
    NSString *filePath = [self dataFilePathforMode:mode]; 
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    return [array objectAtIndex:level]; 
}

-(void)setScoreforLevel:(int)level andScore:(int)score andGameMode:(GameMode)mode
{
    int oldScore = [[self getScoreforLevel:level andGameMode:mode] intValue];
    
    if (score > oldScore) { // only save if score is higher
        NSString *filePath = [self dataFilePathforMode:mode]; 
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) { return; }
        
        NSString *scoreString = [NSString stringWithFormat:@"%i", score];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filePath]; 
        [array replaceObjectAtIndex:level withObject:scoreString];
        [array writeToFile:[self dataFilePathforMode:mode] atomically:YES]; 
        
        [self updateTotalScoreforMode:mode];
    }
}

-(void) updateTotalScoreforMode:(GameMode)mode{
    int total = [self getTotalScoreforMode:mode];
    
    //Game Center Stuff
    if (mode == UNFAIR) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate submitScore:total];
    }
    
}

-(int) getTotalScoreforMode:(GameMode)mode {
    NSString *filePath = [self dataFilePathforMode:mode]; 
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filePath]; 
    [ array removeObjectAtIndex:0];
    int total = 0;
    for (NSString* score in array) {
        total += [score intValue];
    }
    
    return total;
}

- (void)writePlistforMode:(GameMode)mode
{ 
    NSMutableArray *anArray = [[NSMutableArray alloc] init]; 
    for (int i=0; i<21; i++) {
        [anArray addObject:@"0"];
    }
    [anArray writeToFile:[self dataFilePathforMode:mode] atomically:YES];
}

-(void) checkAndCreateSettingforMode:(GameMode)mode
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= mode==UNFAIR ? [documentsDirectory stringByAppendingPathComponent:@"Scores.plist"] 
        : [documentsDirectory stringByAppendingPathComponent:@"ScoresPeaceful.plist"];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = mode==UNFAIR ? [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Scores.plist"] : [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ScoresPeaceful.plist"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    [self writePlistforMode:mode];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


@end
