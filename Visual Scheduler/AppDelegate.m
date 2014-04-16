#import "AppDelegate.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

#pragma mark -

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
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

- (Repository *)sharedRepository {
    if (_sharedRepository == nil) {
        _sharedRepository = [[Repository alloc] initWithStore:[[SQLiteStore alloc] init]];
    }
    return _sharedRepository;
}

@end
