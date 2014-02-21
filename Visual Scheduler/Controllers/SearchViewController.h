//
//  SearchViewController.h
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 20/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SearchViewControllerDelegate.h"

#define IMAGE_SIZE  200

@interface SearchViewController : UICollectionViewController <UISearchBarDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate> {
    UISearchBar *_searchBar;    
    IBOutlet UICollectionView *_collectionView;
    NSArray *_dataSource;
}

@property (weak, nonatomic) id<SearchViewControllerDelegate> delegate;

@end
