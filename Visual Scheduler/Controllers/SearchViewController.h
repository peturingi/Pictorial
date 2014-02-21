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

@interface SearchViewController : UICollectionViewController <UISearchBarDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>
{
    // Searchbar is created and managed in code.
    UISearchBar *_searchBar;
    
    // Look and feel managed in code.
    IBOutlet UICollectionView *_collectionView;
}

/** If set, this delegate is notified if the user clicks the searchbars 'cancel' button.
 */
@property (weak, nonatomic) id<SearchViewControllerDelegate> delegate;

@end
