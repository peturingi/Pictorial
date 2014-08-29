#import "DayCollectionViewLayout.h"
#import "NSDate+VisualScheduler.h"

#define CELL_KEY    @"ImageCell"
#define HEADER_KEY  @"DayOfWeekColor"
#define FOOTER_KEY  @"kFooter"

static const NSInteger INSET_TOP    = 2;
static const NSInteger INSET_LEFT   = 18;
static const NSInteger INSET_RIGHT  = 18;
static const NSInteger INSET_BOTTOM = 2;
static const NSInteger OFFSET_FROM_TOP = 4;
static const NSUInteger HEADER_HEIGHT = 20;

@interface DayCollectionViewLayout ()
@property (nonatomic, strong) NSDictionary *layoutInformation;
@property (nonatomic) UIEdgeInsets insets;
@end

@implementation DayCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.insets = UIEdgeInsetsMake(INSET_TOP, INSET_LEFT, INSET_BOTTOM, INSET_RIGHT);
    }
    NSAssert(self, @"Super failed to init.");
    return self;
}

- (void)dealloc
{
    self.layoutInformation = nil;
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

- (void)prepareLayout
{
    NSDictionary *cellInformation = [self cellAttributes];
    NSDictionary *headerInformation = [self headerAttributes];
    NSDictionary *footerInformation = [self footerAttributes];
    self.layoutInformation = @{CELL_KEY     : cellInformation,
                               HEADER_KEY   : headerInformation,
                               FOOTER_KEY   : footerInformation};
}

#pragma mark Cell Layout

- (NSDictionary *)cellAttributes
{
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    for (NSUInteger today = 0; today < NUMBER_OF_DAYS_IN_WEEK; today++) {
        const NSInteger numberOfItemsToday = [self.collectionView numberOfItemsInSection:today];
        for (NSInteger item = 0; item < numberOfItemsToday; item++) {
            NSIndexPath *pathToItem = [NSIndexPath indexPathForItem:item inSection:today];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:pathToItem];
            attributes.frame = [self frameForItemAtIndexPath:pathToItem];
            attributes.alpha = (today == [NSDate dayOfWeekInDenmark]) ? 1.0f : 0.0f;
            [cellInformation setObject:attributes forKey:pathToItem];
        }
    }
    
    NSAssert(cellInformation != nil, @"nil must never be returned.");
    return cellInformation;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath);
    CGRect rect;
    rect.origin = [self originForItemAtIndexPath:indexPath];
    rect.size = [self sizeOfItems];
    return rect;
}

- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath);
    const CGSize itemSize = [self sizeOfItems];
    
    /*
     Place out of screen if cell it not for today.
     Reason: Setting the cells alpha to 0 does not make it non-interactable. It is still possible
     to drop a pictogram over an invisible cell while in the day view, in order to add that pictogram to the
     invisible cells schedule. 
     */
    const CGFloat x = [NSDate dayOfWeekInDenmark] == indexPath.section ?
        floor(self.collectionView.bounds.size.width / 2.0f - itemSize.width / 2.0f) : -100;
    
    const CGFloat y = ([self headerSize].height+self.insets.top) + indexPath.item * (itemSize.height+self.insets.top+self.insets.bottom) + OFFSET_FROM_TOP;
    const CGPoint origin = CGPointMake(x, y);
    return origin;
}

- (CGSize)sizeOfItems
{
    CGFloat edge = (self.collectionView.bounds.size.width / self.collectionView.numberOfSections) - (self.insets.right+self.insets.left);
    CGSize itemSize = CGSizeMake(edge, edge);
    return itemSize;
}

#pragma mark Header Layout

- (NSDictionary *)headerAttributes
{
    NSMutableDictionary *headerInformation = [NSMutableDictionary dictionaryWithCapacity:NUMBER_OF_DAYS_IN_WEEK];
    
        const NSUInteger indexOfFirstPictogram = 0;
        NSIndexPath *const pathToFirstItem = [NSIndexPath indexPathForItem:indexOfFirstPictogram inSection:[NSDate dayOfWeekInDenmark]]; // assume there is always an item, so we can calculate offset of header.
        UICollectionViewLayoutAttributes *const attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                                            withIndexPath:pathToFirstItem];
        attributes.frame = [self frameForHeaderOfSection:[NSDate dayOfWeekInDenmark]];
        attributes.zIndex = NSIntegerMax;
        [headerInformation setObject:attributes forKey:pathToFirstItem];
    
    NSAssert(headerInformation, @"nil must never be returned.");
    return headerInformation;
}

- (CGRect)frameForHeaderOfSection:(NSUInteger)section
{
    CGRect rect;
    rect.origin = [self originForHeaderOfSection:section];
    rect.size = [self headerSize];
    return rect;
}

