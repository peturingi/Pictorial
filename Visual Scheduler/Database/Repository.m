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
    NSDictionary *content = @{@"title" : title,
                              @"color" : [NSNumber numberWithInteger:[BBAColor indexForColor:color]]};
    NSInteger uniqueIdentifier = [_dataStore createSchedule:content];
    Schedule *schedule = [[Schedule alloc] initWithTitle:title withColor:color withUniqueIdentifier:uniqueIdentifier];
    return schedule;
}

- (Pictogram *)pictogramWithTitle:(NSString *)title withImage:(UIImage *)image {
    NSParameterAssert(title != nil);
    NSParameterAssert(image != nil);
    NSDictionary *content = @{@"title" : title,
                              @"image" : UIImagePNGRepresentation(image)};
    NSInteger uniqueIdentifier = [_dataStore createPictogram:content];
    Pictogram *pictogram = [[Pictogram alloc] initWithTitle:title withUniqueIdentifier:uniqueIdentifier withImage:image];
    return pictogram;
}

#pragma mark - Delete
- (void)deleteSchedule:(Schedule *)aSchedule {
    NSParameterAssert(aSchedule != nil);
    [_dataStore deleteScheduleWithID:aSchedule.uniqueIdentifier];
}

#pragma mark - Retrieve
- (NSArray *)allSchedules {
    NSMutableArray *schedules = [NSMutableArray array];
    NSArray *rawSchedules = [_dataStore contentOfAllSchedules];
    for (NSDictionary *dict in rawSchedules) {
        NSNumber *uniqueIdentifier = [dict valueForKey:@"id"];
        NSString *title = [dict valueForKey:@"title"];
        UIColor *color = [BBAColor colorForIndex:[[dict valueForKey:@"color"] integerValue]];
        Schedule *schedule = [[Schedule alloc] initWithTitle:title withColor:color withUniqueIdentifier:uniqueIdentifier.integerValue];
        [schedules addObject:schedule];
    }
    return schedules;
}

- (NSArray *)allPictogramsIncludingImages:(BOOL)value {
    NSMutableArray *pictograms = [NSMutableArray array];
    NSArray *rawPictograms = [_dataStore contentOfAllPictogramsIncludingImageData:value];
    for (NSDictionary *dict in rawPictograms) {
        NSNumber *uniqueIdentifier = [dict valueForKey:@"id"];
        NSString *title = [dict valueForKey:@"title"];
        UIImage *image = value ? [UIImage imageWithData:[dict valueForKey:@"image"]] : nil;
        Pictogram *pictogram = [[Pictogram alloc] initWithTitle:title withUniqueIdentifier:uniqueIdentifier.integerValue withImage:image];
        [pictograms addObject:pictogram];
    }
    return pictograms;
}

-(void)addPictogram:(Pictogram *)pictogram toSchedule:(Schedule *)schedule atIndex:(NSInteger)index{
    NSParameterAssert(pictogram != nil);
    NSParameterAssert(schedule != nil);
    NSParameterAssert(index >= 0);
    [_dataStore addPictogram:pictogram.uniqueIdentifier toSchedule:schedule.uniqueIdentifier atIndex:index];
}

-(NSArray*)pictogramsForSchedule:(Schedule *)schedule includingImages:(BOOL)value{
    NSMutableArray* pictograms = [NSMutableArray array];
    NSArray* contentForPictograms = [_dataStore contentOfAllPictogramsInSchedule:schedule.uniqueIdentifier includingImageData:value];
    for(NSDictionary* dict in contentForPictograms){
        NSNumber *uniqueIdentifier = [dict valueForKey:@"id"];
        NSString *title = [dict valueForKey:@"title"];
        UIImage *image = nil;
        if (value) {
            NSData *imageData = [dict valueForKey:@"image"];
            image = [UIImage imageWithData:imageData];
        }
        Pictogram *pictogram = [[Pictogram alloc] initWithTitle:title withUniqueIdentifier:uniqueIdentifier.integerValue withImage:image];
        [pictograms addObject:pictogram];
    }
    return pictograms;
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
    NSArray* contentForPictogram = [_dataStore contentOfPictogramWithID:pictogram.uniqueIdentifier];
    UIImage* image = [UIImage imageWithData:[contentForPictogram objectAtIndex:0]];
    return image;
}
@end
