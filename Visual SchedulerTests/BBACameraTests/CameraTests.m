#import <XCTest/XCTest.h>
#import "Camera.h"
#import "CameraDelegate.h"
#import "MockCameraDelegate.h"
#import "MockViewController.h"

@interface CameraTests : XCTestCase {
    MockViewController *mockViewController;
}
@property (strong, nonatomic) Camera *camera;
@end

@implementation CameraTests

- (void)setUp
{
    [super setUp];
    mockViewController = [[MockViewController alloc] init];
    self.camera = [[Camera alloc] init];
}

- (void)tearDown
{
    self.camera = nil;
    mockViewController = nil;
    [super tearDown];
}

- (void)testCameraExistsIfAvailable {
    XCTAssert(self.camera != nil, @"It must be possible to create a camera.");
}

- (void)testNonConformingObjectCanNotBeDelegate {
    XCTAssertThrows([self.camera setDelegate:(id)[NSNull null]],
                    @"NSNull should not be used as the delegate as it doesn't"
                    @" confront to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate {
    MockCameraDelegate *mockDelegate = [[MockCameraDelegate alloc] init];
    XCTAssert(self.camera.delegate = mockDelegate,
              @"It must be possible to assign a delegate to the camera");
}

- (void)testNilObjectCanBeDelegate {
    XCTAssertNoThrow(self.camera.delegate = nil,
                     @"It must be possible to use nil as the delegate.");
}

- (void)testCamerasViewControllerExist {
    mockViewController = [[MockViewController alloc] init];
    [self.camera setController:mockViewController];
    XCTAssert(self.camera.controller,
              @"It must be possible to assign a view controller to the camera");
}

- (void)testCameraAsksViewControllerToPresentItIfCameraIsAvailable {
    [self.camera setController:mockViewController];
    [self.camera show];
    XCTAssert(mockViewController.wasAskedToPresentViewController,
              @"Camera failed to ask viewController to present it.");
}

- (void)testCameraAsksViewControllerToPresentItWhenNoCameraIsAvailable {
    [self.camera setController:mockViewController];
    [self.camera show];
    XCTAssertFalse([Camera isAvailable] == NO && [mockViewController wasAskedToPresentViewController] == YES,
              @"The camera should not ask its viewcontroller to present a non-available camera.");
}

- (void)testCameraExistsDespiteBeingUnavailable {
    XCTAssertFalse(self.camera && [Camera isAvailable] == NO,
                   @"Camera must not be available if it does not excist.");
}

@end
