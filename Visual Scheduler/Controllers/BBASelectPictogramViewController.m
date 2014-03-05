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
@property (strong, nonatomic) NSManagedObjectID *selectedItem;
@end

@implementation BBASelectPictogramViewController

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

- (IBAction)doneButton:(id)sender {
}

- (void)informDelegateWhichItemWasSelected {
    [self.delegate BBASelectPictogramViewController:self didSelectItem:_selectedItem];
}

- (IBAction)cameraButton:(id)sender {
    [self setupCamera];
    [self showCamera];
}

- (void)setupCamera {
        camera = [[Camera alloc] initWithViewController:self usingDelegate:self];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedItem = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self informDelegateWhichItemWasSelected];
}

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
    UIImageView *imageView = (UIImageView *)[cell.contentView firstSubviewWithTag:kCellTagForImageView];
    UIImage *image = [self imageForPictogramAtIndexPath:indexPath];
    [imageView setImage:image];
    
    UILabel *labelView = (UILabel *)[cell.contentView firstSubviewWithTag:kCellTagForLabelView];
    NSString *title = [self titleForPictogramIndexPath:indexPath];
    [labelView setText:title];
}

- (UIImage *)imageForPictogramAtIndexPath:(NSIndexPath *)indexPath {
    Pictogram *pictogram = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSData *imageData = [NSData dataWithContentsOfFile:pictogram.imageURL];
    return [UIImage imageWithData:imageData];
}

- (NSString *)titleForPictogramIndexPath:(NSIndexPath *)indexPath {
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
        [newPictogram setPhoto:[camera developPhoto]];
    }
}

@end
