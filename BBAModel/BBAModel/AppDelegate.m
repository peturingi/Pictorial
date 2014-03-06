#import "AppDelegate.h"
#import "BBAModelStack.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [BBAModelStack modelNamed:@"CoreData 4" andStore:@"modelStoreTest"];
    UIImage* image = [UIImage imageNamed:@"testImage"];
    [Pictogram insertWithTitle:@"somethign" andImage:image];
    return YES;
}

@end
