#import <Foundation/Foundation.h>
@class Pictogram;

@protocol DataSourceCanAddPictogram <NSObject>

@required
- (void)addPictogram:(Pictogram *)pictogram toCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (void)setEditing:(BOOL)value;

@end