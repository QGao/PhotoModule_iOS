#import "MySingleton.h"
//#import "DataController.h"
//#import "Photo.h"

NSComparisonResult compareLetters(id t1, id t2, void* context)
{    
    return [ [t1 lowercaseString] compare: [t2 lowercaseString] ];
}

MySingleton *gSingleton = nil;
//static MySingleton *sharedMySingleton = nil;

@implementation MySingleton

@synthesize doRef = _doRef;
@synthesize openToGallery = _openToGallery;
@synthesize applyCaptureDefaults = _applyCaptureDefaults;
@synthesize dbController = _dbController;
@synthesize workOrder = _workOrder;
@synthesize dbPath = _dbPath;
@synthesize orderNumber = _orderNumber;
@synthesize userId = _userId;
@synthesize rootPhotoFolder = _rootPhotoFolder;
@synthesize todaysPhotoFolder = _todaysPhotoFolder;
@synthesize hashVals = _hashVals;
@synthesize curHashVals = _curHashVals;
@synthesize hashValsReq = _hashValsReq;
@synthesize docDir = _docDir;
@synthesize curLetArray = _curLetArray;
@synthesize mainData = _mainData;
@synthesize showTrace = _showTrace;

@synthesize newPhotos = _newPhotos;
@synthesize expandOn = _expandOn;
@synthesize editOn = _editOn;
@synthesize filterOn = _filterOn;
@synthesize iPadDevice = _iPadDevice;
@synthesize isModule = _isModule;

@synthesize currentFilterMode = _currentFilterMode;
@synthesize currentAppState = _currentAppState;

@synthesize expandedViewIndex = _expandedViewIndex;
@synthesize photoCount = _photoCount;
@synthesize requiredCount = _requiredCount;
@synthesize labeledCount = _labeledCount;

@synthesize labelArr = _labelArr;
@synthesize itemArray = _itemArray;
@synthesize currentLabelString = _currentLabelString;
@synthesize currentLabelDescription = _currentLabelDescription;
@synthesize requiredLabelArr = _requiredLabelArr;

#pragma mark Singleton Methods

/*
// Not thread safe (supposedly?)
 
+ (id)sharedSingleton {
    @synchronized(self) {
        if (sharedMySingleton == nil)
            sharedMySingleton = [[self alloc] init];
    }
    return sharedMySingleton;
}
*/

/*
+(id)sharedSingleton
{
    static dispatch_once_t pred;
    static MySingleton *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[MySingleton alloc] init];
    });
    return shared;
}
*/

