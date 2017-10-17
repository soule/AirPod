#import "SPSprite.h"

@interface Map : SPSprite {
NSMutableArray *tiles;
    SPCompiledSprite *mapSprite;
    SPSprite *coinSprite;
    
    SPSprite *platformSprite;
    SPJuggler *juggler;
}

@property (nonatomic, strong) NSMutableArray *tileData;
@property (nonatomic, assign) int tileWidth;
@property (nonatomic, assign) int tileHeight;
@property (nonatomic, strong) NSMutableArray *tileIDs;
@property (nonatomic, strong) NSMutableArray *coins;
@property (nonatomic, strong) NSMutableArray *platforms;


-(id) initWithCSV:(NSString *)csvName tileSize:(CGSize)mTileSize andTileImage:(NSString *)tileImageName;

-(void) makeTilesFromImage:(NSString *)tileImageName;

-(void) setupMapWithCSV:(NSString *)csvName;

-(void) drawMap;

-(int) getTileID:(SPPoint *)loc;

-(NSMutableArray *) getPlatforms:(SPPoint *)loc;

-(void) removeCoinAtColumn:(int)column andRow:(int)row;
-(bool) isPoint:(SPPoint *)point inRotatedObject:(SPDisplayObject *)obj;

-(NSMutableArray *) windmillWithLength:(int)length atX:(float)xOffset andY:(float)yOffset;

@end
