#import "WeekCollectionViewLayout.h"
#import "NSDate+VisualScheduler.h"

#define CELL_KEY    @"ImageCell"
#define HEADER_KEY  @"DayOfWeekColor"

static const NSInteger INSET_TOP    = 2;
static const NSInteger INSET_LEFT   = 18;
static const NSInteger INSET_RIGHT  = 18;
static const NSInteger INSET_BOTTOM = 2;
static const NSUInteger HEADER_HEIGHT = 20;

@interface WeekCollectionViewLayout ()
@property (nonatomic, strong) NSDictionary *layoutInformation;
@property (nonatomic) UIEdgeInsets insets;
@end

@implementation WeekCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.insets = UIEdgeInsetsMake(INSET_TOP, INSET_LEFT, INSET_BOTTOM, INSET_RIGHT);
    }
    return self;
}

#pragma mark - UICollectionViewLayout Process
/*
 During the layout process, the collection view calls specific methods of this layout object.
 The methods calculate the position of items and provide the collection view with the primary information it needs.
 There are three primary methods which are always called in the same three step order.
 */

#pragma mark Step 1 - Initial Calculations
/*
 Performs up-front calculations needed to provide layout information (such as the position of cells and views).
 This information is used by the collection view in order to determine its scoll view size.
 After calling this method, the layout must have enouth information to calculate the collection view's content size.
 */

- (void)prepareLayout {
    NSDictionary *cellInformation = [self cellAttributes];
    NSDictionary *headerInformation = [self headerAttributes];
    self.layoutInformation = @{CELL_KEY     : cellInformation,
                               HEADER_KEY   : headerInformation};
}

#pragma mark Cell Layout

- (NSDictionary *)cellAttributes {
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    for (NSUInteger today = 0; today < NUMBER_OF_DAYS_IN_WEEK; today++) {
        const NSInteger numberOfItemsToday = [self.collectionView numberOfItemsInSection:today];
        for (NSInteger item = 0; item < numberOfItemsToday; item++) {
            NSIndexPath *pathToItem = [NSIndexPath indexPathForItem:item inSection:today];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:pathToItem];
            attributes.frame = [self frameForItemAtIndexPath:pathToItem];
            [cellInformation setObject:attributes forKey:pathToItem];
        }
    }
    NSAssert(cellInformation != nil, @"nil must never be returned.");
    return cellInformation;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    CGRect rect;
    rect.origin = [self originForItemAtIndexPath:indexPath];
    rect.size = [self sizeOfItems];
    return rect;
}

- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath);
    const CGSize itemSize = [self sizeOfItems];
    const CGFloat x = self.insets.left + indexPath.section * (itemSize.width+self.insets.left+self.insets.right);
    const CGFloat y = ([self headerSize].height+self.insets.top) + indexPath.item * (itemSize.height+self.insets.top+self.insets.bottom);
    const CGPoint origin = CGPointMake(x, y);
    return origin;
}

- (CGSize)sizeOfItems {
    CGFloat edge = (self.collectionView.bounds.size.width / self.collectionView.numberOfSections) - (self.insets.right+self.insets.left);
    CGSize itemSize = CGSizeMake(edge, edge);
  //  NSAssert(itemSize.height > 0 && itemSize.width > 0, @"Unexpected size of item. Items must be greater in size than 0,0");
    return itemSize;
}

#pragma mark Header Layout

- (NSDictionary *)headerAttributes {
    NSMutableDictionary *headerInformation = [NSMutableDictionary dictionaryWithCapacity:NUMBER_OF_DAYS_IN_WEEK];
    
    for (NSUInteger today = 0; today < NUMBER_OF_DAYS_IN_WEEK; today++) {
        const NSUInteger indexOfFirstPictogram = 0;
        NSIndexPath *const pathToFirstItem = [NSIndexPath indexPathForItem:indexOfFirstPictogram inSection:today]; // assume there is always an item, so we can calculate offset of header.
        UICollectionViewLayoutAttributes *const attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                                      withIndexPath:pathToFirstItem];
        attributes.frame = [self frameForHeaderOfSection:today];
        attributes.zIndex = NSIntegerMax;
        [headerInformation setObject:attributes forKey:pathToFirstItem];
    }
    NSAssert(headerInformation, @"nil must never be returned.");
    return headerInformation;
}

- (CGRect)frameForHeaderOfSection:(NSUInteger)section {
    CGRect rect;
    rect.origin = [self originForHeaderOfSection:section];
    rect.size = [self headerSize];
    return rect;
}

