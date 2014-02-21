//
//  SearchViewControllerTests.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 22/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchViewController.h"
#import "SearchViewControllerDelegate.h"

@interface SearchViewControllerTests : XCTestCase <SearchViewControllerDelegate> {
    BOOL _searchViewControllerDidCancelSearch_wasCalled;
}
    @property SearchViewController *searchViewController;
@end

@interface SearchViewController (test)
    - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
@end

@implementation SearchViewControllerTests

- (void)setUp
{
    [super setUp];
    _searchViewController = [[SearchViewController alloc] init];
    self.searchViewController.delegate = self;
    _searchViewControllerDidCancelSearch_wasCalled = NO;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)searchViewControllerDidCancelSearch:(id)searchViewController {
    _searchViewControllerDidCancelSearch_wasCalled = YES;
}

/** Ensures the class reacts to the cancel button.
 */
- (void)testReactsToCancelButton
{
    XCTAssert([self.searchViewController respondsToSelector:@selector(searchBarCancelButtonClicked:)], @"Must be able to react to cancel button.");
}

/** Ensures that the controller notifies its delegate if the user presses the 'cancel' button on the searchbar.
 */
- (void)testNotifiesItsDelegateWhenCancelButtonIsPressed {

    [self.searchViewController setValue:[[NSFetchedResultsController alloc] init]  forKey:@"fetchedResultsController"];
    [self.searchViewController searchBarCancelButtonClicked:[[UISearchBar alloc] init]];
    XCTAssert(_searchViewControllerDidCancelSearch_wasCalled == TRUE, @"Failed to inform its delegate that the cancel button was clicked.");
}


@end
