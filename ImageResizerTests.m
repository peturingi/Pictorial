#import <XCTest/XCTest.h>
#import "ImageResizer.h"

@interface ImageResizerTests : XCTestCase

@end

@implementation ImageResizerTests

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

- (void)testReturnsNilWithNoImage
{
    ImageResizer *imageResizer = [[ImageResizer alloc] init];
    XCTAssertNil([imageResizer getImageResizedTo:CGSizeMake(100,100)]);
    imageResizer = nil;
}

- (void)testResize
{
    const CGSize size = CGSizeMake(100, 100);
    ImageResizer *imageResizer = [[ImageResizer alloc] initWithImage:[self getBlankImageWithSize:size]];
    const CGSize newSize = CGSizeMake(50, 50);
    UIImage *resizedImage = [imageResizer getImageResizedTo:newSize];
    XCTAssert(newSize.height == resizedImage.size.height && newSize.width == resizedImage.size.width, @"Resize failed.");
}

- (UIImage *)getBlankImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return blank;
}

@end
