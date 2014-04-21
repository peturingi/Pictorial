#import "Schedule.h"
#import "Repository.h"

@implementation Schedule {
    NSMutableArray *_pictograms;
}

- (id)initWithTitle:(NSString *)title withColor:(UIColor *)color withUniqueIdentifier:(NSInteger)identifier {
    self = [super init];
    if (self) {
        _uniqueIdentifier = identifier;
        self.title = title;
        self.color = color;
    }
    return self;
}

- (NSArray*)pictograms {
    if (_pictograms == nil) {
        NSArray* associatedPictograms = [[Repository defaultRepository] pictogramsForSchedule:self includingImages:NO];
        _pictograms = [NSMutableArray arrayWithArray:associatedPictograms];
    }
    return _pictograms;
}

- (void)setPictograms:(NSArray *)pictograms {
    [[Repository defaultRepository]removeAllPictogramsFromSchedule:self];
    for (NSUInteger i = 0; i < pictograms.count; i++) {
        [[Repository defaultRepository] addPictogram:[pictograms objectAtIndex:i] toSchedule:self atIndex:i];
    }
    _pictograms = [NSMutableArray arrayWithArray:pictograms];
}

-(void)addPictogram:(Pictogram *)pictogram atIndex:(NSInteger)index{
    if(index > [self.pictograms count]){
        @throw [NSException exceptionWithName:@"OutOfBounds" reason:@"Cannot add pictogram beyond the bounds of the array" userInfo:nil];
    }
    if(index == [self.pictograms count]){
        [_pictograms addObject:pictogram];
        [[Repository defaultRepository]addPictogram:pictogram toSchedule:self atIndex:index];
        return;
    }
    if(index < [self.pictograms count]){
        [[Repository defaultRepository]removeAllPictogramsFromSchedule:self];
        [_pictograms insertObject:pictogram atIndex:index];
        for (NSUInteger i = 0; i < _pictograms.count; i++) {
            [[Repository defaultRepository] addPictogram:[_pictograms objectAtIndex:i] toSchedule:self atIndex:i];
        }
    }
}

-(void)removePictogramAtIndex:(NSInteger)index{
    if(index > [self.pictograms count]){
        @throw [NSException exceptionWithName:@"OutOfBounds" reason:@"Cannot remove pictogram which is beyond the bounds of the array" userInfo:nil];
    }
    if(index == [self.pictograms count]){
        Pictogram* pictogram = [_pictograms objectAtIndex:index];
        [_pictograms removeObjectAtIndex:index];
        [[Repository defaultRepository] removePictogram:pictogram fromSchedule:self atIndex:index];
        return;
    }
    if(index < [[self pictograms]count]){
        [[Repository defaultRepository]removeAllPictogramsFromSchedule:self];
        [_pictograms removeObjectAtIndex:index];
        for (NSUInteger i = 0; i < _pictograms.count; i++) {
            [[Repository defaultRepository] addPictogram:[_pictograms objectAtIndex:i] toSchedule:self atIndex:i];
        }
    }
}

-(void)exchangePictogramsAtIndex:(NSInteger)indexOne andIndex:(NSInteger)indexTwo{
    if(indexOne > [self.pictograms count] || indexTwo > [self.pictograms count]){
        @throw [NSException exceptionWithName:@"InvalidIndex" reason:@"One or both indecies was out of bounds" userInfo:nil];
    }
    [[Repository defaultRepository]removeAllPictogramsFromSchedule:self];
    [_pictograms exchangeObjectAtIndex:indexOne withObjectAtIndex:indexTwo];
    for (NSUInteger i = 0; i < _pictograms.count; i++) {
        [[Repository defaultRepository] addPictogram:[_pictograms objectAtIndex:i] toSchedule:self atIndex:i];
    }
}

- (NSString *)description {
    NSString *myDescription = [NSString stringWithFormat:@"Title:%@, Color:%@, Pictograms:%@", self.title, self.color.description, self.pictograms];
    return myDescription;
}

#pragma mark - ImplementsCount

- (NSInteger)count {
    return self.pictograms.count;
}

#pragma mark - ImplementsObjectAtIndex
- (id)objectAtIndex:(NSUInteger)index {
    @try {
        return [self.pictograms objectAtIndex:index];
    }
    @catch (NSException *e) {
        @throw e;
    }
}

@end
