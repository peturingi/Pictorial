#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Core Data/BBACoreDataStack.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [BBACoreDataStack installInMemory:YES];
        
#ifdef DEBUG
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Monday" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Visit Doctor Downtown" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Day in the woods" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Wednesday in the kindergarden" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Monday the 24th of July 2014" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Fredag" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Mandag" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Tirsdag" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Onsdag" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Torsdag" withBackgroundColour:0];
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Fredag" withBackgroundColour:0];
        [[[BBACoreDataStack sharedInstance] sharedManagedObjectContext] save:nil];
#endif
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
