#import <XCTest/XCTest.h>
#import "ColorView.h"

@interface ColorView_Tests : XCTestCase
@property ColorView *colorView;
@end

@implementation ColorView_Tests

- (void)setUp
{
    [super setUp];
    self.colorView = [[ColorView alloc] init];
}

- (void)tearDown
{
    self.colorView = nil;
    [super tearDown];
}

- (void)testBackgroundColorSettableThroughColor
{
    XCTAssertTrue(self.colorView.color == nil, @"Did not expect a color.");
    UIColor * const color = [UIColor blueColor];
    self.colorView.color = color;
    XCTAssertTrue([self.colorView.color isEqual:color], @"Failed to set color.");
    XCTAssertTrue([self.colorView.backgroundColor isEqual:color], @"Failed to set color.");
}

@end
