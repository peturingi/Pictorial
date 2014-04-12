#import "CalendarCollectionViewLayout.h"

static const NSInteger DAYS_IN_WEEK = 7;

static const NSInteger ITEM_WIDTH   = 200;
static const NSInteger ITEM_HEIGHT  = 200;

static const NSInteger INSET_TOP    = 0;
static const NSInteger INSET_LEFT   = 0;
static const NSInteger INSET_RIGHT  = 0;
static const NSInteger INSET_BOTTOM = 0;

@interface CalendarCollectionViewLayout ()

@property (nonatomic) NSDictionary *layoutInformation;
@property (nonatomic) NSInteger maxNumRows;
@property (nonatomic) UIEdgeInsets insets;

@end

@implementation CalendarCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.insets = UIEdgeInsetsMake(INSET_TOP, INSET_LEFT, INSET_BOTTOM, INSET_RIGHT);
    }
    return self;
}

#pragma mark - UICollectionViewLayout

/*
 During the layout process, the collection view calls specific methods of this layout object.
 The methods calculate the position of items and provide the collection view with the primary information it needs.
 
 There are three primary methods which are always called in this order:
 
 1. prepareLayout
    Performs up-front calculations needed to provide layout information (such as the position of cells and views). This information is used by the collection view in order to determine its scoll view.
 
 2. collectionViewContentSize
    Return the overall size of the entire content, based on initial calculations.
 
 3. layoutAttributesForElementsInRect
    Returns attributes for cells and views that are in a specified rectangle.
    The specified rectangle passed in is dependent on the collectionview scrollview position.
 
 Other methods may be called by the collection view, on need to use basis.
 */

// After calling this method, the layout must have enouth information to calculate the collection view's content size (step 2.)
- (void)prepareLayout {
    // Create the attributes, instances of UICollectionViewLayoutAttributes and cache them, as we are dealing with less than 1000s of items.
    // After creating each attribute, set the attributes relevant for the view. At minimum: size and position of the view in the layout.
    
    NSMutableDictionary *layoutInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numSections; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        if (self.maxNumRows < numItems) self.maxNumRows = numItems;
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];;//[self attributesWithChildrenAtIndexPath:indexPath];
            attributes.frame = [self frameForItemAtIndexPath:indexPath];
            [cellInformation setObject:attributes forKey:indexPath];
        }
    }
    /*
    for (NSInteger section = 0; section < numSections; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        NSInteger totalHeight = 0;
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            //UICollectionViewLayoutAttributes *attributes = [cellInformation objectForKey:indexPath];
            //attributes.frame = CGRectMake(100,100,100,100); //hack replacing : [self frameForCellAtIndexPath:indexPath withHeight:totalHeight];
            // adjust frames of children .... skipped
            
            //cellInformation[indexPath] = attributes;
            totalHeight++; // different from apple guide
        }
        if (self.maxNumRows < totalHeight) {
            self.maxNumRows = totalHeight;
        }
    }*/
    [layoutInformation setObject:cellInformation forKey:@"MyCellKind"];
    self.layoutInformation = layoutInformation;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect;
    rect.origin = [self locationForItemAtIndexPath:indexPath];
    rect.size = [self sizeForItemAtIndexPath:indexPath];
    return rect;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}

- (CGPoint)locationForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize contentSize = [self collectionViewContentSize];
    CGFloat horizontalOffset = contentSize.width / DAYS_IN_WEEK;
    CGFloat x = indexPath.section * horizontalOffset;
    CGFloat y = indexPath.item * 50;
    return CGPointMake(x, y);
}

- (CGSize)collectionViewContentSize {
    CGFloat width = self.collectionView.numberOfSections * (ITEM_WIDTH + self.insets.left + self.insets.right);
    CGFloat height = self.maxNumRows * (ITEM_HEIGHT + _insets.top + _insets.bottom);
    return CGSizeMake(width, height);
}

// Final step (3).
// Provide layout attributes for every cell and every supplementary or decoration view that intersects the specified rectangle.
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    /* Implementation:
        1. Iterate over the data generated by prepareLayout, to either access cached attributes or create new ones as needed.
        2. Check the frame of each item to see whether it intersects the rectangle passsed to the layoutAttributesForElementsInRect.
        3. For each intersecting item, add a corresponding UICollectionViewLayoutAttributeObject to the array to be returned.
        4. Return the array of layout attributes to the collection view.
     */
    NSMutableArray *myAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    for (NSString *key in self.layoutInformation) {
        NSDictionary *attributesDict = [self.layoutInformation objectForKey:key];
        for (NSIndexPath *key in attributesDict) {
            UICollectionViewLayoutAttributes *attributes = [attributesDict objectForKey:key];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [myAttributes addObject:attributes]; // I think apples code has errors here. They want attributes: instead of myAttributes.
            }
        }
    }
    return myAttributes;
}

// Called by the collectionview before it scrolls, in order to ask for a new layout.
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// The collection view preiodically asks the layout object to provide attributes for individual items outside of the formal layout process.
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Implementation: Retrieve the current layout attributes for the given cell or view.
    // DO NOT UPDATE THE LAYOUT ATTRIBUTES!
    return nil;
}


/*
 targetContentOffsetForProposedContentOffset:withScrollingVelocity: (page 51)
 Adjust the scoll view, such as to aligh the layout so no pictograms are cut in half when scrolling stops.
 */

@end
