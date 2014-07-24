#import <Foundation/Foundation.h>
#import "CreatePictogram.h"

@interface PictogramCreator : NSObject {
    @private
    const NSData *_imageData;
    const NSString *_title;
}

- (id)initWithTitle:(NSString *)aString image:(NSData *)imageData;
- (BOOL)compute;

@end
