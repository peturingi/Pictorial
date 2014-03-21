#import "BBAShowScheduleTableDataSource.h"

@implementation BBAShowScheduleTableDataSource

- (id)init {
    self = [super init];
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.section == 0);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"schedulesPictogram" forIndexPath:indexPath];

    UIView *cellsContentView = cell.contentView;
    UIImageView *pictogramImageView;
    for (UIView *subview in cellsContentView.subviews) {
        if (subview.tag == 1) {
            pictogramImageView = (UIImageView *)subview;
            break;
        }
    }
    Pictogram *pictogramToDisplayInImageView = [self.dataSource objectAtIndex:indexPath.row];
    pictogramImageView.image = [UIImage imageWithContentsOfFile:pictogramToDisplayInImageView.imageURL];
    
    return cell;
}

- (NSArray *)dataSource {
    return self.delegate.schedule.pictograms.array;
}

@end
