#import "ImageSourceTableViewController.h"

@interface ImageSourceTableViewController ()

@end

@implementation ImageSourceTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     The rows have tags set in the Storyboard:
     1  Camera
     2  Photo Album
     */
    switch ([self.tableView cellForRowAtIndexPath:indexPath].tag) {
        case 1:
            NSLog(@"Camera");
            break;
        case 2:
            NSLog(@"Photo Album");
            break;
        default:
            NSAssert(false, @"Should not be reachable.");
    }
}

@end
