#define ENG_LOOKUPTABLE @"en_GB_lookup"
#define DB_FILENAME @"localeDb.sqlite3"
#import "Localizer.h"

@implementation Localizer
-(id)init{
    @throw [NSException exceptionWithName:@"InvalidInstantiationException" reason:@"Cannot instatiate using default -init. Either use shared singleton instance, or -initLocalizerForLocale:" userInfo:nil];
}

+(instancetype)defaultLocalizer{
    static dispatch_once_t once;
    static id sharedManager;
    dispatch_once(&once, ^{
        NSString* localeString = [[NSLocale currentLocale]localeIdentifier];
        sharedManager = [[self alloc]initLocalizerForLocale:localeString];
    });
    return sharedManager;
}

-(id)initLocalizerForLocale:(NSString*)localeString{
    self = [super init];
    if(self){
        NSParameterAssert(localeString);
        _localeIdentifier = localeString;
        _dbcon = [[SQLiteDatabaseConnection alloc]initWithDatabaseFileNamed:DB_FILENAME];
        [self checkLocaleExistsInDatabase];
    }
    return self;
}

-(void)checkLocaleExistsInDatabase{
    NSString* query = @"SELECT name FROM sqlite_master WHERE type='table' AND name IS (?)";
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:_localeIdentifier atPosition:1];
    if([_dbcon rowExistsFromStatement:statement]){
        _localeExists = YES;
    }else{
        _localeExists = NO;
    }
    [_dbcon finalizeStatement:statement];
}

-(NSString*)localizeString:(NSString *)string{
    if(!_localeExists){
        return string.lowercaseString;
    }
    NSString* query = [NSString stringWithFormat:@"SELECT value FROM %@ INNER JOIN (SELECT id FROM %@ WHERE value IS (?)) AS Eng WHERE eng_id = Eng.id", _localeIdentifier, ENG_LOOKUPTABLE];
    sqlite3_stmt* statement = [_dbcon prepareStatementWithQuery:query];
    [_dbcon bindTextToStatement:statement text:string atPosition:1];
    NSString* translatedString;
    if([_dbcon rowExistsFromStatement:statement]){
        translatedString = [_dbcon stringFromStatement:statement atColumnIndex:0];
    }else{
        translatedString = string;
    }
    return translatedString.lowercaseString;
}
@end
