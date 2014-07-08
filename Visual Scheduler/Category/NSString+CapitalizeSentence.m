#import "NSString+CapitalizeSentence.h"

@implementation NSString (CapitalizeSentence)
-(NSString*)capitalizedSentence{
    if([self length] < 2){
        return self.capitalizedString;
    }
    NSRange charactersInRange = NSMakeRange(0, 1);
    NSString* firstCharacterCapitalized = [self substringToIndex:1].capitalizedString;
    return [self stringByReplacingCharactersInRange:charactersInRange withString:firstCharacterCapitalized];
}
@end
