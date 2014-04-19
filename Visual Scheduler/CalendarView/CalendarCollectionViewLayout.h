#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ViewMode) {
    Now,
    Day,
    Week,
};

static const NSInteger MONDAY       = 0;
static const NSInteger SUNDAY       = 6;
static const NSInteger DAYS_IN_WEEK = SUNDAY - MONDAY;

@interface CalendarCollectionViewLayout : UICollectionViewLayout {
    ViewMode _viewMode;
}

@property (nonatomic, weak) IBOutlet id<UICollectionViewDataSource> dataSource;

@property (nonatomic) NSDictionary *layoutInformation;
@property (nonatomic) NSInteger maxNumRows;
@property (nonatomic) UIEdgeInsets insets;

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeOfItems;
- (CGSize)headerSize;
- (NSInteger)sectionRepresentingToday;
- (CGRect)frameForHeaderOfSection:(NSUInteger)section;

- (NSDictionary *)headerAttributes;
- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary *)cellAttributes;
- (CGPoint)originForHeaderOfSection:(NSUInteger)section;
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
@end