#import "SearchViewController.h"
#import "Pictogram.h"

#pragma mark - Constants

// Name of cache used by NSFetchedResultsController
#define CACHE_NAME  @"Root"
// Size of image tile in collection view
#define IMAGE_SIZE  200

#pragma mark - Private Properties

@interface SearchViewController ()
    @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

#pragma mark - Init / Setup

@implementation SearchViewController

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
    [self fetchEntitiesAndReloadCollectionView];
    [self configureSearchView];
    [self configureCollectionView];
}

/** Configures the apperance of the searchbar.
 */
- (void)configureSearchView {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    NSAssert(self.view, @"This controller does not have a view!");
    [self.view addSubview:_searchBar];
    [_searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Searchbar hugs the top of its superview
    [_searchBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchBar.superview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];

    // Searchbars width is equal to its superviews width
    [_searchBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchBar.superview
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    
    // Searchbar is centered on x-axis in its superview.
    [_searchBar.superview addConstraint:[NSLayoutConstraint constraintWithItem:_searchBar
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchBar.superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    
}

/** Configures the apperance of the collection view.
 */
- (void)configureCollectionView {
    NSAssert(_collectionView, @"Connection view is nil. Can not be configured!");
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSAssert(self.view, @"Cannot configure constraints. This controller does not have a view.");
    
    // Top of collection view is at the bottom of the searchbar
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_searchBar
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    // Width of collectionview is equal to this controllers primary view.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    // Bottom of collection view is same as bottom of this controllers primary view.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
    
    NSAssert(_collectionView.superview, @"Cannot configure constraints. No superview.");
    // Center the collection view on its superviews x-axis.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_collectionView.superview
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(collectionView, @"must not be nil.");
    NSAssert(section < 0, @"Invalid section.");
    NSAssert(self.fetchedResultsController, @"fetchedResultsController is nil.");
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *REUSABLE_CELL_IDENTIFIER = @"picture";
    UICollectionViewCell *reusableCell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSABLE_CELL_IDENTIFIER forIndexPath:indexPath];
    [self configureCell:reusableCell atIndexPath:indexPath];
    NSAssert(reusableCell, @"nil must never be returned by this method.");
    return reusableCell;
}

/** Populates each cell in the collection view with an image.
 *  The image will be scaled to aspect fill the cell.
 */
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(cell,      @"cell must not be nil.");
    NSAssert(indexPath, @"indexPath must not be nil.");
    
    cell.contentMode = UIViewContentModeScaleAspectFit;
    
    id<ContainsImageData> objectContainingImageData = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];


    NSAssert(objectContainingImageData, @"object must not be nil");
    
    UIImage *image = [UIImage imageWithData:[objectContainingImageData image]];

    NSAssert(image, @"No image was found. Must never be nil!");
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGRect imageFrame = imageView.frame;
    imageFrame.size = CGSizeMake(IMAGE_SIZE, IMAGE_SIZE);
    imageView.frame = imageFrame;
    
    // Remove any old subviews from the cell, as reused cells contain garbage.
    for (UIView *v in cell.contentView.subviews) { [v removeFromSuperview]; }
    
    [cell.contentView addSubview:imageView];
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(IMAGE_SIZE,IMAGE_SIZE);
}

#pragma mark - Searching

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSAssert(searchBar,     @"must not be nil.");
    NSAssert(searchText,    @"must not be nil.");
    NSPredicate *predicate;
    
    if (searchText.length == 0) {
        predicate = nil;
    } else {
        predicate = [NSPredicate predicateWithFormat:@"ANY tag.tag contains[c] %@ OR title contains[c] %@", searchText, searchText];
    }
    [NSFetchedResultsController deleteCacheWithName:CACHE_NAME];
    
    NSAssert(_fetchedResultsController, @"must not be nil.");
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    [self fetchEntitiesAndReloadCollectionView];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSAssert(searchBar, @"must not be nil.");
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSAssert(searchBar, @"must not be nil.");
    
    NSAssert(_fetchedResultsController, @"must not be nil.");
    [self.fetchedResultsController.fetchRequest setPredicate:nil];
    
    if (self.delegate) {
        [self.delegate searchViewControllerDidCancelSearch:self];
    } else {
        searchBar.showsCancelButton = NO;
        searchBar.text = @"";
        [searchBar resignFirstResponder];
        
        [self fetchEntitiesAndReloadCollectionView];
    }
}

#pragma mark - Core Data

/** Getter - lazy instantiates and configures the fetchedResultsController.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    } else {
        NSAssert([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(managedObjectContext)], @"AppDelegate does not respond to a needed selector");
        NSManagedObjectContext *managedObjectContext = [[[UIApplication sharedApplication] delegate] performSelector:@selector(managedObjectContext)];
        NSAssert(managedObjectContext, @"must not be nil!");
        
        NSEntityDescription *pictogram = [NSEntityDescription entityForName:@"Pictogram" inManagedObjectContext:managedObjectContext];
        NSAssert(pictogram, @"must not be nil!");
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:pictogram];
        
        const NSInteger FETCH_BATCH_SIZE = 20;
        [fetchRequest setFetchBatchSize:FETCH_BATCH_SIZE];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        [NSFetchedResultsController deleteCacheWithName:CACHE_NAME];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:CACHE_NAME];
        _fetchedResultsController.delegate = self;
        
        NSAssert(_fetchedResultsController, @"must not be nil!");
        return _fetchedResultsController;
    }
}

/** Fetches all entities and reloads the collection view.
 */
- (void)fetchEntitiesAndReloadCollectionView {
    // Fetch entities
    [NSFetchedResultsController deleteCacheWithName:CACHE_NAME];
    NSError *fetchError;
    [self.fetchedResultsController performFetch:&fetchError];
    NSAssert(!fetchError, @"Error!");
    if (fetchError) {
        NSLog(@"Error: %@, %@", fetchError, fetchError.userInfo);
        exit(-1); // Hard fail.
    }
    NSAssert(_collectionView, @"must not be nil!");
    
    // Reload the collection view
    [_collectionView reloadData];
}



@end
