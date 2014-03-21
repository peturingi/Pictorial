#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBACoreDataStack.h"
#import "BBAShowScheduleViewController.h"

@interface BBAShowScheduleTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic, readonly) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet BBAShowScheduleViewController *delegate;

@end
