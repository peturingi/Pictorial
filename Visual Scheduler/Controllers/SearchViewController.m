//
//  SearchViewController.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 20/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "SearchViewController.h"
#import "Pictogram.h"

// Name of cache used by NSFetchedResultsController
#define CACHE_NAME  @"Root"

@interface SearchViewController ()
    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation SearchViewController

#pragma mark - Init / Setup
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view
    [self configureCoreData];
    [self configureSearchView];
    [self configureCollectionView];
}

- (void)configureSearchView {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    [_searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Searchbar always on top of the screen
    [_searchBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchBar.superview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];

    // Width equals screen
    [_searchBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchBar.superview
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    
    // Center on screen x coordinates
    [_searchBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchBar.superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    
}
- (void)configureCollectionView {
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Place top below searchbar
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchBar
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    // Width equals screen
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    // Place bottom on bottom of screen
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    
    // Center on screen x coordinates
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_collectionView.superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
}
- (void)configureCoreData {
    [self fetchAndReload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"picture";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.contentMode = UIViewContentModeScaleAspectFit;
    
    id<ContainsImageData> object = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    UIImage *image = [UIImage imageWithData:[object image]];
    NSAssert(image, @"No image was found. Must never be nil!");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGRect imageFrame = imageView.frame;
    imageFrame.size = CGSizeMake(IMAGE_SIZE, IMAGE_SIZE);
    imageView.frame = imageFrame;
    
    for (UIView *view in cell.contentView.subviews) view.removeFromSuperview;
    [cell.contentView addSubview:imageView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(IMAGE_SIZE,IMAGE_SIZE);
}

#pragma mark - Searching

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicate;
    
    if (searchText.length == 0) {
        predicate = nil;
    } else {
        predicate = [NSPredicate predicateWithFormat:@"ANY tag.tag contains[c] %@ OR title contains[c] %@", searchText, searchText];
    }
    [NSFetchedResultsController deleteCacheWithName:CACHE_NAME];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self fetchAndReload];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.fetchedResultsController.fetchRequest setPredicate:nil];
    if (self.delegate) {
        [self.delegate searchViewControllerDidCancelSearch:self];
    } else {
        searchBar.showsCancelButton = NO;
        searchBar.text = @"";
        [searchBar resignFirstResponder];
        [self fetchAndReload];
    }
}

#pragma mark - Core Data

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    } else {
        NSManagedObjectContext *managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pictogram" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        [fetchRequest setFetchBatchSize:20];
        
        NSFetchedResultsController *newFetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                    managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:CACHE_NAME];
        _fetchedResultsController = newFetchResultsController;
        _fetchedResultsController.delegate = self;
        
        return _fetchedResultsController;
    }
}

/** Fetches all entities and reloads the collection view.
 */
- (void)fetchAndReload {
    [NSFetchedResultsController deleteCacheWithName:CACHE_NAME];
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"Error: %@, %@", error, error.userInfo);
        exit(-1); // Hard fail.
    }
    [_collectionView reloadData];
}



@end
