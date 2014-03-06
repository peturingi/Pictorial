//
//  TestBBAModel.m
//  TestCoreData
//
//  Created by Brian Pedersen on 02/03/14.
//  Copyright (c) 2014 TestOrg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBAModel.h"
#import "HelperMethodsForTests.h"

@interface TestBBAModel : XCTestCase

@end

@implementation TestBBAModel

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

-(void)testCreatesValidManagedObjectModel{
    BBAModel* model = [BBAModel modelFromModelNamed:kBBATestModel];
    NSManagedObjectModel* objectModel = [model managedObjectModel];
    XCTAssertNotNil(objectModel, @"object model was nil");
}

-(void)testEmptyModelNameThrows{
    XCTAssertThrows([BBAModel modelFromModelNamed:@""], @"empty model name did not throw");
}

-(void)testNilModelNameThrows{
    XCTAssertThrows([BBAModel modelFromModelNamed:nil], @"nil model name did not throw");
    
}

-(void)testInvalidModelNameThrows{
    XCTAssertThrows([BBAModel modelFromModelNamed:@"InvalidModeName"], @"invalid model name did not throw");
}

-(void)testInitThrows{
    XCTAssertThrows([[BBAModel alloc]init], @"-init did not throw");
}

@end
