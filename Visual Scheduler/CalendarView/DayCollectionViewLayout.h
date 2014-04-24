#import <UIKit/UIKit.h>

static const NSUInteger HEADER_HEIGHT = 20;

@interface DayCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) NSDictionary *layoutInformation;
@property (nonatomic) NSInteger maxNumRows;
@property (nonatomic) UIEdgeInsets insets;

- (CGSize)sizeOfItems;
- (CGFloat)sectionWidth;
- (CGSize)headerSize;

@end