- (id)init
{
    if (self = [super init])
    {
        NSLog(@"[PhotoHubLib] Singleton startup");
        self.mainData = [[NSMutableArray alloc] init];

        // mimic the way INSPI will initialize the application
        //NSString *emuOrder = @"59590951";   // open
        NSString *emuOrder = @"59772717";   // submitted
        
        BOOL emu = NO;
        NSString *model = [[UIDevice currentDevice] model];
        if ([model isEqualToString:@"iPhone Simulator"] || [model isEqualToString:@"iPad Simulator"])
        {
            emu = YES;
        }

        self.iPadDevice = NO;
        
#ifdef UI_USER_INTERFACE_IDIOM
        self.iPadDevice = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#endif
        self.docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        if (emu)
        {
            [self setRootPhotoFolder:[NSString stringWithFormat:@"123_EASY_ST_%@", emuOrder]];

            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"YYYY_MM_dd"];
            [self setTodaysPhotoFolder:[dateFormat stringFromDate:date]];
        }

        //self.orderNumber = @"0";
        
        self.curLetArray = [NSArray arrayWithObjects:
                    @"#",
                    @"A",
                    @"B",
                    @"C",
                    @"D",
                    @"E",
                    @"F",
                    @"G",
                    @"H",
                    @"I",
                    @"J",
                    @"K",
                    @"L",
                    @"M",
                    @"N",
                    @"O",
                    @"P",
                    @"Q",
                    @"R",
                    @"S",
                    @"T",
                    @"U",
                    @"V",
                    @"W",
                    @"X",
                    @"Y",
                    @"Z",
                    nil];
        
        self.newPhotos = NO;
        self.expandOn = NO;
        self.editOn = YES;
        self.filterOn = NO;
        self.doRef = YES;
        self.openToGallery = NO;
        self.isModule = YES;
        
        self.showTrace = NO;
        
        self.currentFilterMode = PHFilterModeAll;
        self.currentAppState = PHASLabelFS;

        self.expandedViewIndex = -1;
        self.photoCount = [[self mainData] count];
        self.requiredCount = 2;
        self.labeledCount = 0;
        
        //not mutable, so can't do this in a loop...(probably a way, but too lazy to look it up :D)
        self.hashVals = [[NSArray alloc] initWithObjects:
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init]
                    , nil];
        
        self.hashValsReq = [[NSArray alloc] initWithObjects:
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init],
                    [[NSMutableArray alloc] init]
                    , nil];
        
        
        self.itemArray = [[NSMutableArray alloc] init];
        
        self.labelArr = [NSMutableArray arrayWithObjects:nil];
        
        [self setLabels:
         @"[No Label],Front of House,Street Scene,House #/Address Sign,Supporting,Back of House,Side of House,center of house,demolition,eviction notice,Other: With Description,f,g,Hg,gh,gha,a1,b1,c1,d1,E1,f1,g1,a2,b2,c2,d2,e2,f2,g2,a3,b3,c3,D3,e3,f3,g3,a11,b11,c11,d11,e11,f11,w11,x11,y11,z11"
         ];
        
        self.requiredLabelArr = [[NSMutableArray alloc] init];
        NSString *labelsWithDupe = @"a3,Front of House,Street Scene,House #/Address Sign,Supporting,Front of House";
        [self setReqLabels:labelsWithDupe withUpdate:NO];
        
        if (emu)
        {
            self.openToGallery = NO;
            [self setDBName:@"inspi"];
            [self setUserId:@"TrojanM"];
            
            // labels set appropriately above
            //updatePHReqLabels({});
            
            // photo folder needs to be set before this point
            
            [self setOrderNum:emuOrder];
        }
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"[PhotoHubLib] Singleton dealloc");

    [[self mainData] removeAllObjects];
    [[self labelArr] removeAllObjects];
    [[self requiredLabelArr] removeAllObjects];
    [[self itemArray] removeAllObjects];

    /*
    //self.doRef = nil;
    //self.openToGallery = nil;
    //self.applyCaptureDefaults = nil;
    self.dbController = nil;
    self.workOrder = nil;
    self.dbPath = nil;
    self.orderNumber = nil;
    self.userId = nil;
    self.rootPhotoFolder = nil;
    self.todaysPhotoFolder = nil;
    self.hashVals = nil;
    self.curHashVals = nil;
    self.hashValsReq = nil;
    self.docDir = nil;
    self.curLetArray = nil;
    self.mainData = nil;
    //self.showTrace = nil;
    
    //self.newPhotos = nil;
    //self.expandOn = nil;
    //self.editOn = nil;
    //self.filterOn = nil;
    //self.iPadDevice = nil;
    //self.isModule = nil;
    
    //self.currentFilterMode = nil;
    //self.currentAppState = nil;
    
    //self.expandedViewIndex = nil;
    //self.photoCount = nil;
    //self.requiredCount = nil;
    //self.labeledCount = nil;
    
    self.labelArr = nil;
    self.itemArray = nil;
    self.currentLabelString = nil;
    self.currentLabelDescription = nil;
    self.requiredLabelArr = nil;
    */
}

- (void) updateLabelHash
{
    [self.labelArr sortUsingFunction:compareLetters context:nil];
    
    int i;
    
    int testLetter;
    int currentIndex;
    
    
    for (i = 0; i < [self.hashVals count]; i++)
    {
        [[self.hashVals objectAtIndex:i] removeAllObjects];
    }
    
    NSMutableArray* curHash;
    NSString* curString;
    
    for (i = 0; i < [self.labelArr count]; i++)
    {
        curString = [self.labelArr objectAtIndex:i];
        testLetter = [curString characterAtIndex:0];
        
        if (testLetter >= 65 && testLetter <= 90)
        {
            testLetter += 32;
        }
        
        //is symbol
        if (testLetter < 97)
        {
            currentIndex = 0;
        }
        else
        {
            currentIndex = testLetter - 96;
        }
        
        curHash = [self.hashVals objectAtIndex:currentIndex];
        [curHash addObject:curString];
    }
}

