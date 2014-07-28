#import <UIKit/UIKit.h>

@interface PictogramView : UIView

- (id)init __deprecated;
- (id)initWithFrame:(CGRect)frame __deprecated;
- (id)initWithCoder:(NSCoder *)aDecoder __deprecated;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)anImage;

@end
