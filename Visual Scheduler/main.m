#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Core Data/BBACoreDataStack.h"
#import "Category/UIApplication+BBA.h"
#import "Category/UIImage+BBA.h"
#import "BBAColor.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [BBACoreDataStack installInMemory:YES];
        
#ifdef DEBUG
        Schedule *schedule1 = (Schedule *)[BBACoreDataStack createObjectInContexOfClass:[Schedule class]];
        [schedule1 setTitle:@"Monday"];
        [schedule1 setColour:[NSNumber numberWithInteger:[BBAColor indexForColor:[UIColor yellowColor]]]];

        NSString *fileName;
        
        UIImage *img = [UIImage imageNamed:@"washhands.png"];
        Pictogram *washhands = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [washhands setTitle:@"Wash hands"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [img saveAtLocation:fileName];
        [washhands setImageURL:fileName];
        [washhands addUsedByObject:schedule1];
        if (![[schedule1 pictograms] containsObject:washhands]) {
            [schedule1 insertObject:washhands inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        img = [UIImage imageNamed:@"preparetable.png"];
        Pictogram *preparetable = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [preparetable setTitle:@"Prepare table"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [img saveAtLocation:fileName];
        [preparetable setImageURL:fileName];
        [preparetable addUsedByObject:schedule1];
        if (![[schedule1 pictograms] containsObject:preparetable]) {
            [schedule1 insertObject:preparetable inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        img = [UIImage imageNamed:@"eat.png"];
        Pictogram *eat = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [eat setTitle:@"Eat"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [img saveAtLocation:fileName];
        [eat setImageURL:fileName];
        [eat addUsedByObject:schedule1];
        if (![[schedule1 pictograms] containsObject:eat]) {
            [schedule1 insertObject:eat inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        img = [UIImage imageNamed:@"brushteeth.png"];
        Pictogram *brush = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [brush setTitle:@"Toilet"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [img saveAtLocation:fileName];
        [brush setImageURL:fileName];
        [brush addUsedByObject:schedule1];
        if (![[schedule1 pictograms] containsObject:brush]) {
            [schedule1 insertObject:brush inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        img = [UIImage imageNamed:@"toilet.png"];
        Pictogram *wc = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [wc setTitle:@"Toilet"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [img saveAtLocation:fileName];
        [wc setImageURL:fileName];
        [wc addUsedByObject:schedule1];
        if (![[schedule1 pictograms] containsObject:wc]) {
            [schedule1 insertObject:wc inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        img = [UIImage imageNamed:@"play.png"];
        Pictogram *play = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [play setTitle:@"Play"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [img saveAtLocation:fileName];
        [play setImageURL:fileName];
        [play addUsedByObject:schedule1];
        if (![[schedule1 pictograms] containsObject:play]) {
            [schedule1 insertObject:play inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        img = [UIImage imageNamed:@"washhands.png"];
        Pictogram *washhands2 = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [washhands2 setTitle:@"Wash hands"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [img saveAtLocation:fileName];
        [washhands2 setImageURL:fileName];
        [washhands2 addUsedByObject:schedule1];
        if (![[schedule1 pictograms] containsObject:washhands2]) {
            [schedule1 insertObject:washhands2 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        img = [UIImage imageNamed:@"toilet.png"];
        Pictogram *wc2 = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [wc2 setTitle:@"Toilet"];
        fileName = [UIApplication uniqueFileNameWithPrefix:@"Pictogram"];
        [img saveAtLocation:fileName];
        [wc2 setImageURL:fileName];
        [wc2 addUsedByObject:schedule1];
        if (![[schedule1 pictograms] containsObject:wc2]) {
            [schedule1 insertObject:wc2 inPictogramsAtIndex:schedule1.pictograms.count];
        }
        
        Pictogram *notInUse = (Pictogram *)[BBACoreDataStack createObjectInContexOfClass:[Pictogram class]];
        [notInUse setTitle:@"Not in use"];
        [notInUse setImageURL:fileName];
        
        [BBACoreDataStack saveContext:nil];
#endif
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}