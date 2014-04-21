//
//  ScheduleTests.m
//  Visual Scheduler
//
//  Created by Brian Pedersen on 21/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Schedule.h"
#import "Repository.h"
#import "Pictogram.h"

@interface ScheduleTests : XCTestCase

@end

@implementation ScheduleTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssert(YES, @"was not yes");
}

-(void)testCanAddPictogramToEndOfSchedule{
    Schedule* schedule = [[Repository defaultRepository]scheduleWithTitle:@"someSchedule" withColor:[UIColor whiteColor]];
    NSString *title = @"Test domain";
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    Pictogram *pictogram = [[Repository defaultRepository] pictogramWithTitle:title withImage:testImage];
    [[Repository defaultRepository]addPictogram:pictogram toSchedule:schedule atIndex:0];
    XCTAssert([[schedule pictograms] count] == 1, @"did not contain one pictogram");
}

@end
