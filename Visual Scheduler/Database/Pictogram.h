#import <Foundation/Foundation.h>
#import "../Protocols/ContainsImage.h"

@interface Pictogram : NSObject <ContainsImage>{
    UIImage* _image;
}
@property (readonly) NSInteger uniqueIdentifier;
@property (strong, nonatomic) NSString *title;
- (id)initWithTitle:(NSString *)title withUniqueIdentifier:(NSInteger)identifier withImage:(UIImage *)image;
-(UIImage*)image;
@end
