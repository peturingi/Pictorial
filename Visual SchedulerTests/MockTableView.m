#import "MockTableView.h"

@implementation MockTableView

- (void)reloadData {
    _wasAskedToReloadData = YES;
}

- (BOOL)wasAskedToReloadData {
    return _wasAskedToReloadData;
}

@end
