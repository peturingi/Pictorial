#import "CalendarCollectionViewLayout.h"

#define CELL_KEY    @"ImageCell"
#define HEADER_KEY  @"DayOfWeekColour"

static const NSInteger MONDAY       = 0;
static const NSInteger SUNDAY       = 6;
static const NSInteger DAYS_IN_WEEK = SUNDAY - MONDAY;
static const NSInteger INSET_TOP    = 2;
static const NSInteger INSET_LEFT   = 2;
static const NSInteger INSET_RIGHT  = 2;
static const NSInteger INSET_BOTTOM = 2;
static const NSUInteger HEADER_HEIGHT = 20;

@interface CalendarCollectionViewLayout ()
    @property (nonatomic) NSDictionary *layoutInformation;
    @property (nonatomic) NSInteger maxNumRows;
    @property (nonatomic) UIEdgeInsets insets;
@end

@implementation CalendarCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.insets = UIEdgeInsetsMake(INSET_TOP, INSET_LEFT, INSET_BOTTOM, INSET_RIGHT);
        _viewMode = Week;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCalendarViewMode:) name:NOTIFICATION_CALENDAR_VIEW object:nil];
    }
    return self;
}

- (void)handleCalendarViewMode:(NSNotification *)notification {
    if ([notification.name isEqualToString:NOTIFICATION_CALENDAR_VIEW]) {
        NSNumber *viewMode = [notification object];
        _viewMode = viewMode.integerValue;
        [self invalidateLayout];
    }
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
    
    NSInteger firstDay;
    NSInteger lastDay;
    switch (_viewMode) {
        case Now:
        case Day:
            firstDay = lastDay = [self sectionRepresentingToday];
            break;
            
        case Week:
            firstDay = MONDAY;
            lastDay = SUNDAY;
            break;
    }
    
    for (NSInteger day = firstDay; day <= lastDay; day++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:day];
        if (self.maxNumRows < numberOfItems) {
            self.maxNumRows = numberOfItems;
        }
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *pathToItem = [NSIndexPath indexPathForItem:item inSection:day];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:pathToItem];
            attributes.frame = [self frameForItemAtIndexPath:pathToItem];
            [cellInformation setObject:attributes forKey:pathToItem];
        }
    }
    return cellInformation;
}

- (NSInteger)sectionRepresentingToday {
    return 0;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect;
    rect.origin = [self originForItemAtIndexPath:indexPath];
    rect.size = [self sizeOfItems];
    return rect;
}

- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = [self sizeOfItems];
    
    CGFloat x;
    switch (_viewMode) {
        case Now:
        case Day:
            x = [self collectionViewContentSize].width / 2.0f + self.collectionView.contentOffset.x - itemSize.width / 2.0f;
            break;
            
        case Week:
            x = INSET_LEFT + indexPath.section * (itemSize.width + self.insets.top + self.insets.right);
            break;
    }
    
    CGFloat y = ([self headerSize].height + self.insets.top) + indexPath.item * (itemSize.height + self.insets.top + self.insets.bottom);
    return CGPointMake(x, y);
}

- (CGSize)sizeOfItems {
    CGFloat edge;
    
    switch (_viewMode) {
        case Now:
            edge = (self.collectionView.bounds.size.height / 3.0f) - (INSET_RIGHT+INSET_LEFT) - [self headerSize].height / 3.0f;
            break;
            
        case Day:
        case Week:
            
            edge = (self.collectionView.bounds.size.width / self.collectionView.numberOfSections) - (INSET_RIGHT+INSET_LEFT);
            break;
    }
    
   return CGSizeMake(edge, edge);
}

#pragma mark Header Layout

- (NSDictionary *)headerAttributes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:DAYS_IN_WEEK];
    
    NSInteger firstDay;
    NSInteger lastDay;
    switch (_viewMode) {
        case Now:
        case Day:
            firstDay = lastDay = [self sectionRepresentingToday];
            break;
            
        case Week:
            firstDay = MONDAY;
            lastDay = SUNDAY;
            break;
    }

    
    for (NSInteger day = firstDay; day <= lastDay; day++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:day]; // assume there is always an item, so we can calculate offset of header.
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:path];
        attributes.frame = [self frameForHeaderOfSection:day];
        attributes.zIndex = 1024;
        [dictionary setObject:attributes forKey:path];
    }
    return dictionary;
}

- (CGRect)frameForHeaderOfSection:(NSUInteger)section {
    CGRect rect;
    rect.origin = [self originForHeaderOfSection:section];
    rect.size = [self headerSize];
    return rect;
}

- (CGPoint)originForHeaderOfSection:(NSUInteger)section {
    CGSize headerSize = [self headerSize];
    
    CGFloat x;
    switch (_viewMode) {
        case Now:
        case Day:
            x = [self collectionViewContentSize].width / 2.0f - headerSize.width / 2.0f + self.collectionView.contentOffset.x;
            break;
            
        case Week:
            x = section * headerSize.width;
            break;
    }
    
    CGFloat y = self.collectionView.contentOffset.y; // Moves the headers location up, so it is drawn above the first item
    return CGPointMake(x, y);
}

- (CGSize)headerSize {
    CGFloat width = [self columnWidth];
    CGFloat height = HEADER_HEIGHT;
    return CGSizeMake(width, height);
}

#pragma mark Step 2 - CollectionView Size and Grid configuration

/* 
 Return the overall size of the entire content, based on initial calculations.
 */

- (CGSize)collectionViewContentSize {
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentHeight = self.maxNumRows * [self rowHeight] + ([self headerSize].height + self.insets.top + self.insets.bottom);
    return CGSizeMake(contentWidth, contentHeight);
}

- (CGFloat)rowHeight {
    return [self sizeOfItems].height + self.insets.top + self.insets.bottom;
}

- (CGFloat)columnWidth {
    return self.collectionView.bounds.size.width / self.collectionView.numberOfSections;
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
        if ([key isEqualToString:HEADER_KEY]) {
            NSDictionary *headerAttributes = [self headerAttributes];
            for (NSIndexPath *key in headerAttributes) {
                [results addObject:[headerAttributes objectForKey:key]];
            }
        }
    }
    return results;
}

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

/* Collectionview asks if we want to invalidate (and recompute) the layout on scrolling and orientation change. */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/*
 Called by the collection view when it needs information about cells that might currently not be visible.
 Required for animation.
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellInformation = [self.layoutInformation objectForKey:CELL_KEY];
    UICollectionViewLayoutAttributes *attributes = [cellInformation objectForKey:indexPath];
    return attributes;
}

/*
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

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat verticalOffset = proposedContentOffset.y;
    
    CGRect targetRect = CGRectMake(0, proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [self layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        CGFloat itemOffset = layoutAttributes.frame.origin.y;
        if (ABS(itemOffset - verticalOffset) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemOffset - verticalOffset;
        }
    }
    CGPoint offset = CGPointMake(proposedContentOffset.x, proposedContentOffset.y + offsetAdjustment);
    offset.y -= [self headerSize].height;
    return offset;
}

@end