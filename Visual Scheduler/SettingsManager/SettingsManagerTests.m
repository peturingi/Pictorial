//
//  SettingsManagerTests.m
//  Visual Scheduler
//
//  Created by Brian Pedersen on 17/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SettingsManager.h"

@interface SettingsManagerTests : XCTestCase

@end

@implementation SettingsManagerTests{
    SettingsManager* _manager;
}

- (void)setUp
{
    [super setUp];
    _manager = [[SettingsManager alloc]init];
}

- (void)tearDown
{
    _manager = nil;
    [super tearDown];
}

-(void)testCanInstantiate{
    XCTAssertNoThrow([[SettingsManager alloc]init], @"Could not instantiate");
}

-(void)testCanSetIntegerValueForKey{
    NSString* key = @"someKey";
    NSInteger value = 20;
    NSInteger expectedValue = value;
    [_manager setIntegerValue:value forKey:key];
    value = [_manager integerValueForKey:key];
    XCTAssertEqual(expectedValue, value, @"value was not the same");
}

-(void)testSettingIntegerValueForExistingKeyUpdatesValue{
    NSString* key = @"SomeKey";
    NSInteger value = 20;
    NSInteger expectedValue = value;
    [_manager setIntegerValue:value forKey:key];
    XCTAssertEqual(expectedValue, value, @"value was not the same");
    value = 40;
    expectedValue = value;
    [_manager setIntegerValue:value forKey:key];
    XCTAssertEqual(expectedValue, value, @"value was not the same");
}

-(void)testInvalidIntegerKeyThrows{
    XCTAssertThrows([_manager integerValueForKey:@"Some Invalid Key"], @"did not throw as expected");
}

-(void)testCanSetStringValueForKey{
    NSString* key = @"someKey";
    NSString* value = @"someValue";
    NSString* expectedValue = [NSString stringWithString:value];
    [_manager setStringValue:value forKey:key];
    value = [_manager stringValueForKey:key];
    XCTAssertTrue([expectedValue isEqualToString:value], @"the strings were not equal");
}

-(void)testSettingStringValueForExistingKeyUpdatesValue{
    NSString* key = @"someKey";
    NSString* value = @"someValue";
    NSString* expectedValue = [NSString stringWithString:value];
    [_manager setStringValue:value forKey:key];
    value = [_manager stringValueForKey:key];
    XCTAssertTrue([expectedValue isEqualToString:value], @"the strings were not equal");
    value = @"someOtherValue";
    expectedValue = [NSString stringWithString:value];
    [_manager setStringValue:value forKey:key];
    value = [_manager stringValueForKey:key];
    XCTAssertTrue([expectedValue isEqualToString:value], @"the strings were not equal");
}

-(void)testCanSetNumberForKey{
    NSNumber* value = [NSNumber numberWithInteger:20];
    NSNumber* expectedValue = [NSNumber numberWithInteger:[value integerValue]];
    NSString* key = @"someKey";
    XCTAssertEqual(value.integerValue, expectedValue.integerValue, @"values were not equal");
    [_manager setNumber:value forKey:key];
    XCTAssertTrue([[_manager numberForKey:key]isKindOfClass:[NSNumber class]], @"did not return an NSNumber");
    value = [_manager numberForKey:key];
    XCTAssertEqual(value.integerValue, expectedValue.integerValue, @"values were not equal");
    XCTAssertTrue([expectedValue compare:value] == NSOrderedSame, @"the values were not equal");
}

-(void)testCanSetNumberContainingBoolValueForKey{
    NSNumber* value = [NSNumber numberWithBool:YES];
    NSNumber* expectedValue = [NSNumber numberWithBool:[value boolValue]];
    NSString* key = @"someKey";
    [_manager setNumber:value forKey:key];
    value = [_manager numberForKey:key];
    XCTAssertEqual(value.boolValue, expectedValue.boolValue, @"values were not equal");
    XCTAssertTrue([expectedValue compare:value] == NSOrderedSame, @"the values were not equal");
}
@end
