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
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    Pictogram* pic = [[Repository defaultRepository] pictogramWithTitle:@"pic" withImage:testImage];
    Schedule* schedule = [[Repository defaultRepository]scheduleWithTitle:@"someSchedule" withColor:[UIColor whiteColor]];
    [[Repository defaultRepository]addPictogram:pic toSchedule:schedule atIndex:0];
    XCTAssert([[schedule pictograms] count] == 1, @"did not contain one pictogram");
    [schedule addPictogram:pic atIndex:1];
    XCTAssert([[schedule pictograms] count] == 2, @"did not contain both pictograms");
}

-(void)testCanAddPictogramToMiddleOfSchedule{
    UIImage *testImage = [UIImage imageNamed:@"testImage"];
    Pictogram* pic = [[Repository defaultRepository]pictogramWithTitle:@"pic" withImage:testImage];
    Schedule* schedule = [[Repository defaultRepository]scheduleWithTitle:@"someSchedule" withColor:[UIColor whiteColor]];
    [[Repository defaultRepository]addPictogram:pic toSchedule:schedule atIndex:0];
    [[Repository defaultRepository]addPictogram:pic toSchedule:schedule atIndex:1];
    [[Repository defaultRepository]addPictogram:pic toSchedule:schedule atIndex:2];
    Pictogram* insertedPic = [[Repository defaultRepository]pictogramWithTitle:@"insertPic" withImage:testImage];
    [schedule addPictogram:insertedPic atIndex:1];
    XCTAssert([[schedule pictograms] count] == 4, @"did not contain 4 items");
    XCTAssert([[schedule pictograms] objectAtIndex:1] == insertedPic, @"was not inserted at the correct index");
    NSString* expectedTitle = [insertedPic title];
    NSString* result = [[[schedule pictograms]objectAtIndex:1] title];
    XCTAssert([result isEqualToString:expectedTitle], @"was expected pictogram at index");
}

@end
