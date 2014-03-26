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

- (void)testDeletePictogramWithID {
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    XCTAssertNotNil(testImage, @"Failed to load the test image.");
    
    NSDictionary *pictogram = @{@"title" : @"Test domain",
                                @"image" : UIImagePNGRepresentation(testImage)};
    NSInteger identifierOfNewPictogram = [_dataStore createPictogram:pictogram];
    BOOL deleted = NO;
    XCTAssertNoThrow(deleted = [_dataStore deletePictogramWithID:identifierOfNewPictogram], @"Failed to delete.");
    XCTAssert(deleted == YES, @"Failed to delete.");
}

- (void)testDeleteNonExistingPictogramThrows {
    XCTAssertThrows([_dataStore deletePictogramWithID:1000000], @"Expected an exception when attempting to delete a nonexcisting pictogram.");
}

- (void)testAddingPictogramToScheduleAtInvalidIndexThrows {
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    XCTAssertNotNil(testImage, @"Failed to load the test image.");
    
    NSDictionary *pictogram = @{@"title" : @"Test domain",
                                @"image" : UIImagePNGRepresentation(testImage)};
    NSInteger pictogramIdentifier = [_dataStore createPictogram:pictogram];

    NSDictionary *schedule = @{@"title" : @"Test domain", @"color" : [NSNumber numberWithInt:0]};
    NSInteger scheduleIdentifier = [_dataStore createSchedule:schedule];
    
   XCTAssertNoThrow([_dataStore addPictogram:pictogramIdentifier toSchedule:scheduleIdentifier atIndex:10000], @"Should not throw at valid index.");
    XCTAssertThrows([_dataStore addPictogram:pictogramIdentifier toSchedule:scheduleIdentifier atIndex:10000], @"Expected throw at invalid index.");
}

- (void)testDeletingInvalidRelationThrows {
    XCTAssertThrows([_dataStore removePictogram:999 fromSchedule:832 atIndex:121]);
}

- (void)testDeletingValidRelationNoThrow {
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    XCTAssertNotNil(testImage, @"Failed to load the test image.");
    
    NSDictionary *pictogram = @{@"title" : @"Test domain",
                                @"image" : UIImagePNGRepresentation(testImage)};
    NSInteger pictogramIdentifier = [_dataStore createPictogram:pictogram];
    
    NSDictionary *schedule = @{@"title" : @"Test domain", @"color" : [NSNumber numberWithInt:0]};
    NSInteger scheduleIdentifier = [_dataStore createSchedule:schedule];
    
    [_dataStore addPictogram:pictogramIdentifier toSchedule:scheduleIdentifier atIndex:99];
    XCTAssertNoThrow([_dataStore removePictogram:pictogramIdentifier fromSchedule:scheduleIdentifier atIndex:99], @"Expected no throw.");
}

@end
