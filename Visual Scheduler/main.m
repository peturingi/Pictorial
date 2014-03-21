#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Core Data/BBACoreDataStack.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        BBACoreDataStack *coreDataStack __attribute__((unused)) = [BBACoreDataStack sharedInstance];
        
#ifdef DEBUG
        Schedule *schedule1 = [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Monday" withBackgroundColour:0];
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
        
        UIImage *bench = [UIImage imageNamed:@"bench.png"];
        Pictogram *bench1 = [[BBACoreDataStack sharedInstance] pictogramWithTitle:@"Bench" withImage:bench];
        [bench1 setUsedBy:schedule1];
        if (![[schedule1 pictograms] containsObject:bench1]) {
            [schedule1 insertObject:bench1 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        UIImage *karate = [UIImage imageNamed:@"karate.png"];
        Pictogram *karate1 = [[BBACoreDataStack sharedInstance] pictogramWithTitle:@"Karate" withImage:karate];
        [karate1 setUsedBy:schedule1];
        if (![[schedule1 pictograms] containsObject:bench1]) {
            [schedule1 insertObject:karate1 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        /** duplicate */
        Pictogram *bench2 = [[BBACoreDataStack sharedInstance] pictogramWithTitle:@"Bench" withImage:bench];
        [bench2 setUsedBy:schedule1];
        if (![[schedule1 pictograms] containsObject:bench2]) {
            [schedule1 insertObject:bench2 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        Pictogram *karate2 = [[BBACoreDataStack sharedInstance] pictogramWithTitle:@"Karate" withImage:karate];
        [karate2 setUsedBy:schedule1];
        if (![[schedule1 pictograms] containsObject:bench2]) {
            [schedule1 insertObject:karate2 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        Pictogram *bench3 = [[BBACoreDataStack sharedInstance] pictogramWithTitle:@"Bench" withImage:bench];
        [bench3 setUsedBy:schedule1];
        if (![[schedule1 pictograms] containsObject:bench3]) {
            [schedule1 insertObject:bench3 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        Pictogram *karate3 = [[BBACoreDataStack sharedInstance] pictogramWithTitle:@"Karate" withImage:karate];
        [karate3 setUsedBy:schedule1];
        if (![[schedule1 pictograms] containsObject:bench3]) {
            [schedule1 insertObject:karate3 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        /** duplicate ends */
        
        [[[BBACoreDataStack sharedInstance] sharedManagedObjectContext] save:nil];
#endif
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
