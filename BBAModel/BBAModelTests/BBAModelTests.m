//
//  BBAModelTests.m
//  BBAModelTests
//
//  Created by Brian Pedersen on 07/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBAModelStack.h"

@interface BBAModelTests : XCTestCase

@end

@implementation BBAModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [BBAServiceProvider deleteServiceOfClass:[BBADataStack class]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testModelStackWasNotPreviouslyInstalled{
    XCTAssertThrows([BBAServiceProvider serviceFromClass:[BBADataStack class]], @"model stack was unexpectedly installed");
    
}

-(void)testModelNamedAndStoreMethodInstallsStackInServiceProvider{
    [BBAModelStack modelNamed:@"CoreData 4" andStore:@"testStore"];
    BBADataStack* stack;
    XCTAssertNoThrow(stack = [BBAServiceProvider serviceFromClass:[BBADataStack class]], @"retrieving the service threw. It was not properly installed");
    XCTAssert(stack, @"retrieved service was nil");
}

-(void)testModeWithStoreInMemoryNamedMethodInstallsStackInServiceProvider{
    [BBAModelStack modelWithStoreInMemoryNamed:@"CoreData 4"];
    BBADataStack* stack;
    XCTAssertNoThrow(stack = [BBAServiceProvider serviceFromClass:[BBADataStack class]], @"retrieving the service threw. It was not properly installed");
    XCTAssert(stack, @"retrieved service was nil");
}


@end