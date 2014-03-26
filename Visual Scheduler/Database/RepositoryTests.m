#import <XCTest/XCTest.h>
#import "Repository.h"
#import "SQLiteStore.h"
#import "Schedule.h"

@interface RepositoryTests : XCTestCase {
    Repository *_repo;
}

@end

@implementation RepositoryTests

- (void)setUp
{
    [super setUp];
    SQLiteStore *store = [[SQLiteStore alloc] init];
    _repo = [[Repository alloc] initWithStore:store];
}

- (void)tearDown {
    _repo = nil;
    [super tearDown];
}

#pragma mark - Schedule
- (void)testCanCreateSchedule {
    NSString *title = @"Test domain";
    UIColor *white = [UIColor whiteColor];
    Schedule *schedule = [_repo scheduleWithTitle:title withColor:white];
    XCTAssertNotNil(schedule, @"Failed to create schedule.");
    XCTAssertTrue([schedule.title isEqualToString:title], @"Wrong title.");
    XCTAssertTrue([schedule.color isEqual:white], @"Wrong color.");
}


@end
