//
//  SearchViewControllerDelegate.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 21/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchViewController.h"

@protocol SearchViewControllerDelegate <NSObject>
- (void)searchViewControllerDidCancelSearch:(id)searchViewController;
@end
