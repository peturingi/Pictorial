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

#pragma mark - general tests
-(void)testCanInstantiate{
    XCTAssertNoThrow([[SettingsManager alloc]init], @"Could not instantiate");
}

-(void)testSettingValueWithEmptyKeyThrows{
    NSString* key = @"";
    NSString* value = @"someValue";
    XCTAssertThrowsSpecificNamed([_manager setStringValue:value forKey:key], NSException, SM_STRING_INVALID_EXCEPTION, @"Did not throw the expected exception");
}

#pragma make - string value tests
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
    XCTAssertNoThrow([_manager setStringValue:value forKey:key], @"Did unexpectedly throw");
    value = [_manager stringValueForKey:key];
    XCTAssertTrue([expectedValue isEqualToString:value], @"the strings were not equal");
}

-(void)testSettingEmptyStringValueThrows{
    NSString* key = @"someKey";
    NSString* value = @"";
    XCTAssertThrowsSpecificNamed([_manager setStringValue:value forKey:key], NSException, SM_STRING_INVALID_EXCEPTION, @"Did not throw the expected exception");
}

-(void)testSettingNilStringValueThrows{
    NSString* key = @"someKey";
    NSString* value = nil;
    XCTAssertThrowsSpecificNamed([_manager setStringValue:value forKey:key], NSException, SM_STRING_INVALID_EXCEPTION, @"Did not throw the expected exception");
}

-(void)testNonExistingKeyForStringReturnsNil{
    NSString* key = @"someNonExistingKey";
    NSString* value;
    value = [_manager stringValueForKey:key];
    XCTAssert(value == nil, @"value was not nil;");
}

#pragma mark - number value tests
-(void)testCanSetNumberForKey{
    NSString* key = @"someKey";
    NSNumber* value = [NSNumber numberWithInteger:20];
    NSNumber* expectedValue = [NSNumber numberWithInteger:[value integerValue]];
    [_manager setNumber:value forKey:key];
    value = [_manager numberForKey:key];
    XCTAssertEqual(value.integerValue, expectedValue.integerValue, @"values were not equal");
    XCTAssertTrue([expectedValue compare:value] == NSOrderedSame, @"values were not equal");
}

-(void)testCanSetNumberContainingBoolValueForKey{
    NSString* key = @"someKey";
    NSNumber* value = [NSNumber numberWithBool:YES];
    NSNumber* expectedValue = [NSNumber numberWithBool:[value boolValue]];
    [_manager setNumber:value forKey:key];
    value = [_manager numberForKey:key];
    XCTAssertEqual(value.boolValue, expectedValue.boolValue, @"values were not equal");
    XCTAssertTrue([expectedValue compare:value] == NSOrderedSame, @"values were not equal");
}

-(void)testNonExistingKeyForNumberReturnsNil{
    NSString* key = @"someNonExistingKey";
    NSNumber* number;
    number = [_manager numberForKey:key];
    XCTAssert(number == nil, @"number was not nil");
}

#pragma mark - object value tests
-(void)testSetObjectWhichDoesNotConformToNSCodingThrows{
    NSString* key = @"SettingsManager";
    XCTAssertThrows([_manager setObject:_manager forKey:key], @"did not throw");
}
@end
