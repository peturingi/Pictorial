#import <Foundation/Foundation.h>

@interface Pictogram : NSObject
@property (readonly) NSInteger uniqueIdentifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
- (id)initWithTitle:(NSString *)title withUniqueIdentifier:(NSInteger)identifier withImage:(UIImage *)image;
@end
