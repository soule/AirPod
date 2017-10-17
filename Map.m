#import "Map.h"

@implementation Map
@synthesize tileData;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize coins;
@synthesize tileIDs;
@synthesize platforms;

-(id) initWithCSV:(NSString *)csvName tileSize:(CGSize)mTileSize andTileImage:(NSString*)tileImageName {
    if ((self = [super init])) {
        tiles = [[NSMutableArray alloc] init];
        tileData = [[NSMutableArray alloc] init];
        tileIDs = [[NSMutableArray alloc] init];
        coins = [[NSMutableArray alloc] init];
        platforms = [[NSMutableArray alloc] init];
        
        mapSprite = [[SPCompiledSprite alloc] init];

        coinSprite = [[SPSprite alloc] init];
        
        platformSprite = [[SPSprite alloc] init];
        juggler = [[SPJuggler alloc] init];
        
        tileWidth = mTileSize.width;
        tileHeight = mTileSize.height;
        
        [self makeTilesFromImage:tileImageName];
        [self setupMapWithCSV:csvName];
        [self drawMap];
        
        [self addChild:mapSprite];
        [self addChild:coinSprite];
        [self addChild:platformSprite];
        
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
}

-(void) onEnterFrame:(SPEnterFrameEvent *)event
{
    [juggler advanceTime:event.passedTime];
}

-(void) makeTilesFromImage:(NSString *)tileImageName {
    UIImage *img = [UIImage imageNamed:tileImageName];
    
    int tilesWide = floor(img.size.width/tileWidth);
    int tilesHigh = floor(img.size.height/tileHeight);
    
    //NSLog(@"%i,%i", tilesWide, tilesHigh);
    
    if(tiles.count > 0){
        [tiles removeAllObjects];
    }
    
    SPTexture *tilesTexture = [[SPTexture alloc] initWithContentsOfImage:img];
    for (int yy=0; yy<tilesHigh; yy++) {
        for (int xx=0;xx<tilesWide; xx++) {
            SPRectangle *rect = [[SPRectangle alloc] initWithX:xx*tileWidth y:yy*tileHeight width:tileWidth height:tileHeight];
            SPSubTexture *tileTexture = [[SPSubTexture alloc] initWithRegion:rect ofTexture:tilesTexture];
            //SPImage *tileImage = [[SPImage alloc] initWithTexture:tileTexture];
            [tiles addObject:tileTexture];
            //[tileImage release];
        }
    }
    
    //NSLog(@"tiles count: %i", [tiles count]);
}

-(void) setupMapWithCSV:(NSString *)csvName {
    // TO ACCESS A TILE ID: [[[tileData objectAtIndex:COLUMN] objectAtIndex:ROW] intValue]
    //Side to side: ROW
    // UP AND DOWN: COLUMN
    NSString *theCSVPath = [[NSBundle mainBundle] pathForResource:csvName ofType:@"csv"];
    
    NSString *badcsvData = [[NSString alloc] initWithContentsOfFile:theCSVPath encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *csvData = [badcsvData stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]; // trim whitespace
    NSArray *rows = [csvData componentsSeparatedByString:@"\n"];
    
    int count = 0;
    
    for (NSString *row in rows)
    {
        
        NSMutableArray *newcol = [[NSMutableArray alloc] init];
        NSMutableArray *newblankcol = [[NSMutableArray alloc] init];
        
        NSMutableArray *platformArr = [[NSMutableArray alloc] init];
        NSArray *colData = [row componentsSeparatedByString:@","];
        
        count+=1;
        //Coin/platform stuff..
        for (NSString *col in colData)
        {   
            [newblankcol addObject:[NSNull null]];
            [platformArr addObject:[NSNull null]];
            int newIDint = [col integerValue]-1;
            if (![col length] == 0) {
                NSString *newID = [NSString stringWithFormat:@"%i", newIDint];
                //printf("%i", newIDint);
                if (newIDint > -1) {
                    [newcol addObject:newID];
                }
            }
        }
        
        [tileData addObject:newcol];
        [coins addObject:newblankcol];
        [platforms addObject:platformArr];
    }
}

-(void) drawMap { //Time to draw the tiles!
    int mapWidth = [[tileData objectAtIndex:0] count]; //this is wrong...
    int mapHeight = [tileData count];
    float xOffset = 0;
    int yOffset = 0;
    for (int i = 0; i < mapHeight; i++) // i = COLUMN
    {
        for (int j = 0; j < mapWidth; j++) { // j = ROW        
            int tileID = [[[tileData objectAtIndex:i] objectAtIndex:j] intValue];

            SPImage *tile = [[SPImage alloc] initWithTexture:[tiles objectAtIndex:tileID]];
            tile.x = xOffset;
            tile.y = yOffset;
            
            if (tileID == 22 || tileID == 23) { //small (7) windmill!
                NSMutableArray *walls = [self windmillWithLength:(tileID == 23 ? 7 : 9 )atX:xOffset andY:yOffset];

                int midpoint = tileID == 23 ? 3 : 4; // if its 23, then its small so 3; otherwise 4
                
                //Add a giant square (7x7) of all the potential sizes of the angle, using our walls array
                for (int col = i-midpoint; col < i+midpoint; col++) { //For each column
                    for (int row = j-midpoint; row < j+midpoint; row++) { //For each row
                        [[platforms objectAtIndex:col] replaceObjectAtIndex:row withObject:walls];
                    }
                }
                //auto adds blank tile to the sprite.. now replace it in the array
                NSString *newID = [NSString stringWithFormat:@"%i", 19];
                [[tileData objectAtIndex:i] replaceObjectAtIndex:j withObject:newID];
            } 
            
            else if (tileID == 20 || tileID == 21) { 
                NSString *newID = [NSString stringWithFormat:@"%i", 19];
                //SPImage *tile = [[SPImage alloc] initWithTexture:[tiles objectAtIndex:12]];
                [[tileData objectAtIndex:i] replaceObjectAtIndex:j withObject:newID];
                tile.texture = [tiles objectAtIndex:12];
                [[platforms objectAtIndex:i] replaceObjectAtIndex:j withObject:tile];
                [platformSprite addChild:tile];
                
                // create a tween that moves side to side
                SPTween *tween = [SPTween tweenWithTarget:tile time:1.5];
                if (tileID == 20) {
                    [tween animateProperty:@"x" targetValue:(tile.x + 48)]; //Left-Right
                } else {
                    [tween animateProperty:@"y" targetValue:(tile.y + 48)]; //Up-Down   
                }

                tween.loop = SPLoopTypeReverse;
                
                [juggler addObject:tween];
                
                //Add a blank tile to the main layer..
                SPImage *blankTile = [[SPImage alloc] initWithTexture:[tiles objectAtIndex:19]];
                blankTile.x = xOffset;
                blankTile.y = yOffset;
                [mapSprite addChild:blankTile];
            }
       
            else if (tileID == 16) {
                [[coins objectAtIndex:i] replaceObjectAtIndex:j withObject:tile];
                [coinSprite addChild:tile];
                
                //Add a blank tile to the main layer..
                SPImage *blankTile = [[SPImage alloc] initWithTexture:[tiles objectAtIndex:19]];
                blankTile.x = xOffset;
                blankTile.y = yOffset;
                [mapSprite addChild:blankTile];
            } else {
                [mapSprite addChild:tile];
            }
            
            xOffset +=tileWidth;
        }
        //Done with that row, move on
        xOffset = 0.0f;
        yOffset +=tileHeight;
    }
    [mapSprite compile];
}

-(bool) isPoint:(SPPoint *)point inRotatedObject:(SPDisplayObject *)obj {
    SPPoint *rotatedPoint = [point rotateBy:-obj.rotation originX:obj.x originY:obj.y];
    SPPoint *topLeft = [SPPoint pointWithX:(obj.x - obj.pivotX) y:(obj.y - obj.pivotY)];
    SPPoint *bottomRight = [SPPoint pointWithX:(obj.x + obj.pivotX) y:(obj.y + obj.pivotY)];
    
    return rotatedPoint.x > topLeft.x && rotatedPoint.x < bottomRight.x && rotatedPoint.y > topLeft.y && rotatedPoint.y < bottomRight.y;
}


- (int) getTileID:(SPPoint *)loc
{
    int column = floor(loc.x / tileWidth);
    int row = floor(loc.y / tileHeight);
    
    int tileID = [[[tileData objectAtIndex:row] objectAtIndex:column] intValue];
    
    return tileID;
}

-(NSMutableArray *) getPlatforms:(SPPoint *)loc
{
    int mapWidth = [tileData  count];
    //NSLog(@"Width: %i", mapWidth);
    
    int elrow = floor(loc.x / tileWidth);
    int column = floor(loc.y / tileHeight);

    NSMutableArray *returnArr = [NSMutableArray array];
    
    //check everything in the column
    for (id obj in [platforms objectAtIndex:column]) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [returnArr addObject:obj];
        }
    }
    //Loop through all the cols, check le row
    for (int c=0; c < mapWidth; c++) {
            id obj = [[platforms objectAtIndex:c] objectAtIndex:elrow];
            if ([obj isKindOfClass:[SPDisplayObject class]]) {
                [returnArr addObject:obj];
            }
    }
    return returnArr;
}
-(void) removeCoinAtColumn:(int)col andRow:(int)row {
    //Remove from coins array and sprite
    SPImage *_tile = [[coins objectAtIndex:col] objectAtIndex:row];
    
    [coinSprite removeChild:_tile];
    
    //replace tile ID
    NSString *newTileString = [NSString stringWithFormat:@"19"];
    [[tileData objectAtIndex:col] replaceObjectAtIndex:row withObject:newTileString];
}

