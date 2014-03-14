#import <XCTest/XCTest.h>
#import "BBAScheduleTableDataSource.h"
#import <objc/runtime.h>
#import <OCMock/OCMock.h>
#import "MockTableView.h"
#import "MockScheduleOverviewViewController.h"
#import "Schedule.h"

@interface ScheduleTableDataSourceTests : XCTestCase
@property (strong, nonatomic) BBAScheduleTableDataSource *tableDataSource;
@end

@implementation ScheduleTableDataSourceTests {
    NSNotification *receivedNotification;
}

- (void)setUp {
    [super setUp];
    _tableDataSource = [[BBAScheduleTableDataSource alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNotification:)
                                                 name:kBBANotificationNameForDidSelectItem
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNotification:)
                                                 name:kBBANotificationNameForNewDataAvailable
                                               object:nil];
}

- (void)tearDown {
    
    NSManagedObjectContext * context = [[BBACoreDataStack sharedInstance] sharedManagedObjectContext];
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:context]];
    NSArray * result = [context executeFetchRequest:fetch error:nil];
    for (id entity in result)
        [context deleteObject:entity];
    
    _tableDataSource = nil;
    receivedNotification = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super tearDown];
}

- (void)didReceiveNotification:(NSNotification *)notification {
    receivedNotification = notification;
}

#pragma mark - Init

- (void)testScheduleTableDataSourceExists {
    XCTAssertNotNil(self.tableDataSource,
                    @"It must be possible to create a ScheduleTableDataSource.");
}

#pragma mark - Protocol Conformance

- (void)testComformsToUITableViewDataSourceProtocol {
    XCTAssertTrue([[self.tableDataSource class] conformsToProtocol:@protocol(UITableViewDataSource)],
                  @"A class acting as tableDataSource must conform to the UITableViewDataSource protocol.");
}

- (void)testConformsToUITableViewDelegate {
    XCTAssertTrue([[self.tableDataSource class] conformsToProtocol:@protocol(UITableViewDelegate)],
                  @"A class acting as a tableDataSource must conform to the UITableViewDelegate protocol.");
}

- (void)testConformsToNSFetchedResultsControllerDelegate {
    XCTAssertTrue([[self.tableDataSource class] conformsToProtocol:@protocol(NSFetchedResultsControllerDelegate)],
                  @"This class will not work unless it conforms to the fetched results controller delegate.");
}

#pragma mark - Properties

- (void)testHasDataSourceProperty {
    objc_property_t dataSourceProperty = class_getProperty([self.tableDataSource class], "dataSource");
    XCTAssertTrue(dataSourceProperty != NULL,
                  @"dataSource not found.");
}

#pragma mark - dataSource

- (void)testDataSourceExists {
    XCTAssert(self.tableDataSource.dataSource != nil &&
              [self.tableDataSource.dataSource isKindOfClass:[NSNull class]] == NO,
                      @"The dataSource must exist.");
}

- (void)testDataSourceHasCorrectDelegate {
    XCTAssertEqualObjects(self.tableDataSource.dataSource.delegate, self.tableDataSource,
                          @"tableDataSource must act as its dataSources delegate.");
}

- (void)testDataSourceIsEmpty {
    XCTAssertTrue(self.tableDataSource.dataSource.fetchedObjects.count == 0,
    @"The datasource should be empty at this time.");
}

- (void)testDataSourceContainsOneObject {
    [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Test Domain" withPictogramAsLogo:nil withBackgroundColour:0];
    XCTAssertTrue(self.tableDataSource.dataSource.fetchedObjects.count == 1,
                  @"The dataSource should only contain a single item at this point.");
}

- (void)testDataSourceContainsOneHundredObjects {
    XCTAssertTrue(self.tableDataSource.dataSource.fetchedObjects.count == 0,
                  @"The datasource must be empty before the test begins.");
    for (int i = 0; i < 100; i++) {
        [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Test Domain" withPictogramAsLogo:nil withBackgroundColour:0];
    }
    XCTAssertTrue(self.tableDataSource.dataSource.fetchedObjects.count == 100,
                  @"The dataSource should contain 100 items at this point.");
}

- (void)testOneSectionInTableView {
    XCTAssertThrows([self.tableDataSource tableView:nil numberOfRowsInSection:1],
                    @"The tableView must only have a single section.");
}

- (void)testWillNotCreateCellsForMoreThanOneSection {
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow:0 inSection:1];
    XCTAssertThrows([self.tableDataSource tableView:nil cellForRowAtIndexPath:secondSection]);
}

- (void)testInformsDelegateOfRowSelection {
    [[BBACoreDataStack sharedInstance] scheduleWithTitle:@"Test Domain" withPictogramAsLogo:nil withBackgroundColour:0];
    [self.tableDataSource tableView:nil didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertEqual([receivedNotification name], kBBANotificationNameForDidSelectItem,
                  @"The controller must report back to its delegate when user selects a row.");
}

#pragma mark - NSFetchedResultsController delegate

- (void)testAsksTableViewToReloadDataWhenNewDataIsAvailable {
    [self.tableDataSource controllerDidChangeContent:nil];
    XCTAssertEqual([receivedNotification name], kBBANotificationNameForNewDataAvailable,
                  @"The tableView must be asked to reload its data as soon as new data has become available.");
}

@end
