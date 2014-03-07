#import <XCTest/XCTest.h>
#import "BBAScheduleTableDataSource.h"
#import <objc/runtime.h>
#import <OCMock/OCMock.h>

extern void __gcov_flush();

@interface ScheduleTableDataSourceTests : XCTestCase
@property (strong, nonatomic) BBAScheduleTableDataSource *tableDataSource;
@end

@implementation ScheduleTableDataSourceTests

- (void)setUp {
    [super setUp];
    [self setupDataStack];
    _tableDataSource = [[BBAScheduleTableDataSource alloc] init];
}

- (void)setupDataStack {
    [BBAServiceProvider deleteServiceOfClass:[BBADataStack class]];
    [BBAModelStack installInMemoryStoreWithMergedBundle];
}

- (void)tearDown {
    __gcov_flush();
    _tableDataSource = nil;
    [super tearDown];
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
    [Schedule insertWithTitle:@"Test" logo:nil backGround:0];
    XCTAssertTrue(self.tableDataSource.dataSource.fetchedObjects.count == 1,
                  @"The dataSource should only contain a single item at this point.");
}

- (void)testDataSourceContainsOneHundredObjects {
    for (int i = 0; i < 100; i++) {
        [Schedule insertWithTitle:@"Test" logo:nil backGround:0];
    }
    XCTAssertTrue(self.tableDataSource.dataSource.fetchedObjects.count == 100,
                  @"The dataSource should contain 100 items at this point.");
}

@end
