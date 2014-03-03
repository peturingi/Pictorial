#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "../BBACoreDataStack.h"

@interface AppDelegate ()
    @property (strong, nonatomic) BBACoreDataStack* coreDataStack;
@end


@implementation AppDelegate

#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    return YES;
}

- (void)setupDataStack {
    _coreDataStack = [BBACoreDataStack stackWithModelNamed:@"CoreData" andStoreFileNamed:@"CoreData.sqlite"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
