#import "BBAServiceProvider.h"

static NSMutableDictionary* _services = nil;

@implementation BBAServiceProvider

-(id)init{
    [NSException raise:@"-init not allowed" format:@"Initialization using standard -init is not allowed - please use the provided classmethod"];
    return nil;
}
+(id)serviceFromClass:(Class)aClass{
    id service = [[self services] valueForKey:NSStringFromClass([aClass class])];
    if(!service){
        [NSException raise:@"Invalid request" format:@"The service you requested could not be located. Please ensure that the service you request has been inserted beforehand"];
    }
    return service;
}

+(void)insertService:(id)service{
    if([self serviceExists:service]){
        [NSException raise:@"Service exists" format:@"Cannot insert an already existing service"];
    }
    [[self services] setValue:service forKey:NSStringFromClass([service class])];
}

+(void)deleteServiceOfClass:(Class)aClass{
    [[self services] setValue:nil forKey:NSStringFromClass(aClass)];
}

+(NSMutableDictionary*)services{
    if(!_services){
        _services = [NSMutableDictionary dictionary];
    }
    return _services;
}

+(BOOL)serviceExists:(id)service{
    id value = [[self services] valueForKey:NSStringFromClass([service class])];
    if(value){
        return YES;
    }else{
        return NO;
    }
}

@end
