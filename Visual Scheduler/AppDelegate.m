#import "AppDelegate.h"
#import "../BBAModel/BBAModel/BBAModelStack.h"

@interface AppDelegate ()
@end


@implementation AppDelegate

#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setupDataStack];
    return YES;
}

- (void)setupDataStack {
    [BBAModelStack modelNamed:@"CoreData" andStore:@"RuntimeStore"];
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
