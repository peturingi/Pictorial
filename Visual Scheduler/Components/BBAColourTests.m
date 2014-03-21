#import <XCTest/XCTest.h>
#import "BBAColor.h"

@interface BBAColourTests : XCTestCase

@end

@implementation BBAColourTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGreenIsZero {
    UIColor *receivedColor = [BBAColor colorForIndex:0];
    UIColor *expectedColor = [UIColor greenColor];
    XCTAssertTrue([receivedColor isEqual:expectedColor], @"Did not receieve correct colour.");
}

- (void)testPurpleIsOne {
    UIColor *receivedColor = [BBAColor colorForIndex:1];
    UIColor *expectedColor = [UIColor purpleColor];
    XCTAssertTrue([receivedColor isEqual:expectedColor], @"Did not receive correct colour.");
}

- (void)testZeroIsGreen {
    NSUInteger receivedIndex = [BBAColor indexForColor:[UIColor greenColor]];
    NSUInteger expectedIndex = 0;
    XCTAssertTrue(receivedIndex == expectedIndex, @"Did not receieve correct colourIndex.");
}

- (void)testOneIsPurple {
    NSUInteger receivedIndex = [BBAColor indexForColor:[UIColor purpleColor]];
    NSUInteger expectedIndex = 1;
    XCTAssertTrue(receivedIndex == expectedIndex, @"Did not receieve correct colourIndex.");
}

- (void)testSevenIsNotAColor {
    XCTAssertThrows([BBAColor colorForIndex:7], @"Expected exception when requesting undefined color index.");
}

- (void)testGrayHasNoColorIndex {
    XCTAssertThrows([BBAColor indexForColor:[UIColor grayColor]], @"Expected exception when requesting undefined color");
}

@end
