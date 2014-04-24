#import <UIKit/UIKit.h>

@interface WeekCollectionViewLayout : UICollectionViewLayout

@property (nonatomic) NSDictionary *layoutInformation;
@property (nonatomic) NSInteger maxNumRows;
@property (nonatomic) UIEdgeInsets insets;

@end