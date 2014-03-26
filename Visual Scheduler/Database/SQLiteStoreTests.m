#import <XCTest/XCTest.h>
#import "SQLiteStore.h"
#import "DataStoreProtocol.h"

@interface SQLiteStoreTests : XCTestCase {
    SQLiteStore *_dataStore;
}
@end

@implementation SQLiteStoreTests

- (void)setUp {
    [super setUp];
    _dataStore = [[SQLiteStore alloc] init];
}

- (void)tearDown {
    [_dataStore closeStore];
    _dataStore = nil;
    [super tearDown];
}

- (void)testConfrontsToDataStoreProtocol {
    XCTAssert([_dataStore conformsToProtocol:@protocol(DataStoreProtocol)] == YES);
}

- (void)testCanEstablishDatabaseConnection {
    XCTAssertNoThrow([[SQLiteStore alloc] init], @"Failed to establish database connection.");
}

- (void)testContentOfAllSchedules {
    NSArray *content = [_dataStore contentOfAllSchedules];
    XCTAssertNotNil(content, @"Received invalid content.");
}

- (void)testCanCreateSchedule {
    NSDictionary *schedule = @{@"title" : @"Test domain", @"color" : [NSNumber numberWithInt:0]};
    XCTAssertNoThrow([_dataStore createSchedule:schedule], @"Insert failed.");
}

- (void)testContainsCreatedSchedule {
    NSDictionary *schedule = @{@"title" : @"Test domain", @"color" : [NSNumber numberWithInt:0]};
    [_dataStore createSchedule:schedule];
    NSArray *allSchedules = [_dataStore contentOfAllSchedules];
    BOOL found = NO;
    for (NSDictionary *dict in allSchedules) {
        if ([[dict valueForKey:@"title"] isEqualToString:[schedule valueForKey:@"title"]] &&
            [[dict valueForKey:@"color"] isEqualToNumber:[schedule valueForKey:@"color"]]) {
            found = YES;
            break;
        }
    }
    XCTAssertTrue(found);
}

- (void)testCanDeleteSchedule {
    NSDictionary *schedule = @{@"title" : @"Test domain", @"color" : [NSNumber numberWithInt:0]};
    NSInteger scheduleIdentifier = [_dataStore createSchedule:schedule];
    [_dataStore deleteScheduleWithID:scheduleIdentifier];
    
    NSArray *allSchedules = [_dataStore contentOfAllSchedules];
    BOOL found = NO;
    for (NSDictionary *dict in allSchedules) {
        if ([[dict valueForKey:@"id"] isEqualToNumber:[NSNumber numberWithInteger:scheduleIdentifier]]) {
            found = YES;
            break;
        }
    }
    XCTAssertFalse(found);
}

- (void)testCanCloseStore {
    XCTAssertTrue([_dataStore closeStore] == YES, @"Failed to close the store.");
}

#pragma mark - Pictograms

- (void)testContentOfAllPictograms {
    NSArray *content = [_dataStore contentOfAllPictograms];
    XCTAssertNotNil(content, @"Received invalid content.");
}

- (void)testCreatePictogram {
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    XCTAssertNotNil(testImage, @"Failed to load the test image.");
    
    NSDictionary *pictogram = @{@"title" : @"Test domain",
                                @"image" : UIImagePNGRepresentation(testImage)};
    XCTAssertNoThrow([_dataStore createPictogram:pictogram], @"Failed to create a pictogram.");
}

@end
