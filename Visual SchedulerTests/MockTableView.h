#import <UIKit/UIKit.h>

@interface MockTableView : UITableView {
    BOOL _wasAskedToReloadData;
}

- (BOOL)wasAskedToReloadData;

@end
