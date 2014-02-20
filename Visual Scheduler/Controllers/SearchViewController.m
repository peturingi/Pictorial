//
//  SearchViewController.m
//  Visual Scheduler
//
//  Created by Pétur Ingi Egilsson on 20/02/14.
//  Copyright (c) 2014 Student Project. All rights reserved.
//

#import "SearchViewController.h"
#import "Pictogram.h"

@interface SearchViewController ()

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
    
    [self configureSearchView];
    [self configureCollectionView];
    
#ifdef DEBUG
    // Set up test data for use during development.
    Pictogram *p1 = [[Pictogram alloc] initWithImage:@"beer.png"];
    _dataSource = @[p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1,p1];
#endif
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewController
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[(id<ContainsImage>)[_dataSource objectAtIndex:indexPath.row] image]];
    CGRect imageFrame = imageView.frame;
    imageFrame.size = CGSizeMake(IMAGE_SIZE, IMAGE_SIZE);
    imageView.frame = imageFrame;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picture" forIndexPath:indexPath];
    cell.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(IMAGE_SIZE,IMAGE_SIZE);
}

@end
