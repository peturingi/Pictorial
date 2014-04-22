#import "AppDelegate.h"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self createEditableCopyOfFileIfNeeded:@"localeDb.sqlite3"];
    [self createEditableCopyOfFileIfNeeded:@"settings.sqlite3"];
    [self createEditableCopyOfFileIfNeeded:@"vs.sqlite3"];
    return YES;
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfFileIfNeeded:(NSString *)file {
    NSParameterAssert(file != nil);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:file];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];
    NSError *error;
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable file with message '%@'.", [error localizedDescription]);
    }
}

@end
