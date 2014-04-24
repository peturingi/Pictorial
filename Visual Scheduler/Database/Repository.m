#import "Repository.h"
#import "BBAColor.h"
#import "SQLiteStore.h"
@implementation Repository

#pragma mark - Constructor / Deconstructor
+ (instancetype)defaultRepository {
    static dispatch_once_t once;
    static id sharedRepository;
    dispatch_once(&once, ^{
        SQLiteStore* store = [[SQLiteStore alloc]init];
        sharedRepository = [[Repository alloc]initWithStore:store];
    });
    return sharedRepository;
}

- (id)initWithStore:(id<DataStoreProtocol>)store {
    NSParameterAssert(store != nil);
    self = [super init];
    if (self) {
        _dataStore = store;
        _imageCache = [[ImageCache alloc]init];
    }
    return self;
}

- (void)dealloc {
    _dataStore = nil;
}

#pragma mark - Create
- (Schedule *)scheduleWithTitle:(NSString *)title withColor:(UIColor *)color {
    NSParameterAssert(title != nil);
    NSParameterAssert(color != nil);
    NSDictionary *content = @{TITLE_KEY : title,
                              COLOR_KEY : [NSNumber numberWithInteger:[BBAColor indexForColor:color]]};
    NSInteger uniqueIdentifier = [_dataStore createSchedule:content];
    Schedule *schedule = [[Schedule alloc] initWithTitle:title withColor:color withUniqueIdentifier:uniqueIdentifier];
    return schedule;
}

- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image {
    NSParameterAssert(title != nil);
    NSParameterAssert(image != nil);
    NSDictionary *content = @{TITLE_KEY : title,
                              IMAGE_KEY : UIImagePNGRepresentation(image)};
    NSInteger uniqueIdentifier = [_dataStore createPictogram:content];
    Pictogram *pictogram = [[Pictogram alloc] initWithTitle:title withUniqueIdentifier:uniqueIdentifier withImage:image];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NOTIFICATION_PICTOGRAM_INSERTED object:[NSNumber numberWithInteger:uniqueIdentifier]];
    return pictogram;
}

#pragma mark - Delete
- (void)deleteSchedule:(Schedule *)aSchedule {
    NSParameterAssert(aSchedule != nil);
    [_dataStore deleteScheduleWithID:aSchedule.uniqueIdentifier];
}

-(void)removePictogram:(Pictogram *)pictogram fromSchedule:(Schedule *)schedule atIndex:(NSInteger)index{
    NSParameterAssert(pictogram);
    NSParameterAssert(schedule);
    NSParameterAssert(index >= 0);
    [_dataStore removePictogram:pictogram.uniqueIdentifier fromSchedule:schedule.uniqueIdentifier atIndex:index];
}

#pragma mark - Retrieve
- (Schedule *)scheduleNumber:(NSInteger)number {
#warning needs to be optimized such that this method does not fetch everything.
    NSArray *allSchedules = [self allSchedules];
    return [allSchedules objectAtIndex:number];
}

- (NSArray *)allSchedules {
    NSArray *contents = [_dataStore contentOfAllSchedules];
    return [self schedulesFromContentArray:contents];
}

- (NSArray *)allPictograms{
    NSArray *contents = [_dataStore contentOfAllPictogramsIncludingImageData:NO];
    return [self pictogramsFromContentArray:contents];
}

-(void)addPictogram:(Pictogram *)pictogram toSchedule:(Schedule *)schedule atIndex:(NSInteger)index{
    NSParameterAssert(pictogram != nil);
    NSParameterAssert(schedule != nil);
    NSParameterAssert(index >= 0);
    [_dataStore addPictogram:pictogram.uniqueIdentifier toSchedule:schedule.uniqueIdentifier atIndex:index];
}

-(NSArray*)pictogramsForSchedule:(Schedule *)schedule{
    NSArray* contents = [_dataStore contentOfAllPictogramsInSchedule:schedule.uniqueIdentifier includingImageData:NO];
    return [self pictogramsFromContentArray:contents];
}

- (void)removeAllPictogramsFromSchedule:(Schedule *)schedule {
    NSParameterAssert(schedule != nil);
    NSParameterAssert(schedule.pictograms != nil);
    for (NSUInteger i = 0; i < schedule.pictograms.count; i++) {
        Pictogram *pictogramToRemoved = [schedule.pictograms objectAtIndex:i];
        [_dataStore removePictogram:pictogramToRemoved.uniqueIdentifier fromSchedule:schedule.uniqueIdentifier atIndex:i];
    }
}

-(UIImage*)imageForPictogram:(Pictogram *)pictogram{
    NSParameterAssert(pictogram);
    NSInteger index = [pictogram uniqueIdentifier];
    UIImage* image = [_imageCache imageAtIndex:index];
    if(image == nil){
        NSArray* contentForPictogram = [_dataStore imageContentOfPictogramWithID:index];
        image = [UIImage imageWithData:[contentForPictogram objectAtIndex:0]];
        [_imageCache insertImage:image atIndex:index];
    }
    return image;
}


-(Pictogram*)pictogramForIdentifier:(NSInteger)identifier{
    NSParameterAssert(identifier > 0);
    NSArray* contentForPictogram = [_dataStore contentOfPictogramWithID:identifier];
    Pictogram* pictogram = [[self pictogramsFromContentArray:contentForPictogram]objectAtIndex:0];
    return pictogram;
}


#pragma mark - private methods
-(NSArray*)pictogramsFromContentArray:(NSArray*)contents{
    NSMutableArray* pictograms = [NSMutableArray array];
    for(NSDictionary* dict in contents){
        NSNumber *uniqueIdentifier = [dict valueForKey:ID_KEY];
        NSString *title = [dict valueForKey:TITLE_KEY];
        UIImage *image = [UIImage imageWithData:[dict valueForKey:IMAGE_KEY]];
        Pictogram *pictogram = [[Pictogram alloc] initWithTitle:title withUniqueIdentifier:uniqueIdentifier.integerValue withImage:image];
        [pictograms addObject:pictogram];
    }
    return pictograms;
}

-(NSArray*)schedulesFromContentArray:(NSArray*)contents{
    NSMutableArray *schedules = [NSMutableArray array];
    for (NSDictionary *dict in contents) {
        NSNumber *uniqueIdentifier = [dict valueForKey:ID_KEY];
        NSString *title = [dict valueForKey:TITLE_KEY];
        UIColor *color = [BBAColor colorForIndex:[[dict valueForKey:COLOR_KEY] integerValue]];
        Schedule *schedule = [[Schedule alloc] initWithTitle:title withColor:color withUniqueIdentifier:uniqueIdentifier.integerValue];
        [schedules addObject:schedule];
    }
    return schedules;
}
@end
