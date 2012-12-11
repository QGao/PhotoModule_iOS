#import "AppDelegate.h"
#import "MainViewController.h"
#import "SampleViewController.h"
#import "PTShowcaseView.h"
#import "SDURLCache.h"
#import "PTDemoViewController.h"
#import "AVCamViewController.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;

void onUncaughtException(NSException *exception) 
{
    NSLog(@"uncaught exception: %@", exception.description);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&onUncaughtException);

    gSingleton.isModule = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    mainViewController = [[MainViewController alloc] init];
    
    /*
    SampleViewController *avcHolderViewController = [[SampleViewController alloc] init];
    mainViewController.avcHolderViewController = avcHolderViewController;
    
    SampleViewController *ptHolderViewController = [[SampleViewController alloc] init];
    mainViewController.ptHolderViewController = ptHolderViewController;
    
    SampleViewController *rvHolderViewController = [[SampleViewController alloc] init];
    mainViewController.rvHolderViewController = rvHolderViewController;
    
    SampleNavigationController *navViewController = [[SampleNavigationController alloc] init];
    mainViewController.navViewController = navViewController;
    
    SampleNavigationController *headerViewController = [[SampleNavigationController alloc] init];
    mainViewController.headerViewController = headerViewController;
    
    SampleNavigationController *ssHolderViewController = [[SampleNavigationController alloc] init];
    mainViewController.ssHolderViewController = ssHolderViewController;
    
    SampleNavigationController *togHolderViewController = [[SampleNavigationController alloc] init];
    mainViewController.togHolderViewController = togHolderViewController;
    */
    
    [self.window setRootViewController:mainViewController];

    ////////
    
    /*
     * Optional: do some disk caching (don't exaggerate though, because this
     * isn't data persistence): less network requests so that content ideally
     * is always there.
     */
    
    // Nimbus implements its own in-memory cache for network images. Because of
    // this we don't allocate any memory for NSURLCache.
    static const NSUInteger kMemoryCapacity = 0;
    static const NSUInteger kDiskCapacity = 1024*1024*50; // 50MB disk cache
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:kMemoryCapacity
                                                         diskCapacity:kDiskCapacity
                                                             diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:urlCache];
    
    ////
        
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
