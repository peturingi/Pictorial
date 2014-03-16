#import "UIApplication+BBA.h"

@implementation UIApplication (BBA)

- (NSString *)documentDirectory {
    NSArray* directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* documentsDir = [directories lastObject];
    return [documentsDir path];
}

@end
