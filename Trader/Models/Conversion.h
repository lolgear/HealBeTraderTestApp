//
//  Conversion.h
//  
//
//  Created by Lobanov Dmitry on 05.07.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@class Currency;

@interface Conversion : NSManagedObject

@property (nonatomic, retain) NSNumber * added_at;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSNumber * first_time_quote;
@property (nonatomic, retain) NSNumber * quote;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) Currency * source;
@property (nonatomic, retain) Currency * target;

- (void) setTimestampByValue:(NSNumber *)timestamp;
- (void) setQuoteByValue:(NSNumber *)value;
- (void) setFavoritedByValue:(NSNumber *)favorited;
@property (nonatomic, readonly) NSNumber *trend;
@property (nonatomic, readonly) NSString *label;

+ (NSArray *)distinctSources;
+ (NSArray *)sourcesAndTargets;
+ (NSArray *)findAllFavorited;
+ (NSFetchedResultsController *)fetchAllFavorited;

#pragma mark - Helpers

#pragma mark - Helpers / Find
+ (instancetype) findBySource:(NSString *)source andTarget:(NSString *)target;

#pragma mark - Helpers / Create
+ (instancetype) updateOrCreateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

+ (instancetype) createWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

#pragma mark - Helpers / Save
+ (void) saveWithDictionary:(NSDictionary *)dictionary completion:(MRSaveCompletionHandler)completion;

+ (void) saveAllFromDictionaries:(NSArray *)dictionaries completion:(MRSaveCompletionHandler)completion;

#pragma mark - Helpers / Favorited
+ (void) like:(Conversion *)conversion withValue:(BOOL)favorited completion:(MRSaveCompletionHandler)completion;
+ (void) unlike:(Conversion *)conversion completion:(MRSaveCompletionHandler)completion;

#pragma mark - Helpers / Delete
+ (void) remove:(Conversion *)conversion completion:(MRSaveCompletionHandler)completion;

+ (void) remove:(Conversion *)conversion inContext:(NSManagedObjectContext *)context;

+ (void) removeAllOld:(NSInteger)timestamp completion:(MRSaveCompletionHandler)completion;

@end
