//
//  Currency.h
//  
//
//  Created by Lobanov Dmitry on 05.07.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@class Conversion;

@interface Currency : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *currencies;

@property (nonatomic, readonly) NSString * label;

#pragma mark - Helpers 
#pragma mark - Helpers / Create
+ (void)findOrCreateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

#pragma mark - Helpers / Save
+ (void)saveWithDictionary:(NSDictionary *)dictionary completion:(MRSaveCompletionHandler)completion;

+ (void)saveAllFromDictionaries:(NSArray *)dictionaries completion:(MRSaveCompletionHandler)completion;


@end

@interface Currency (CoreDataGeneratedAccessors)

- (void)addCurrenciesObject:(Conversion *)value;
- (void)removeCurrenciesObject:(Conversion *)value;
- (void)addCurrencies:(NSSet *)values;
- (void)removeCurrencies:(NSSet *)values;

@end
