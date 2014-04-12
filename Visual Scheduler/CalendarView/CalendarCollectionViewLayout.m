#import "CalendarCollectionViewLayout.h"

static const NSInteger NUMBER_OF_COLUMNS = 7;
static const NSInteger INSET_TOP    = 2;
static const NSInteger INSET_LEFT   = 2;
static const NSInteger INSET_RIGHT  = 2;
static const NSInteger INSET_BOTTOM = 2;

#define CELL_KEY @"ImageCell"

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

#pragma mark - UICollectionViewLayout Process
/*
 During the layout process, the collection view calls specific methods of this layout object.
 The methods calculate the position of items and provide the collection view with the primary information it needs.
 There are three primary methods which are always called in the same three step order.
 */


#pragma mark Step 1
/*
 Performs up-front calculations needed to provide layout information (such as the position of cells and views).
 This information is used by the collection view in order to determine its scoll view size.
 After calling this method, the layout must have enouth information to calculate the collection view's content size.
 */

- (void)prepareLayout {
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (self.maxNumRows < numberOfItems) {
            self.maxNumRows = numberOfItems;
        }
        
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *pathToItem = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:pathToItem];
            attributes.frame = [self frameForItemAtIndexPath:pathToItem];
            [cellInformation setObject:attributes forKey:pathToItem];
        }
    }
    self.layoutInformation = @{CELL_KEY : cellInformation};
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect;
    rect.origin = [self originForItemAtIndexPath:indexPath];
    rect.size = [self sizeOfItems];
    return rect;
}

- (CGPoint)originForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = [self sizeOfItems];
    CGFloat x = INSET_LEFT + indexPath.section * (itemSize.width + INSET_LEFT + INSET_RIGHT) ;
    CGFloat y = INSET_TOP + indexPath.item * (itemSize.height + INSET_TOP + INSET_BOTTOM);
    return CGPointMake(x, y);
}

- (CGSize)sizeOfItems {
    CGFloat edge = (self.collectionViewContentSize.width / NUMBER_OF_COLUMNS) - (INSET_RIGHT+INSET_LEFT);
   return CGSizeMake(edge, edge);
}

#pragma mark Step 2
/* 
 Return the overall size of the entire content, based on initial calculations.
 */

- (CGSize)collectionViewContentSize {
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    CGFloat contentHeight = self.maxNumRows * [self rowHeight];
    return CGSizeMake(contentWidth, contentHeight);
}

- (CGFloat)rowHeight {
    return [self columnWidth];
}

- (CGFloat)columnWidth {
    return self.collectionView.bounds.size.width / NUMBER_OF_COLUMNS;
}

#pragma mark Step 3
/*
 Provide layout attributes for every cell and every supplementary or decoration view that
 intersects the area currently shown (sometimes not shown!) by the collectionview's scrollview.
 
 The implementation of this step is defined by Apple as:
 1. Iterate over the data generated by prepareLayout, to either access cached attributes or create new ones as needed.
 2. Check the frame of each item to see whether it intersects the rectangle passsed to the layoutAttributesForElementsInRect.
 3. For each intersecting item, add a corresponding UICollectionViewLayoutAttributeObject to the array to be returned.
 4. Return the array of layout attributes to the collection view.
*/

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    for (NSString *key in self.layoutInformation) {
        NSDictionary *attributes = [self.layoutInformation objectForKey:key];
        NSArray *intersectingAttributes = [self attributesIn:attributes intersecting:rect];
        [results addObjectsFromArray:intersectingAttributes];
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

/* Invalidate the layout on scrolling and orientation change. */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellInformation = [self.layoutInformation objectForKey:CELL_KEY];
    UICollectionViewLayoutAttributes *attributes = [cellInformation objectForKey:indexPath];
    return attributes;
}

@end
