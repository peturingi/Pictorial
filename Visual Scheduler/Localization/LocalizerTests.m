//
//  LocalizationManagerTests.m
//  Visual Scheduler
//
//  Created by Brian Pedersen on 19/04/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Localizer.h"

@interface LocalizerTests : XCTestCase

@end

@implementation LocalizerTests

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


-(void)testCanInstatiate{
    XCTAssertNoThrow([[Localizer alloc]initLocalizerForLocale:@"some_locale"], @"could not instantiate");
}

-(void)testInvalidInitThrows{
    XCTAssertThrows([[Localizer alloc]init], @"did not throw");
}

-(void)testCanLocalizeToDanish{
    Localizer* localizeManager = [[Localizer alloc]initLocalizerForLocale:@"da_DK"];
    NSString* milk = @"milk";
    NSString* expected = @"mælk";
    NSString* translatedString = [localizeManager localizeString:milk];
    XCTAssert([translatedString isEqualToString:expected], @"was not properly translated");
}

-(void)testCanLocalizeToIslandic{
    Localizer* localizeManager = [[Localizer alloc]initLocalizerForLocale:@"is_IS"];
    NSString* milk = @"milk";
    NSString* expected = @"mjólk";
    NSString* translatedString = [localizeManager localizeString:milk];
    XCTAssert([translatedString isEqualToString:expected], @"was not properly translated");
}

-(void)testNonTranslateableStringReturnsSameStringLowercased{
    NSString* string = @"Guggenheimer-Feinsmecker";
    NSString* expected = string.lowercaseString;
    NSString* translatedString = [[Localizer defaultLocalizer]localizeString:string];
    XCTAssert([translatedString isEqualToString:expected], @"was not equal");
}
@end
