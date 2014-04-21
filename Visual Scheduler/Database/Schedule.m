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
    if(index > [_pictograms count]){
        @throw [NSException exceptionWithName:@"OutOfBounds" reason:@"Cannot add pictogram beyond end of array" userInfo:nil];
    }
    if(index == [_pictograms count]){
        [_pictograms addObject:pictogram];
        [[Repository defaultRepository]addPictogram:pictogram toSchedule:self atIndex:index];
        return;
    }
    
    if(index < [_pictograms count]){
        NSRange firstRange = NSMakeRange(0,index - 1);
        NSRange secondRange = NSMakeRange(index, [_pictograms count] - index - 1);
        NSArray* firstPart = [_pictograms subarrayWithRange:firstRange];
        NSArray* secondPart = [_pictograms subarrayWithRange:secondRange];
        _pictograms = [NSMutableArray arrayWithArray:firstPart];
        [_pictograms addObject:pictogram];
        [_pictograms addObjectsFromArray:secondPart];
        [[Repository defaultRepository]addPictogram:pictogram toSchedule:self atIndex:index];
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
