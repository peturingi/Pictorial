#import <XCTest/XCTest.h>
#import "BBAScheduleTableDataSource.h"
#import <objc/runtime.h>

@interface ScheduleTableDataSourceTests : XCTestCase
@property (strong, nonatomic) BBAScheduleTableDataSource *tableDataSource;
@end

@implementation ScheduleTableDataSourceTests

- (void)setUp {
    [super setUp];
    _tableDataSource = [[BBAScheduleTableDataSource alloc] init];
    [BBAModelStack modelNamed:@"CoreData" andStore:]
}

- (void)tearDown {
    _tableDataSource = nil;
    [super tearDown];
}

- (void)testScheduleTableDataSourceExists {
    XCTAssertNotNil(self.tableDataSource,
                    @"It must be possible to create a ScheduleTableDataSource.");
}

- (void)testComformsToUITableViewDataSourceProtocol {
    XCTAssertTrue([[self.tableDataSource class] conformsToProtocol:@protocol(UITableViewDataSource)],
                  @"A class acting as tableDataSource must conform to the UITableViewDataSource protocol.");
}

- (void)testConformsToNSFetchedResultsControllerDelegate {
    XCTAssertTrue([[self.tableDataSource class] conformsToProtocol:@protocol(NSFetchedResultsControllerDelegate)],
                  @"This class will not work unless it conforms to the fetched results controller delegate.");
}

- (void)testHasDataSourceProperty {
    objc_property_t dataSourceProperty = class_getProperty([self.tableDataSource class], "dataSource");
    XCTAssertTrue(dataSourceProperty != NULL,
                  @"dataSource not found.");
}

- (void)testDataSourceExists {
    XCTAssert(self.tableDataSource.dataSource != nil &&
              [self.tableDataSource.dataSource isKindOfClass:[NSNull class]] == NO,
                      @"The dataSource must exist.");
}

- (void)testDataSourceIsEmpty {
    XCTAssertTrue(self.tableDataSource.dataSource.fetchedObjects.count == 0,
    @"The datasource should be empty at this time.");
}

- (void)testDataSourceContainsOneObject {
    [Schedule insertWithTitle:@"Test" logo:nil backGround:0];
    XCTAssertTrue(self.tableDataSource.dataSource.fetchedObjects.count == 1,
                  @"The dataSource should only contain a single item at this point.");
}

@end
