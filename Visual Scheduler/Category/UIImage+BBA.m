#import "UIImage+BBA.h"

@implementation UIImage (BBA)
- (void)saveAtLocation:(NSString *)location {
    NSData* imageData = UIImagePNGRepresentation(self);
    if (![imageData writeToFile:location atomically:YES]) {
        [NSException raise:@"Failed to save" format:@"Failed to save the data at the specified location. Location was: %@", location];
    }
}
@end
