#import "ImageSourceTableViewController.h"

@implementation ImageSourceTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     The rows have tags set in the Storyboard:
     1  Camera
     2  Photo Album
     */
    switch ([self.tableView cellForRowAtIndexPath:indexPath].tag) {
        case 1:
            [self.delegate showCameraPicker];
            break;
        case 2:
            [self.delegate showAlbumPicker];
            break;
        default:
            NSAssert(false, @"Should not be reachable.");
    }
}

@end
