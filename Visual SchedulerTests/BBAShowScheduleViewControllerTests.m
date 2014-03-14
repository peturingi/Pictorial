#import <XCTest/XCTest.h>
#import "BBAShowScheduleViewController.h"
#import "MockManagedObjectContext.h"
#import "MockViewController.h"
#import "BBAShowScheduleViewController_BBAShowScheduleViewControllerPrivate.h"
#import <objc/runtime.h>

@interface BBAShowScheduleViewControllerTests : XCTestCase {
    MockManagedObjectContext *managedObjectContext;
}
@property (strong, nonatomic) BBAShowScheduleViewController* showScheduleViewController;
@end

@implementation BBAShowScheduleViewControllerTests

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _showScheduleViewController = [storyboard instantiateViewControllerWithIdentifier:@"showSchedule"];
}

- (void)tearDown {
    _showScheduleViewController = nil;
    managedObjectContext = nil;
    [super tearDown];
}

- (void)testCanBeCreated {
    XCTAssert(self.showScheduleViewController != nil, @"It must be possibel to create a showScheduleViewController");
}

#pragma mark - Schedule

- (void)testScheduleCanNotBeSetToNonSchedule {
    XCTAssertThrows(self.showScheduleViewController.schedule = nil,
                    @"It should not be possible to assign schedule to an object not of type Schedule");
}

#pragma mark - Table View

- (void)testViewControllerHasNonNullDataSource {
    objc_property_t dataSourceProperty = class_getProperty([[self.showScheduleViewController tableView] class], "dataSource");
    XCTAssertTrue(dataSourceProperty != NULL, @"showScheduleViewControllers' tableView must have a data source");
}

- (void)testViewControllerHasNonNullDelegate {
    objc_property_t delegateProperty = class_getProperty([[self.showScheduleViewController tableView] class], "delegate");
    XCTAssertTrue(delegateProperty != NULL, @"showScheduleViewController's tableView must have a delegate");
}

@end
