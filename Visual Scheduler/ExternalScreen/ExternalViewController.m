#import "ExternalViewController.h"
#import "../CalendarView/CalendarView.h"
#import "ExternalViewDataSource.h"

@implementation ExternalViewController
-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithCollectionViewLayout:layout];
    if(self){
    }
    return self;
}

-(void)loadView{
    [super loadView];
    [self setupCollectionView];
}

-(void)setupCollectionView{
    CGRect frame = [[self view]frame];
    UICollectionViewLayout* layout = [self collectionViewLayout];
    UICollectionView* view = [[CalendarView alloc]initWithFrame:frame collectionViewLayout:layout];
    [view setDataSource:[[ExternalViewDataSource alloc]init]];
    [view setBackgroundColor:[UIColor grayColor]];
    [self setCollectionView:view];
   }
@end
