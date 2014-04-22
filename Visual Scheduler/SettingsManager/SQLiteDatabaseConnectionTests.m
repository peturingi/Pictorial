//
//  SQLiteDatabaseConnectionTests.m
//  Visual Scheduler
//
//  Created by Brian Pedersen on 20/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SQLiteDatabaseConnection.h"

@interface SQLiteDatabaseConnectionTests : XCTestCase

@end

@implementation SQLiteDatabaseConnectionTests

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

-(void)testInitWithInvalidFilenameThrows{
    XCTAssertThrows([[SQLiteDatabaseConnection alloc]initWithDatabaseFileNamed:@"InvalidFilename"], @"did not throw as expected");
}

-(void)testPrepareStatementWithNilStringThrows{
    SQLiteDatabaseConnection* dbcon = [[SQLiteDatabaseConnection alloc]initWithDatabaseFileNamed:@"settings.sqlite3"];
    XCTAssertThrows([dbcon prepareStatementWithQuery:nil], @"did not throw");
}

-(void)testPrepareStatementWithEmptyStringThrows{
    SQLiteDatabaseConnection* dbcon = [[SQLiteDatabaseConnection alloc]initWithDatabaseFileNamed:@"settings.sqlite3"];
    XCTAssertThrows([dbcon prepareStatementWithQuery:@""], @"did not throw");
}

@end
