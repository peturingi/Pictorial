#import <Foundation/Foundation.h>
#import "CreatePictogram.h"

@interface PictogramCreator : NSObject {
    @private
    const NSData *_imageData;
    const NSString *_title;
}

- (id)init __deprecated_msg("Use initWithTitle:image:");

- (id)initWithTitle:(NSString *)aString image:(NSData *)imageData;

/** Creates and saves a new pictogram.
 @return YES if successful in creating and saving a pictogram.
 @return NO if unsuccessful
 */
- (BOOL)compute;

@end
