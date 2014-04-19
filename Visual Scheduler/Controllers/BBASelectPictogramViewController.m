#import "BBASelectPictogramViewController.h"
#import "BBANewPictogramViewController.h"
#import "UIView+BBASubviews.h"
#import "../Database/Repository.h"
#import "../Database/SQLiteStore.h"


NSString * const kCellReusableIdentifier = @"pictogramSelector";
NSInteger const kCellTagForImageView = 1;
NSInteger const kCellTagForLabelView = 2;

@interface BBASelectPictogramViewController ()
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) Repository *repository;
@end

@implementation BBASelectPictogramViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"SelectPictogramCell" bundle:nil] forCellWithReuseIdentifier:@"pictogramSelector"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    // Makes the collectionView flexible in size, so its size can be managed by a container.
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDataSource];
}

- (void)setupDataSource {
    id appDelegate = [[UIApplication sharedApplication] delegate];
    _repository = [appDelegate valueForKey:@"sharedRepository"];
    NSAssert(_repository != nil, @"Failed to get shared repository.");
    _dataSource = [_repository allPictogramsIncludingImages:YES];
}

#pragma mark - Camera

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

#pragma mark Camera Delegate

- (void)cameraDidSnapPhoto:(Camera *)camera {
    [self performSegueWithIdentifier:@"newPictogramAskForTitle" sender:nil];
}

#pragma mark - UICollectionView

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedItem = [self.dataSource objectAtIndex:indexPath.row];
    [self informDelegateOfSelection];
}

- (void)informDelegateOfSelection {
    [self.delegate BBASelectPictogramViewController:self didSelectItem:(Pictogram *)_selectedItem];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSAssert(_dataSource != nil, @"Must not be nil.");
    return self.dataSource.count;
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
    Pictogram *pictogram = [self.dataSource objectAtIndex:indexPath.row];
    NSAssert(pictogram.image != nil, @"Failed to load image from pictogram.");
    return pictogram.image;
}

- (NSString *)titleForPictogramIndexPath:(NSIndexPath *)indexPath {
    Pictogram *pictogram = [self.dataSource objectAtIndex:indexPath.row];
    return pictogram.title;
}

#pragma mark - FetcheResultsController delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newPictogramAskForTitle"]) {
        BBANewPictogramViewController *newPictogramViewController = (BBANewPictogramViewController *)segue.destinationViewController;
        [newPictogramViewController setDelegate:self];
        [newPictogramViewController setPhoto:[camera developPhoto]];
    }
}

#pragma mark - Gestures
- (IBAction)longPressPictogram:(id)sender {
    UIGestureRecognizer *gr = (UIGestureRecognizer *)sender;
    static NSIndexPath *selection = nil;
    
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [gr locationInView:self.collectionView];
        selection = [self.collectionView indexPathForItemAtPoint:location];
        NSLog(@"selected index: %@", selection.description);

    } else
    if (gr.state == UIGestureRecognizerStateChanged) {
        // Follow Finger
    } else
    if (gr.state == UIGestureRecognizerStateEnded) {
        // Place in location if they are over the calnedar, else throw away.
        // This should be done by this controllers delegate.
    } else
    if (gr.state == gr.state == UIGestureRecognizerStateCancelled) {
        // Aborg
    }
}


@end
