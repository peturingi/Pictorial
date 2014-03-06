//
//  TestBBAContext.m
//  TestCoreData
//
//  Created by Brian Pedersen on 02/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBAContext.h"
#import "BBAModel.h"
#import "BBAStore.h"
#import "HelperMethodsForTests.h"

//#define TEST_STORE_FILE @"TestBBAContext.sqlite"

@interface TestBBAContext : XCTestCase

@end

@implementation TestBBAContext

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

-(void)testCreatesValidManagedObjectContext{
    BBAModel* model = [BBAModel modelFromModelNamed:kBBATestModel];
    NSURL* storeFile = [self storeFileURLForTestNamed:@"ValidMOC"];
    BBAStore* store = [BBAStore storeWithModel:[model managedObjectModel] andStoreFileURL:storeFile];
    BBAContext* context = [BBAContext contextWithStore:[store persistentStoreCoordinator]];
    NSManagedObjectContext* managedObjectContext = [context managedObjectContext];
    XCTAssertNotNil(managedObjectContext, @"managedObjectContext was nil");
}

-(void)testNilStoreThrows{
    XCTAssertThrows([BBAContext contextWithStore:nil], @"nil store did not throw");
}

-(void)testInitThrows{
    XCTAssertThrows([[BBAContext alloc]init], @"-init did not throw");
}

#pragma mark - helper methods
-(NSURL*)storeFileURLForTestNamed:(NSString*)testName{
    NSString* fileName = [HelperMethodsForTests storefileNameForTest:self andMethodName:testName];
    return [HelperMethodsForTests URLForStorefileNamed:fileName];
}

@end
