#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Core Data/BBACoreDataStack.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [BBACoreDataStack installInMemory:YES];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
