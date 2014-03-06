#import <Foundation/Foundation.h>

@interface BBAServiceProvider : NSObject

+(id)serviceFromClass:(Class)aClass;
+(void)insertService:(id)service;
+(void)deleteServiceOfClass:(Class)aClass;

@end
