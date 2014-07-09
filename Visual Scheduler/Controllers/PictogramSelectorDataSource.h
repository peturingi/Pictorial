#import <Foundation/Foundation.h>

@class Pictogram;

#define CELL_TAG_FOR_IMAGE_VIEW     1
#define CELL_TAG_FOR_LABEL_VIEW     2

@interface PictogramSelectorDataSource : NSObject <UICollectionViewDataSource> {
    NSArray *_data;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (Pictogram *)pictogramAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadData;
@end