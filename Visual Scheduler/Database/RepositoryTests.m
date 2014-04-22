#import <XCTest/XCTest.h>
#import "Repository.h"
#import "SQLiteStore.h"
#import "Schedule.h"
#import "Pictogram.h"

@interface RepositoryTests : XCTestCase {
    Repository *_repo;
}

@end

@implementation RepositoryTests

- (void)setUp
{
    [super setUp];
    _repo = [Repository defaultRepository];
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

- (void)testCanGetAtleastTwoSchedules {
    [_repo scheduleWithTitle:@"Test Domain 1" withColor:[UIColor whiteColor]];
    [_repo scheduleWithTitle:@"Test Domain 2" withColor:[UIColor whiteColor]];
    NSArray *schedules = [_repo allSchedules];
    XCTAssert([schedules count] >= 2, @"Expected atleast 2 schedules.");
}

#pragma mark - Pictogram
- (void)testCanCreatePictogram {
    NSString *title = @"Test domain";
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    Pictogram *pictogram = [_repo pictogramWithTitle:title withImage:testImage];
    XCTAssertNotNil(pictogram, @"Failed to create pictogram.");
    XCTAssertTrue([title isEqualToString:pictogram.title], @"Title mismatch.");
    XCTAssertTrue([testImage isEqual:pictogram.image], @"Image mismatch.");
}

- (void)testCanGetAtleastTwoPictograms {
    [_repo pictogramWithTitle:@"Test Domain 1" withImage:[UIImage imageNamed:@"testImage"]];
    [_repo pictogramWithTitle:@"Test Domain 2" withImage:[UIImage imageNamed:@"testImage"]];
    NSArray *pictograms = [_repo allPictogramsIncludingImages:NO];
    XCTAssertTrue(pictograms.count >= 2, @"Expected atleast 2 pictograms.");
}

-(void)testCanAddPictogramsToSchedule{
    Schedule* schedule = [_repo scheduleWithTitle:@"Test Domain" withColor:[UIColor whiteColor]];
    Pictogram* pictogram1 = [_repo pictogramWithTitle:@"Test Domain 1" withImage:[UIImage imageNamed:@"testImage"]];
    Pictogram* pictogram2 = [_repo pictogramWithTitle:@"Test Domain 2" withImage:[UIImage imageNamed:@"testImage"]];
    [_repo addPictogram:pictogram1 toSchedule:schedule atIndex:0];
    [_repo addPictogram:pictogram2 toSchedule:schedule atIndex:1];
    NSArray* pictogramsInSchedule = [_repo pictogramsForSchedule:schedule includingImages:NO];
    XCTAssert([pictogramsInSchedule count] >= 2, @"pictograms were not added");
}

- (void)testDoesRemoveAllPictogramsFromSchedule {
    Schedule* schedule = [_repo scheduleWithTitle:@"Test Domain" withColor:[UIColor whiteColor]];
    Pictogram* pictogram1 = [_repo pictogramWithTitle:@"Test Domain 1" withImage:[UIImage imageNamed:@"testImage"]];
    Pictogram* pictogram2 = [_repo pictogramWithTitle:@"Test Domain 2" withImage:[UIImage imageNamed:@"testImage"]];
    [_repo addPictogram:pictogram1 toSchedule:schedule atIndex:0];
    [_repo addPictogram:pictogram2 toSchedule:schedule atIndex:1];
    NSArray* pictogramsInSchedule = [_repo pictogramsForSchedule:schedule includingImages:NO];
    XCTAssert([pictogramsInSchedule count] >= 2, @"pictograms were not added");
    
    [_repo removeAllPictogramsFromSchedule:schedule];
    pictogramsInSchedule = [_repo pictogramsForSchedule:schedule includingImages:NO];
    XCTAssert(pictogramsInSchedule.count == 0, @"Failed to remove all pictograms from schedule.");
}

-(void)testCanInsertAndRetrievePictogram{
    Pictogram* pictogram = [_repo pictogramWithTitle:@"Test Domain 1" withImage:[UIImage imageNamed:@"testImage"]];
    UIImage* image = [pictogram image];
    XCTAssert(image, @"could not retrieve image");
}


@end

