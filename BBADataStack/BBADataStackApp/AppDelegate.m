#import "AppDelegate.h"
#import "BBADataStack.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [BBADataStack stackWithModelNamed:@"TestModel" andStoreFileNamed:@"someStore"];
    return YES;
}

@end