- (CGPoint)originForHeaderOfSection:(NSUInteger)section {
    const CGSize headerSize = [self headerSize];
    const CGFloat x = section * headerSize.width;
    const CGFloat y = self.collectionView.contentOffset.y; // Moves the headers location up, so it is drawn above the first item
    return CGPointMake(x, y);
}

- (CGSize)headerSize {
    const CGFloat width = [self sectionWidth];
    const CGFloat height = HEADER_HEIGHT;
    const CGSize size = CGSizeMake(width, height);
    return size;
}

#pragma mark Step 2 - CollectionView Size and Grid configuration

/* Return the overall size of the entire content, based on initial calculations.
 */
- (CGSize)collectionViewContentSize {
    CGFloat const contentWidth = self.collectionView.bounds.size.width;
    const CGFloat contentHeight = [self numberOfPictogramsInLongestSchedule] * [self rowHeight] + ([self headerSize].height + self.insets.top + self.insets.bottom);
    const CGSize size = CGSizeMake(contentWidth, contentHeight);
    return size;
}

- (NSUInteger)numberOfPictogramsInLongestSchedule {
    NSAssert(self.collectionView, @"The collection view is missing.");
    NSUInteger numberOfPictograms = 0;
    const NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++){
        const NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        numberOfPictograms = MAX(numberOfItemsInSection, numberOfPictograms);
    }
    return numberOfPictograms;
}

- (CGFloat)rowHeight {
    const CGFloat height = [self sizeOfItems].height + self.insets.top + self.insets.bottom;
    return height;
}

/** @note Sections are represented as columns.
 */
- (CGFloat)sectionWidth {
    const CGFloat width = self.collectionView.bounds.size.width / self.collectionView.numberOfSections;
    return width;
}

#pragma mark Step 3
/*
 Provide layout attributes for every cell and every supplementary or decoration view that
 intersects the area currently shown (sometimes not shown!) by the collectionview's scrollview.
 
 The implementation of this step is a known algorithm described by Apple as:
 1. Iterate over the data generated by prepareLayout, to either access cached attributes or create new ones as needed.
 2. Check the frame of each item to see whether it intersects the rectangle passsed to the layoutAttributesForElementsInRect.
 3. For each intersecting item, add a corresponding UICollectionViewLayoutAttributeObject to the array to be returned.
 4. Return the array of layout attributes to the collection view.
 */

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    [layoutAttributes addObjectsFromArray:[self layoutAttributesWithKey:CELL_KEY inRect:rect]];
    [layoutAttributes addObjectsFromArray:[self layoutAttributesWithKey:HEADER_KEY inRect:rect]];
    return layoutAttributes;
}

- (NSArray *)layoutAttributesWithKey:(NSString *const)key inRect:(const CGRect)rect {
    const NSDictionary *attributes = [self.layoutInformation objectForKey:key];
    NSArray *intersectingCells = [self attributesIn:attributes intersecting:rect];
    return intersectingCells;
}

/** Returns attributes for all items intersecting the given rect.
 */
- (NSArray *)attributesIn:(const NSDictionary *)dictionary intersecting:(const CGRect)rect {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:dictionary.count];
    for (NSIndexPath *key in dictionary) {
        const UICollectionViewLayoutAttributes *attributes = [dictionary objectForKey:key];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [results addObject:attributes];
        }
    }
    return results;
}

#pragma mark -

/**
 Collectionview asks if we want to invalidate (and recompute) the layout on scrolling and orientation change.
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/**
 Called by the collection view when it needs information about cells that might currently not be visible.
 @note Required for animation.
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellInformation = [self.layoutInformation objectForKey:CELL_KEY];
    UICollectionViewLayoutAttributes *attributes = [cellInformation objectForKey:indexPath];
    return attributes;
}




#pragma mark - Scrolling

/** Tries to adjust pictograms during scrolling, so they are not shown partially (cut on top/bottom).
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect targetRect = CGRectMake(0, proposedContentOffset.y,
                                   self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    CGFloat offsetAdjustment = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        CGFloat itemOffset = layoutAttributes.frame.origin.y;
        if (ABS(itemOffset - proposedContentOffset.y) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemOffset - proposedContentOffset.y;
        }
    }
    CGPoint offset = CGPointMake(proposedContentOffset.x,
                                 proposedContentOffset.y + offsetAdjustment);
    offset.y -= [self headerSize].height;
    return offset;
}

- (void)dealloc {
    _layoutInformation = nil;
}

@end