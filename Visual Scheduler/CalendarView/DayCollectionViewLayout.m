#import "DayCollectionViewLayout.h"

#define CELL_KEY    @"ImageCell"
#define HEADER_KEY  @"DayOfWeekColor"

static const NSInteger INSET_TOP    = 2;
static const NSInteger INSET_LEFT   = 15;
static const NSInteger INSET_RIGHT  = 15;
static const NSInteger INSET_BOTTOM = 2;

@implementation DayCollectionViewLayout

- (id)init {
    self = [super init];
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
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionaryWithCapacity:1];
    const NSInteger firstSection = 0; // TODO: get current day. This gets only Monday.
    self.maxNumRows = [self.collectionView numberOfItemsInSection:firstSection];
    
    for (NSInteger item = 0; item < self.maxNumRows; item++) {
        NSIndexPath *pathToItem = [NSIndexPath indexPathForItem:item inSection:firstSection];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:pathToItem];
        attributes.frame = [self frameForItemAtIndexPath:pathToItem];
        [cellInformation setObject:attributes forKey:pathToItem];
    }
    return cellInformation;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect;
    rect.origin = [self originForItemAtIndexPath:indexPath];
    rect.size = [self sizeOfItems];
    return rect;
}

- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = [self sizeOfItems];
    CGFloat x = [self collectionViewContentSize].width / 2.0f + self.collectionView.contentOffset.x - itemSize.width / 2.0f;
    CGFloat y = [self headerSize].height + self.insets.top + indexPath.item * (itemSize.height + self.insets.top + self.insets.bottom);
    return CGPointMake(x, y);
}

- (CGSize)sizeOfItems {
    const NSUInteger daysInWeek = 7;
    CGFloat edge = ((self.collectionView.bounds.size.width / self.collectionView.numberOfSections) - (self.insets.right+self.insets.left)) / daysInWeek;
    CGSize itemSize = CGSizeMake(edge, edge);
    return itemSize;
}
#pragma mark Header Layout

- (NSDictionary *)headerAttributes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:path];
    attributes.frame = [self frameForHeaderOfSection:0];
    attributes.zIndex = 1024;
    [dictionary setObject:attributes forKey:path];
    return dictionary;
}

- (CGRect)frameForHeaderOfSection:(NSUInteger)section {
    CGRect rect;
    rect.origin = [self originForHeaderOfSection:section];
    rect.size = CGSizeMake([self sizeOfItems].width, HEADER_HEIGHT);
    return rect;
}

- (CGPoint)originForHeaderOfSection:(NSUInteger)section {
    CGSize itemSize = [self sizeOfItems];
    CGFloat x = [self collectionViewContentSize].width / 2.0f + self.collectionView.contentOffset.x - itemSize.width / 2.0f;
    CGFloat y = self.collectionView.contentOffset.y;
    return CGPointMake(x, y);
}

- (CGSize)headerSize {
    CGSize size;
    CGFloat width = [self sectionWidth];
    CGFloat height = HEADER_HEIGHT;
    size = CGSizeMake(width, height);
    return size;
}

#pragma mark Step 2 - CollectionView Size and Grid configuration

/* Return the overall size of the entire content, based on initial calculations.
 */
- (CGSize)collectionViewContentSize {
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentHeight = self.maxNumRows * [self rowHeight] + ([self headerSize].height + self.insets.top + self.insets.bottom);
    CGSize size = CGSizeMake(contentWidth, contentHeight);
    return size;
}

- (CGFloat)rowHeight {
    CGFloat height = [self sizeOfItems].height + self.insets.top + self.insets.bottom;
    return height;
}

/** @note Sections are represented as columns.
 */
- (CGFloat)sectionWidth {
    CGFloat width = self.collectionView.bounds.size.width / self.collectionView.numberOfSections;
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
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    for (NSString *key in self.layoutInformation) {
        NSDictionary *attributes = [self.layoutInformation objectForKey:key];
        NSArray *intersectingAttributes;
        if ([key isEqualToString:CELL_KEY]) {
            intersectingAttributes = [self attributesIn:attributes intersecting:rect];
            [results addObjectsFromArray:intersectingAttributes];
        }
        else if ([key isEqualToString:HEADER_KEY]) {
            NSDictionary *headerAttributes = [self headerAttributes];
            for (NSIndexPath *k in headerAttributes) {
                [results addObject:[headerAttributes objectForKey:k]];
            }
        }
    }
    return results;
}

/** Returns attributes for all items which are within the given rect.
 */
- (NSArray *)attributesIn:(NSDictionary *)dictionary intersecting:(CGRect)rect {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:dictionary.count];
    for (NSIndexPath *key in dictionary) {
        UICollectionViewLayoutAttributes *attributes = [dictionary objectForKey:key];
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

/**
 Called by the collection view when it needs information about cells that might currently not be visible.
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = nil;
    if ([kind isEqualToString:HEADER_KEY]) {
        NSDictionary *headerAttributes = [self.layoutInformation objectForKey:HEADER_KEY];
        attributes = [headerAttributes objectForKey:indexPath];
    }
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

@end