//
//  TestBBACoreDataStack.m
//  TestCoreData
//
//  Created by Brian Pedersen on 02/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBADataStack.h"
#import "HelperMethodsForTests.h"
#import "TestEntity.h"

@interface TestBBACoreDataStack : XCTestCase

@end

@implementation TestBBACoreDataStack

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

-(void)testDeleteAndReset{
    NSString* storeFile = [self storeFileForTestNamed:@"DeleteAndReset"];
    BBADataStack* stack = [BBADataStack stackWithModelNamed:kBBATestModel andStoreFileNamed:storeFile];
    [stack insertNewManagedObjectFromClass:[TestEntity class]];
    NSFetchRequest* fr = [stack fetchRequestForEntityClass:[TestEntity class]];
    NSArray* result = [stack resultFromFetchRequest:fr];
    XCTAssert([result count] > 0, @"array was either nil or empty");
    [stack deleteStoreAndResetStack];
    result = [stack resultFromFetchRequest:fr];
    XCTAssertNotNil(result, @"array was nil");
    XCTAssert([result count] == 0, @"array was not empty");
}

-(void)testInitThrows{
    XCTAssertThrows([[BBADataStack alloc]init], @"-init did not throw");
}

#pragma mark - helper methods
-(NSString*)storeFileForTestNamed:(NSString*)testName{
    return [HelperMethodsForTests storefileNameForTest:self andMethodName:testName];
}
@end