- (CGPoint)originForHeaderOfSection:(NSUInteger)section
{
    /** All are placed in same location. I dont care as I alpha=0 the ones I dont want to show. */
    const CGFloat x = floor(self.collectionView.bounds.size.width / 2.0f - [self headerSize].width / 2.0f);
    const CGFloat y = self.collectionView.contentOffset.y; // Moves the headers location up, so it is drawn above the first item
    return CGPointMake(x, y);
}

- (CGSize)headerSize
{
    const CGFloat width = self.collectionView.bounds.size.width;
    const CGFloat height = HEADER_HEIGHT;
    const CGSize size = CGSizeMake(width, height);
    return size;
}

#pragma mark Footer layout

- (NSDictionary *)footerAttributes
{
    NSMutableDictionary *footerInformation = [NSMutableDictionary dictionaryWithCapacity:NUMBER_OF_DAYS_IN_WEEK];
    
    
    const NSUInteger indexOfFirstPictogram = 0;
    NSIndexPath *const pathToFirstItem = [NSIndexPath indexPathForItem:indexOfFirstPictogram inSection:[NSDate dayOfWeekInDenmark]]; // assume there is always an item, so we can calculate offset of header.
    UICollectionViewLayoutAttributes *const attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                                                        withIndexPath:pathToFirstItem];
    attributes.frame = [self frameForFooterOfSection:[NSDate dayOfWeekInDenmark]];
    attributes.zIndex = NSIntegerMin;
    [footerInformation setObject:attributes forKey:pathToFirstItem];
    
    NSAssert(footerInformation, @"nil must never be returned.");
    return footerInformation;
}

- (CGRect)frameForFooterOfSection:(NSUInteger)section
{
    CGRect rect;
    rect.origin = [self originForFooterOfSection:section];
    rect.size = [self footerSize];
    return rect;
}

- (CGPoint)originForFooterOfSection:(NSUInteger)section
{
    /** All are placed in same location. I dont care as I alpha=0 the ones I dont want to show. */
    const CGFloat x = floor(self.collectionView.bounds.size.width / 2.0f - [self footerSize].width / 2.0f);
    const CGFloat y = self.collectionView.contentOffset.y;
    return CGPointMake(x, y);
}

- (CGSize)footerSize
{
    const CGFloat width = [self sectionWidth];
    const CGFloat height = self.collectionView.frame.size.height;
    const CGSize size = CGSizeMake(width, height);
    return size;
}

#pragma mark Step 2 - CollectionView Size and Grid configuration

/* Return the overall size of the entire content, based on initial calculations.
 */
- (CGSize)collectionViewContentSize
{
    CGFloat const contentWidth = self.collectionView.bounds.size.width;
    const CGFloat contentHeight = [self numberOfPictogramsInLongestSchedule] * [self rowHeight] + ([self headerSize].height + self.insets.top + self.insets.bottom);
    const CGSize size = CGSizeMake(contentWidth, contentHeight);
    return size;
}

- (NSUInteger)numberOfPictogramsInLongestSchedule
{
    NSAssert(self.collectionView, @"The collection view is missing.");
    NSUInteger numberOfPictograms = 0;
    const NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++){
        const NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        numberOfPictograms = MAX(numberOfItemsInSection, numberOfPictograms);
    }
    return numberOfPictograms;
}

- (CGFloat)rowHeight
{
    const CGFloat height = [self sizeOfItems].height + self.insets.top + self.insets.bottom;
    return height;
}

/** @note Sections are represented as columns.
 */
- (CGFloat)sectionWidth
{
    const CGFloat width = ceil(self.collectionView.bounds.size.width / self.collectionView.numberOfSections);
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

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    [layoutAttributes addObjectsFromArray:[self layoutAttributesWithKey:CELL_KEY inRect:rect]];
    [layoutAttributes addObjectsFromArray:[self layoutAttributesWithKey:HEADER_KEY inRect:rect]];
    [layoutAttributes addObjectsFromArray:[self layoutAttributesWithKey:FOOTER_KEY inRect:rect]];
    return layoutAttributes;
}

- (NSArray *)layoutAttributesWithKey:(NSString *const)key inRect:(const CGRect)rect
{
    const NSDictionary *attributes = [self.layoutInformation objectForKey:key];
    NSArray *intersectingCells = [self attributesIn:attributes intersecting:rect];
    return intersectingCells;
}

/** Returns attributes for all items intersecting the given rect.
 */
- (NSArray *)attributesIn:(const NSDictionary *)dictionary intersecting:(const CGRect)rect
{
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
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 Called by the collection view when it needs information about cells that might currently not be visible.
 @note Required for animation.
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * const cellInformation = [self.layoutInformation objectForKey:CELL_KEY];
    UICollectionViewLayoutAttributes * const attributes = [cellInformation objectForKey:indexPath];
    return attributes;
}




#pragma mark - Scrolling

/** Tries to adjust pictograms during scrolling, so they are not shown partially (cut on top/bottom).
 */
// TODO: uncomment and use this code.
/*- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
 {
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
 }*/

@end