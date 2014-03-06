#import <XCTest/XCTest.h>
#import "BBAScheduleOverviewViewController.h"
#import <objc/runtime.h>

@interface BBAScheduleOverviewViewControllerTests : XCTestCase
@property (strong, nonatomic) BBAScheduleOverviewViewController *viewController;
@end


@implementation BBAScheduleOverviewViewControllerTests

- (void)setUp
{
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _viewController = [storyboard instantiateViewControllerWithIdentifier:@"scheduleOverview"];
}

- (void)tearDown
{
    _viewController = nil;
    [super tearDown];
}

#pragma mark - Table view

- (void)testViewControllerHasNonNullDataSource {
    objc_property_t dataSourceProperty = class_getProperty([[self.viewController tableView] class], "dataSource");
    XCTAssertTrue(dataSourceProperty != NULL, @"viewControllers' tableView must have a data source");
}

- (void)testViewControllerHasNonNullDelegate {
    objc_property_t delegateProperty = class_getProperty([[self.viewController tableView] class], "delegate");
    XCTAssertTrue(delegateProperty != NULL, @"viewControllers' tableView must have a delegate");
}

#pragma mark -

@end
