#import <XCTest/XCTest.h>

#import "BBACoreDataStack.h"
#import "Schedule.h"

@interface BBACoreDataStackTests : XCTestCase
@property (strong, nonatomic) BBACoreDataStack *sharedStack;
@end

@implementation BBACoreDataStackTests

- (void)setUp {
    [super setUp];
    _sharedStack = [BBACoreDataStack sharedInstance];
}

- (void)tearDown {
    [[self.sharedStack sharedManagedObjectContext] reset];
    _sharedStack = nil;
    [super tearDown];
}

- (void)testCanGetSharedStack {
    XCTAssertNotNil(self.sharedStack,
                    @"Failed to setup sharedStack.");
}

- (void)testDoesNotReturnNewInstance {
    BBACoreDataStack *stackNumberTwo = [BBACoreDataStack sharedInstance];
    XCTAssertEqualObjects(self.sharedStack, stackNumberTwo,
                          @"The same instance must always be returned.");
}

- (void)testReturnsManagedObjectContext {
    NSManagedObjectContext *objectContext = [self.sharedStack sharedManagedObjectContext];
    XCTAssertNotNil(objectContext,
                 @"Failed to get managedObjectContext");
}

- (void)testReturnsSharedManagedObjectContext {
    NSManagedObjectContext *firstManagedObjectContext = [self.sharedStack sharedManagedObjectContext];
    NSManagedObjectContext *secondManagedObjectContext = [self.sharedStack sharedManagedObjectContext];
    XCTAssertEqualObjects(firstManagedObjectContext, secondManagedObjectContext,
                          @"Failed to receive a shared instance. The two objects must not be unique.");
}

#pragma mark - Pictogram

#pragma mark - Schedule

- (void)testOffersSchedule {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:[self.sharedStack sharedManagedObjectContext]];
    XCTAssertNotNil(entityDescription, @"The managed object context failed to return an entity named Schedule.");
}

- (void)testCanInsertScheduleToManagedObjectContext {
    NSManagedObject *schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:[self.sharedStack sharedManagedObjectContext]];
    XCTAssertNotNil(schedule, @"Failed to insert object into the managed object context.");
}

- (void)testSaveSchedule {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Schedule"
                                              inManagedObjectContext:[[BBACoreDataStack sharedInstance] sharedManagedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *fetchError;
    NSArray *items = [[[BBACoreDataStack sharedInstance] sharedManagedObjectContext]
                      executeFetchRequest:fetchRequest error:&fetchError];
    NSInteger numberOfSchedulesBeforeTest = [items count];
    
   Schedule *schedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:[self.sharedStack sharedManagedObjectContext]];
    [schedule setDate:[NSDate date]];
    [schedule setTitle:@"Test Domain"];
    [schedule setColour:[NSNumber numberWithInteger:0]];
    NSError *saveError = nil;
    BOOL saveSuccessful = [[self.sharedStack sharedManagedObjectContext] save:&saveError];
    XCTAssertTrue(saveSuccessful == YES, @"Error while saving.");
    
    
    items = [[[BBACoreDataStack sharedInstance] sharedManagedObjectContext] executeFetchRequest:fetchRequest error:&fetchError];
    XCTAssertTrue(numberOfSchedulesBeforeTest == [items count] - 1, @"Expected increase in the number of items after saving a new item.");
}

- (void)testFetchedResultsControllerForSchedule {
    XCTAssertNotNil([self.sharedStack fetchedResultsControllerForSchedule], @"Could not retrieve fetchedResultsControllerForSchedule.");
}

#pragma mark -

@end
