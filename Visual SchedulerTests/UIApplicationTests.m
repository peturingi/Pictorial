#import <XCTest/XCTest.h>
#import "UIApplication+BBA.h"

@interface UIApplicationTests : XCTestCase {
    UIApplication *sharedApplication;
}

@end

@implementation UIApplicationTests

- (void)setUp
{
    sharedApplication = [UIApplication sharedApplication];
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCanGetSharedApplication {
    XCTAssertNotNil(sharedApplication);
}

- (void)testCanGetDocumentDirectory {
    XCTAssert([[sharedApplication documentDirectory] length] > 0, @"Path to document directory should be longer than 0 characters.");
}

- (void)testDocumentDirectoryIsWritable {
    NSString *documentDirectory = [sharedApplication documentDirectory];
    XCTAssert([[NSFileManager defaultManager] isWritableFileAtPath:documentDirectory] == YES, @"The document directory should be writable! It could be that the wrong document directory was returned.");
}

- (void)testUniqueFilenameIsNotEmpty {
    XCTAssertTrue([[sharedApplication uniqueFileNameWithPrefix:@""] length] > 0, @"No filename returned.");
}

- (void)testRequesetForTwoUniqueFilenamesReturnsTwoUniques {
    NSString *uniqueFile1 = [sharedApplication uniqueFileNameWithPrefix:@"Test-Domain"];
    NSString *uniqueFile2 = [sharedApplication uniqueFileNameWithPrefix:@"Test-Domain"];
    XCTAssertFalse([uniqueFile1 isEqualToString:uniqueFile2], @"A request for two unique filenames, should not result in identical filenames!");
}

@end
