#import <UIKit/UIKit.h>

@interface PictogramView : UIView

- (id)init __deprecated;
- (id)initWithFrame:(CGRect)frame __deprecated;
- (id)initWithCoder:(NSCoder *)aDecoder __deprecated;

- (id)initWithPoint:(CGPoint const)point andImage:(UIImage * const)anImage;
- (id)initWithFrame:(CGRect const)frame andImage:(UIImage * const)anImage;
+ (CGRect)frameAtPoint:(CGPoint)point;

@end