- (void) updateLabelHashReq
{
    [self.requiredLabelArr sortUsingFunction:compareLetters context:nil];

    int i;
    
    int testLetter;
    int currentIndex;
        
    for (i = 0; i < [self.hashValsReq count]; i++)
    {
        [[self.hashValsReq objectAtIndex:i] removeAllObjects];
    }
    
    NSMutableArray* curHash;
    NSString* curString;
    
    for (i = 0; i < [self.requiredLabelArr count]; i++)
    {
        curString = [self.requiredLabelArr objectAtIndex:i];
        testLetter = [curString characterAtIndex:0];
        
        if (testLetter >= 65 && testLetter <= 90)
        {
            testLetter += 32;
        }
        
        //is symbol
        if (testLetter < 97)
        {
            currentIndex = 0;
        }
        else
        {
            currentIndex = testLetter - 96;
        }
        
        curHash = [self.hashValsReq objectAtIndex:currentIndex];
        [curHash addObject:curString];
    }
}

- (void) setTrace:(BOOL)traceOn
{
    if (traceOn)
    {
        NSLog(@"trace is ON");
        self.showTrace = YES;
        gSingleton.showTrace = YES;
    }
    else
    {
        NSLog(@"trace is OFF");
        self.showTrace = NO;
        gSingleton.showTrace = NO;
    }
}

- (void) setDBName:(NSString *)name
{
    if ([name length] > 0)
    {
        if (self.dbController == nil)
            self.dbController = [[DataController alloc] init];
        [self setDbPath:[self.dbController dbPath:name]];
        bool databaseExists = [[NSFileManager defaultManager] fileExistsAtPath:self.dbPath];
        NSLog(@"dbPath: %@ exists:%@", self.dbPath, databaseExists ? @"YES" : @"NO");
    }
    else
    {
        [self setDbPath:@""];
    }
}


- (void) setOrderNum:(NSString *)orderNum
{    
    self.orderNumber = orderNum;
    self.currentAppState = PHASLabelFS;
    //self.photoCount = [self getPhotoCount];
    // make sure requiredCount is set before this call
    //requiredCount = 0;
    self.editOn = YES;
    self.expandOn = NO;
    self.expandedViewIndex = -1;
    self.filterOn = NO;
    self.applyCaptureDefaults = YES;
    
    if (self.openToGallery)
    {
        self.editOn = NO;
        self.currentAppState = PHASGrid;
    }
    self.doRef = YES;
    [self writeToLog:@"OrderNumber: %@, folder = %@", self.orderNumber, self.rootPhotoFolder];
}

- (void) setReqCount:(NSString *)newCount
{
    //NSLog(@"setReqCount %@", newCount);
    self.requiredCount = [newCount intValue];
}

- (void) setHashReq:(BOOL)isReq
{    
    if (isReq)
    {
        self.curHashVals = self.hashValsReq;
    }
    else
    {
        self.curHashVals = self.hashVals;
    }
}

- (void) setLabels:(NSString*)newLabels
{
    [self.labelArr removeAllObjects];
    
    NSMutableArray *tempArr = (NSMutableArray*)[newLabels componentsSeparatedByString: @","];
    
    NSInteger i;
    for (i = 0; i < [tempArr count]; i++)
    {
        //[labelArr addObject: [[tempArr objectAtIndex:i] capitalizedString] ];
        [self.labelArr addObject: [tempArr objectAtIndex:i] ];
    }
    
    self.currentLabelString = [self.labelArr objectAtIndex:0];
    self.currentLabelDescription = @"";
    
    [self updateLabelHash];
    
    [self setHashReq:NO];
}

- (void) setReqLabels:(NSString*)newLabels withUpdate:(BOOL)doDBUpdate
{
    //requiredLabelArr = (NSMutableArray*)[newLabels componentsSeparatedByString: @","];
    
    [self.requiredLabelArr removeAllObjects];
    
    if ([newLabels isEqualToString:@""])
    {
        // do nothing
    }
    else
    {
        NSArray *tempArr = (NSArray*)[newLabels componentsSeparatedByString: @","];
        
        for (id obj in tempArr)
        {
            if (![self.requiredLabelArr containsObject:obj])
            {
                [self.requiredLabelArr addObject:obj];
            }
        }
    }
    [self updateLabelHashReq];

    if (doDBUpdate)
    {
        [self updateRequiredLabelsInDB];
    }
}

- (BOOL) isReqLab:(NSString*)testLabel
{
    int i;
    int tot = [self.requiredLabelArr count];
    
    for (i = 0; i < tot; i++)
    {
        if ([testLabel isEqualToString:[self.requiredLabelArr objectAtIndex:i]])
        {
            return YES;
        }
    }
    return NO;
}

