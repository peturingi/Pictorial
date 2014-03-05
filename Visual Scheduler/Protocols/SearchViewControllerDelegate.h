#import <Foundation/Foundation.h>
#import "SearchViewController.h"

@protocol SearchViewControllerDelegate <NSObject>
- (void)searchViewControllerDidCancelSearch:(id)searchViewController;
@end
