#import "PictogramsCollectionViewController.h"
#import "BBANewPictogramViewController.h"
#import "UIView+BBASubviews.h"
#import "../Database/Repository.h"
#import "../Database/SQLiteStore.h"


NSString * const kCellReusableIdentifier = @"pictogramSelector";
NSInteger const kCellTagForImageView = 1;
NSInteger const kCellTagForLabelView = 2;

@interface PictogramsCollectionViewController ()
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) Repository *repository;
@end

@implementation PictogramsCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"SelectPictogramCell" bundle:nil] forCellWithReuseIdentifier:@"pictogramSelector"];
        self.collectionView.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.collectionViewLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Makes the collectionView flexible in size, so its size can be managed by a container.
    //self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
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

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(100, 135);
    return size;
}

#pragma mark - UICollectionView

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

#pragma mark Public

- (UIImage *)pictogramAtPoint:(CGPoint)point {
    NSIndexPath *selection = [self.collectionView indexPathForItemAtPoint:point];
    UIImage *image = nil;
    if (selection != nil) {
        image = [self imageForPictogramAtIndexPath:selection];
    }
    return image;
}

@end