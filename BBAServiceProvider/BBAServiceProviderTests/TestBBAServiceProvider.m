#import <XCTest/XCTest.h>
#import "BBAServiceProvider.h"

@interface TestBBAServiceProvider : XCTestCase

@end

@implementation TestBBAServiceProvider

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

-(void)testCanInsertAndRetrieve{
    [BBAServiceProvider insertService:self];
    id service = [BBAServiceProvider serviceFromClass:[self class]];
    XCTAssertNotNil(service, @"returned service was nil");
    XCTAssert([service isKindOfClass:[self class]], @"did not return the expected service");
}

-(void)testInitThrows{
    XCTAssertThrows([[BBAServiceProvider alloc]init], @"-init did not throw");
}

@end
