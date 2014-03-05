#import "BBAModel.h"
NSString* const kBBAModelExtension = @"momd";

@implementation BBAModel

#pragma mark - public methods
-(NSManagedObjectModel*)managedObjectModel{
    return _managedObjectModel;
}

+(instancetype)modelFromModelNamed:(NSString*)modelName{
    BBAModel* model = [[BBAModel alloc]initWithModelNamed:modelName];
    return model;
}

#pragma mark - private methods
-(id)initWithModelNamed:(NSString*)modelName{
    self = [super init];
    if(self){
        [self verifyModelName:modelName];
        [self setupManagedObjectModelFromModelName:modelName];
    }
    return self;
}

-(void)verifyModelName:(NSString*)modelName{
    if(!modelName || [modelName length] == 0){
        [NSException raise:@"modelName invalid" format:@"modelName was either empty or nil"];
    }
}

-(void)setupManagedObjectModelFromModelName:(NSString*)modelName{
    NSURL* modelURL = [self modelURLFromString:modelName];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if(!_managedObjectModel){
        [NSException raise:@"Failed to create model" format:@"Initializing the managed object model failed. This was unexpected. Probable cause is an invalid or corrupted data model"];
    }
}

-(NSURL*)modelURLFromString:(NSString*)modelName{
    NSBundle* bundle = [NSBundle mainBundle];
    NSURL* url = [bundle URLForResource:modelName withExtension:kBBAModelExtension];
    if(!url){
        [NSException raise:@"modelName invalid" format:@"Could not locate a model corrosponding to the provided modelName"];
    }
    return url;
}

-(id)init __deprecated{
    [NSException raise:@"-init not allowed" format:@"Initialization using standard -init is not allowed - please use the provided classmethod"];
    return nil;
}

@end
