//
//  TestBBAFileManager.m
//  BBAFileManager
//
//  Created by Brian Pedersen on 05/03/14.
//  Copyright (c) 2014 BBA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBAFileManager.h"

@interface TestBBAFileManager : XCTestCase

@end

@implementation TestBBAFileManager

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

-(void)testSaveImageAtLocation{
    NSString* filename = @"testedImage";
    NSString* saveLocation = [[[self class]bundleLocation]stringByAppendingPathComponent:filename];
    UIImage* image = [[self class] imageWithName:@"testImage" andType:@"png"];
    [BBAFileManager saveImage:image atLocation:saveLocation];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveLocation];
    XCTAssert(fileExists, @"file was not saved at the specified location");
    [[NSFileManager defaultManager] removeItemAtPath:saveLocation error:nil];
}

-(void)testUniqueFileNameIsGenerated{
    NSString* prefix = @"prefix-";
    NSString* uniqueFileName = [BBAFileManager uniqueFileNameWithPrefix:prefix];
    XCTAssertNotEqual(uniqueFileName, prefix, @"did not generate unique filename");
}

#pragma mark Helper methods
+(UIImage*)imageWithName:(NSString*)name andType:(NSString*)type{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:name ofType:type];
    return [UIImage imageWithContentsOfFile:imagePath];
}

+(NSString*)bundleLocation{
    return [[NSBundle bundleForClass:[self class]]bundlePath];
}
@end