-(NSMutableArray *) windmillWithLength:(int)length atX:(float)xOffset andY:(float)yOffset {
    //Loop twice - once for each wall; We increment the angleOffset by 270 so it goes from 45 to 315 :)
    float angleOffset = SP_D2R(45);
    
    NSMutableArray *walls = [[NSMutableArray alloc] init];
    
    for (int w=0; w<2; w++) { //for each wall
        SPCompiledSprite *wall = [[SPCompiledSprite alloc] init];
        
        float tileYOff = 0; // (0 by default) 
        for (int i=0; i<length; i++) {
            int tileID;
            
            switch (i) {
                case 0: //top end
                    tileID = 0;
                    break;
                case 6: //bottom end (length 7)
                    tileID = length==7 ? 8 : 4; //if its length is 7, then this is the end. Otherwise see 8
                    break;
                case 8: //bottom end (length 9)
                    tileID = 8;
                    break;
                case 3: 
                    tileID = w == 1 && length == 7 ? 13 : 4;  //checking that is the short windmill and that its the top wall
                    break;  // middle one for top
                case 4:
                    tileID = w == 1 && length == 9 ? 13 : 4; //checking that is the long windmill and that its the top wall
                    break;
            
                default: //reg vertical tile
                    tileID = 4;
                    break;
            }
    
            SPImage *tile = [[SPImage alloc] initWithTexture:[tiles objectAtIndex:tileID]];
            tile.y = tileYOff;
            [wall addChild:tile];
            
            tileYOff += 16;
        } 

        [wall compile];
        
        wall.x = xOffset;
        wall.y = yOffset;
        
        wall.pivotX =  wall.width/2.0f;
        wall.pivotY = wall.height/2.0f;

        wall.rotation = angleOffset;
        
        SPTween *tween = [SPTween tweenWithTarget:wall time:5.0];
        [tween animateProperty:@"rotation" targetValue:SP_D2R(w == 1?314 : 404)]; 
        tween.loop = SPLoopTypeRepeat;
        [juggler addObject:tween];
        
        [platformSprite addChild:wall];
        [walls addObject:wall];
         
        angleOffset = SP_D2R(315);
        
        
    }
    
    //Add a blank tile to the main layer + replace it in the array with one too
    SPImage *blankTile = [[SPImage alloc] initWithTexture:[tiles objectAtIndex:19]];
    blankTile.x = xOffset;
    blankTile.y = yOffset;
    [mapSprite addChild:blankTile];
    
    return walls;
}

@end
