#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ViewMode) {
    Now,
    Day,
    Week,
};

@interface CalendarCollectionViewLayout : UICollectionViewLayout {
    ViewMode _viewMode;
}

@property (nonatomic, weak) IBOutlet id<UICollectionViewDataSource> dataSource;

- (id)init __unavailable;

@end