#import <XCTest/XCTest.h>
#import "BBAStore.h"
#import "BBAModel.h"
#import "HelperMethodsForTests.h"


@interface TestBBAStore : XCTestCase

@end

@implementation TestBBAStore

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

-(void)testCreatesValidPersistentStoreCoordinator{
    BBAModel* model = [BBAModel modelFromModelNamed:kBBATestModel];
    NSURL* storeURL = [self storeFileURLForTestNamed:@"ValidPSC"];
    BBAStore* store = [BBAStore storeWithModel:[model managedObjectModel] andStoreFileURL:storeURL];
    NSPersistentStoreCoordinator* storeCoordinator = [store persistentStoreCoordinator];
    XCTAssertNotNil(storeCoordinator, @"store coordinator was nil");
    
}

-(void)testInvalidFileURLThrows{
    BBAModel* model = [BBAModel modelFromModelNamed:kBBATestModel];
    NSURL* invalidStoreURL = [NSURL URLWithString:@"Invalid Store URL"];
    XCTAssertThrows([BBAStore storeWithModel:[model managedObjectModel] andStoreFileURL:invalidStoreURL], @"invalid URL did not throw");
}

-(void)testNilStoreURLThrows{
    BBAModel* model = [BBAModel modelFromModelNamed:kBBATestModel];
    XCTAssertThrows([BBAStore storeWithModel:[model managedObjectModel] andStoreFileURL:nil], @"nil store url did not throw");
    
}

-(void)testNilModelThrows{
    NSURL* storeURL = [self storeFileURLForTestNamed:@"NilModel"];
    XCTAssertThrows([BBAStore storeWithModel:nil andStoreFileURL:storeURL], @"nil model did not throw");
}

-(void)testInitThrows{
    XCTAssertThrows([[BBAStore alloc]init], @"-init did not throw");
}

#pragma mark - helper methods
-(NSURL*)storeFileURLForTestNamed:(NSString*)testName{
    NSString* fileName = [HelperMethodsForTests storefileNameForTest:self andMethodName:testName];
    return [HelperMethodsForTests URLForStorefileNamed:fileName];
}
@end
