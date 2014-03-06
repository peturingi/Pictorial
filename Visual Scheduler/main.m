#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "../BBAModel/BBAModel/BBAModelStack.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [BBAModelStack modelNamed:@"CoreData" andStore:@"RuntimeStore"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
