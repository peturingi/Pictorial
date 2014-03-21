#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Core Data/BBACoreDataStack.h"
#import "Category/UIApplication+BBA.h"
#import "Category/UIImage+BBA.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [BBACoreDataStack installInMemory:YES];
        
#ifdef DEBUG
        Schedule *schedule1 = (Schedule *)[BBACoreDataStack createObjectInContexOfClass:[Schedule class]];
        [schedule1 setTitle:@"Monday"];
        [schedule1 setColour:[NSNumber numberWithInteger:0]];

        NSString *fileName;
        
        UIImage *bench = [UIImage imageNamed:@"bench.png"];
        Pictogram *bench1 = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [bench1 setTitle:@"Bench1"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [bench saveAtLocation:fileName];
        [bench1 setImageURL:fileName];
        [bench1 setUsedBy:schedule1];
        if (![[schedule1 pictograms] containsObject:bench1]) {
            [schedule1 insertObject:bench1 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        /*
        UIImage *karate = [UIImage imageNamed:@"karate.png"];
        Pictogram *karate1 = [[BBACoreDataStack sharedInstance] pictogramWithTitle:@"Karate" withImage:karate];
        [karate1 setUsedBy:schedule1];
        if (![[schedule1 pictograms] containsObject:bench1]) {
            [schedule1 insertObject:karate1 inPictogramsAtIndex:schedule1.pictograms.count];
        }
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
        */
        
        [BBACoreDataStack saveContext:nil];
#endif
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
