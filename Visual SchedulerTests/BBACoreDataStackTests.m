#import <XCTest/XCTest.h>

#import "BBACoreDataStack.h"
#import "BBAServiceProvider.h"
#import "Schedule.h"

@interface BBACoreDataStackTests : XCTestCase
@property (strong, nonatomic) BBACoreDataStack *sharedStack;
@end

@implementation BBACoreDataStackTests

- (void)setUp {
    [super setUp];
    [BBAServiceProvider deleteServiceOfClass:[BBACoreDataStack class]];
    [BBACoreDataStack installInMemory:YES];
}

- (void)tearDown {
    [BBAServiceProvider deleteServiceOfClass:[BBACoreDataStack class]];
    [super tearDown];
}

- (void)testCanGetSharedStack {
    XCTAssertNotNil([BBACoreDataStack sharedInstance],
                    @"Failed to setup sharedStack.");
}

- (void)testReturnsManagedObjectContext {
    NSManagedObjectContext *objectContext = [BBACoreDataStack managedObjectContext];
    XCTAssertNotNil(objectContext,
                 @"Failed to get managedObjectContext");
}

- (void)testReturnsSharedManagedObjectContext {
    NSManagedObjectContext *firstManagedObjectContext = [BBACoreDataStack managedObjectContext];
    NSManagedObjectContext *secondManagedObjectContext = [BBACoreDataStack managedObjectContext];
    XCTAssertEqualObjects(firstManagedObjectContext, secondManagedObjectContext,
                          @"Failed to receive a shared instance. The two objects must not be unique.");
}

#pragma mark - Pictogram

- (void)testFetchedResultsControllerForPictogram {
    XCTAssertNotNil([BBACoreDataStack fetchedResultsControllerForClass:[Pictogram class]], @"Could not retrieve fetchedResultsControllerForPictogram.");
}

#pragma mark - Schedule

- (void)testCanInsertScheduleToManagedObjectContext {
    NSManagedObject *schedule = [BBACoreDataStack createObjectInContexOfClass:[Schedule class]];
    XCTAssertNotNil(schedule, @"Failed to insert object into the managed object context.");
}

-(void)testCanSaveContextForSchedule{
    NSFetchedResultsController* frc = [BBACoreDataStack fetchedResultsControllerForClass:[Schedule class]];
    [frc performFetch:nil];
    int itemsBeforeSave = [[frc fetchedObjects]count];
    
    Schedule* schedule = (Schedule*)[BBACoreDataStack createObjectInContexOfClass:[Schedule class]];
    [schedule setColour:[NSNumber numberWithInt:1]];
    [schedule setDate:[NSDate date]];
    [schedule setTitle:@"someTitle"];
    NSError* saveError = nil;
    BOOL saveSuccessful = [BBACoreDataStack saveContext:&saveError];
    XCTAssertTrue(saveSuccessful, @"Error while saving");
    
    [frc performFetch:nil];
    int itemsAfterSave = [[frc fetchedObjects]count];
    XCTAssertEqual(itemsBeforeSave, itemsAfterSave - 1, @"Expected increase in the number of items after saving a new item");
    
}

- (void)testFetchedResultsControllerForSchedule {
    XCTAssertNotNil([BBACoreDataStack fetchedResultsControllerForClass:[Schedule class]], @"Could not retrieve fetchedResultsControllerForSchedule.");
}

#pragma mark -

@end
