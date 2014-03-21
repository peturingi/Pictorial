#import <XCTest/XCTest.h>
#import "UIApplication+BBA.h"

@interface UIApplicationTests : XCTestCase {
}

@end

@implementation UIApplicationTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCanGetDocumentDirectory {
    XCTAssert([[UIApplication documentDirectory] length] > 0, @"Path to document directory should be longer than 0 characters.");
}

- (void)testDocumentDirectoryIsWritable {
    NSString *documentDirectory = [UIApplication documentDirectory];
    XCTAssert([[NSFileManager defaultManager] isWritableFileAtPath:documentDirectory] == YES, @"The document directory should be writable! It could be that the wrong document directory was returned.");
}

- (void)testUniqueFilenameIsNotEmpty {
    XCTAssertTrue([[UIApplication uniqueFileNameWithPrefix:@""] length] > 0, @"No filename returned.");
}

- (void)testRequesetForTwoUniqueFilenamesReturnsTwoUniques {
    NSString *uniqueFile1 = [UIApplication uniqueFileNameWithPrefix:@"Test-Domain"];
    NSString *uniqueFile2 = [UIApplication uniqueFileNameWithPrefix:@"Test-Domain"];
    XCTAssertFalse([uniqueFile1 isEqualToString:uniqueFile2], @"A request for two unique filenames, should not result in identical filenames!");
}

@end
