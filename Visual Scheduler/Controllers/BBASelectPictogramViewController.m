#import "BBASelectPictogramViewController.h"
#import "BBANewPictogramViewController.h"
#import "../../BBACoreDataStack.h"
#import "Pictogram.h"
#import "UIView+BBASubviews.h"

NSString * const kCellReusableIdentifier = @"pictogramSelector";
NSInteger const kCellTagForImageView = 1;
NSInteger const kCellTagForLabelView = 2;

@interface BBASelectPictogramViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation BBASelectPictogramViewController

- (void)didReceiveMemoryWarning {
    camera = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCoreData];
}

- (void)setupCoreData {
    NSSortDescriptor *pictogramSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    _fetchedResultsController = [[BBACoreDataStack sharedInstance] fetchedResultsControllerForEntityClass:[Pictogram class] batchSize:20 andSortDescriptors:@[pictogramSorter]];
    [_fetchedResultsController setDelegate:self];
    [_fetchedResultsController performFetch:nil];
}

#pragma mark - Camera

- (IBAction)cameraButton:(id)sender {
    [self setupCamera];
    [self showCamera];
}

- (void)setupCamera {
    if (!camera) {
        camera = [[Camera alloc] initWithViewController:self usingDelegate:self];
    }
}

- (void)showCamera {
    if (![camera show]) {
        [self alertUserCameraIsNotAvailable];
    }
}

- (void)alertUserCameraIsNotAvailable {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The camera is unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)cameraSnappedPhoto {
    [self performSegueWithIdentifier:@"newPictogramAskForTitle" sender:nil];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *fetchedObjects = [[self fetchedResultsController] fetchedObjects];
    return [fetchedObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *reusableCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReusableIdentifier forIndexPath:indexPath];
    [self configureCell:reusableCell atIndexPath:indexPath];
    return reusableCell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imageView = (UIImageView *)[cell firstSubviewWithTag:kCellTagForImageView];
    UIImage *image = [self imageForIndexPath:indexPath];
    [imageView setImage:image];
    
    UILabel *labelView = (UILabel *)[cell firstSubviewWithTag:kCellTagForLabelView];
    NSString *title = [self titleForIndexPath:indexPath];
    [labelView setText:title];
}

- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath {
    Pictogram *pictogram = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSData *imageData = [NSData dataWithContentsOfFile:pictogram.imageURL];
    return [UIImage imageWithData:imageData];
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    Pictogram *pictogram = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return pictogram.title;
}

#pragma mark - BBANewPictogramViewController delegate

- (void)BBANewPictogramViewControllerCreatedPictogram {
    [self.fetchedResultsController performFetch:nil];
}

#pragma mark - FetcheResultsController delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView reloadData];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newPictogramAskForTitle"]) {
        BBANewPictogramViewController *newPictogram = (BBANewPictogramViewController *)segue.destinationViewController;
        [newPictogram setDelegate:self];
        UIImage *photo = [camera developPhoto];
        [newPictogram setPhoto:photo];
    }
}

@end
