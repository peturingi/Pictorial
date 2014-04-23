#import <Foundation/Foundation.h>

@class Pictogram;

#define CELL_ID_PICTOGRAM_SELECTOR  @"pictogramSelector"
#define CELL_TAG_FOR_IMAGE_VIEW     1
#define CELL_TAG_FOR_LABEL_VIEW     2

@interface PictogramsCollectionDataSource : NSObject <UICollectionViewDataSource> {
    NSArray *_data;
}

- (Pictogram *)pictogramAtIndexPath:(NSIndexPath *)indexPath;

@end