-(void) unselectAll
{
    for (Photo *photo in [self mainData])
    {
        photo.selected = NO;
    }
}


//####

-(void)writeToLog:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
        NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:args];
        if (self.showTrace)
            NSLog(@"%@", formattedString);
    va_end(args);
    
    NSString *logFile = [[self getDataDirFull] stringByAppendingPathComponent:@"photoinfo.log"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFile];
    if(fileHandle == nil)
    {
        [[NSFileManager defaultManager] createFileAtPath:logFile contents:nil attributes:nil];
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFile];
    }
    [fileHandle seekToEndOfFile];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss zzz"];

    [fileHandle writeData:[[NSString stringWithFormat:@"%@: %@\r\n", [dateFormat stringFromDate:date], formattedString] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
    //[fileHandle release];
    //[formattedString release];
}

- (void) checkDir:(NSString*) directory
{
    NSFileManager *fileManager= [NSFileManager defaultManager]; 
    
    BOOL isDir;
    
    if(![fileManager fileExistsAtPath:directory isDirectory:&isDir])
    {
        if(![fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL])
        {
            NSLog(@"Error: Create folder failed %@", directory);
        }
    }
}

- (NSString*) getDataDirRelative
{
    NSString* res = [NSString stringWithFormat:@"data/%@", self.rootPhotoFolder ];
    return res;
}

- (NSString*) getDataDirFull
{
    NSString* res = [self.docDir stringByAppendingPathComponent:[self getDataDirRelative]];
    [self checkDir:res];
    return res;
}

- (NSString*) getPhotoDirRelative
{
    NSString* res = [NSString stringWithFormat:@"photos/%@", self.rootPhotoFolder ];
    return res;
}

- (NSString*) getPhotoDirFull
{
    NSString* res = [self.docDir stringByAppendingPathComponent:[self getPhotoDirRelative]];
    [self checkDir:[NSString stringWithFormat:@"%@/%@", res, self.todaysPhotoFolder]];
    return res;
}

- (NSString*) getThumbDirRelative
{
    NSString* res = [NSString stringWithFormat:@"data/%@/thumbs", self.rootPhotoFolder ];
    return res;
}

- (NSString*) getThumbDirFull
{
    NSString* res = [self.docDir stringByAppendingPathComponent:[self getThumbDirRelative]];
    [self checkDir:[NSString stringWithFormat:@"%@/%@", res, self.todaysPhotoFolder]];
    return res;
}

/*
- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
*/

-(void) updateRequiredLabelsInDB
{
    NSMutableArray *photos = [Photo getPhotos:[self orderNumber] andUserId:[self userId]];
    
    for (Photo *photo in photos)
    {
        if (photo.label != nil)
        {
            if (photo.description != nil && [photo.description length] == 0)
                [self writeToLog:@"Labeling image - filename: %@ label: %@", photo.name, photo.label];
            else
                [self writeToLog:@"Labeling image - filename: %@ label: %@: %@", photo.name, photo.label, photo.description];
            
            if ([self isReqLab:photo.label])
                photo.required = 1;
            else
                photo.required = 0;
            [photo updateDatabaseEntry];
        }
    }
}

-(void) saveImage:(UIImage*)image withName:(NSString *)name
{    
    CGSize origSize = [image size];//image.size;
    CGSize largeSize;
    CGSize smallSize;
    
    if ([self.currentLabelDescription length] == 0)
        [self writeToLog:@"Saving image (%.f x %.f) filename: %@ label: %@", origSize.width, origSize.height, name, self.currentLabelString];
    else
        [self writeToLog:@"Saving image (%.f x %.f) filename: %@ label: %@: %@", origSize.width, origSize.height, name, self.currentLabelString, self.currentLabelDescription];
    
    if (origSize.height > origSize.width)
    {
        largeSize.height = 640;
        largeSize.width = (640 / origSize.height) * origSize.width;
    }
    else
    {
        largeSize.width = 640;
        largeSize.height = (640 / origSize.width) * origSize.height;        
    }
    smallSize.width = 0.234 * largeSize.width;
    smallSize.height = 0.234 * largeSize.height;
    
    NSLog(@"Resized size: %.f x %.f", largeSize.width, largeSize.height);
    
    UIGraphicsBeginImageContext(largeSize);
    [image drawInRect:CGRectMake(0,0,largeSize.width,largeSize.height)];
    UIImage* largeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(smallSize);
    [image drawInRect:CGRectMake(0,0,smallSize.width,smallSize.height)];
    UIImage* smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //UIImage *sLargeImage = [[[UIImage alloc] initWithData: [image ] ] scaleToSize:CGSizeMake(640.0,480.0)];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSData *data = UIImageJPEGRepresentation(largeImage, 1.0);
    NSString *fullPath = [[self getPhotoDirFull] stringByAppendingPathComponent:name];
    if (gSingleton.showTrace)
        NSLog(@"fullPath: %@", fullPath);
    NSString *relativePath = [[self getPhotoDirRelative] stringByAppendingPathComponent:name];
    if (gSingleton.showTrace)
        NSLog(@"relativePath: %@", relativePath);
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
    NSData *data2 = UIImageJPEGRepresentation(smallImage, 1.0);
    NSString *fullPath2 = [[self getThumbDirFull] stringByAppendingPathComponent:name];
    if (gSingleton.showTrace)
        NSLog(@"fullPath2: %@", fullPath2);
    NSString *relativePath2 = [[self getThumbDirRelative] stringByAppendingPathComponent:name];
    if (gSingleton.showTrace)
        NSLog(@"relativePath2: %@", relativePath2);
    [fileManager createFileAtPath:fullPath2 contents:data2 attributes:nil];
    
    int req = 0;
    if ([self isReqLab:self.currentLabelString])
    {
        req = 1;
    }
    
    Photo *photo = [[Photo alloc] initWithOrderId:self.orderNumber andName:name andLabel:self.currentLabelString andDescription:self.currentLabelDescription andUploadStatus:NUMINT(kStatusPhotoNotReady) andUserId:gSingleton.userId andPhotoData:relativePath andThumbData:relativePath2 andRequired:NUMINT(req)];
    photo.selected = NO;

    UIInterfaceOrientation imgOr = [UIApplication sharedApplication].statusBarOrientation;
    if (imgOr == UIInterfaceOrientationLandscapeLeft || imgOr == UIInterfaceOrientationLandscapeRight)
        photo.orientation = PTItemOrientationLandscape;
    else
        photo.orientation = PTItemOrientationPortrait;
    
    if ([photo updateDatabaseEntry])
    {
        [self.mainData addObject:photo];
        self.photoCount++;
        self.newPhotos = YES;
    }
}

/*
- (void)renameImage:(NSString *)oldName withName:(NSString *)newName
{
    if (gSingleton.showTrace)
        NSLog(@"renameImage %@ to %@", oldName, newName);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *oldPath = [[self getPhotoDirFull] stringByAppendingPathComponent:oldName];
    NSString *newPath = [[self getPhotoDirFull] stringByAppendingPathComponent:newName];
    [fileManager moveItemAtPath:oldPath toPath:newPath error:nil];
    
    NSString *oldPath2 = [[self getThumbDirFull] stringByAppendingPathComponent:oldName];
    NSString *newPath2 = [[self getThumbDirFull] stringByAppendingPathComponent:newName];
    [fileManager moveItemAtPath:oldPath2 toPath:newPath2 error:nil];
     
    [self.infoDict setObject:[self.infoDict objectForKey:oldName] forKey:newName];
    [self removeInfoEntry:oldName];
    //[self updateLabelDB:oldName renameTo:newName];
}
*/

- (void)delImage:(Photo *)photo
{
    // ****************** WARNING ****************** //
    
    // It is currently not safe to remove an image and the UI at the same time
    // This routine will remove the image from the database and the filesystem, but a reload of the data will be needed after
    // all deletions are processed to update the UI
    
    if ([photo.description length] == 0)
        [self writeToLog:@"Deleting image - filename: %@ label: %@", photo.name, photo.label];
    else
        [self writeToLog:@"Deleting image - filename: %@ label: %@: %@", photo.name, photo.label, photo.description];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *fullPath = [[self getPhotoDirFull] stringByAppendingPathComponent:photo.name];
    [fileManager removeItemAtPath:fullPath error:NULL];
    
    NSString *fullPath2 = [[self getThumbDirFull] stringByAppendingPathComponent:photo.name];
    [fileManager removeItemAtPath:fullPath2 error:NULL];
    
    [photo deleteDatabaseEntry];
}

//####


@end