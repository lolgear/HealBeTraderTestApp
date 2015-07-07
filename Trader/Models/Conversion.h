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
@property (nonatomic, retain) NSNumber * quote;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) Currency *source;
@property (nonatomic, retain) Currency *target;

- (void) fetchedAt:(NSInteger)timestamp;

@property (nonatomic, readonly) NSString *label;

+ (NSArray *)distinctSources;
+ (NSArray *)sourcesAndTargets;

#pragma mark - Helpers

#pragma mark - Helpers / Find
+ (instancetype)findBySource:(NSString *)source andTarget:(NSString *)target;

#pragma mark - Helpers / Create
+ (void) createWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

#pragma mark - Helpers / Save
+ (void) saveWithDictionary:(NSDictionary *)dictionary completion:(MRSaveCompletionHandler)completion;

+ (void) saveAllFromDictionaries:(NSArray *)dictionaries completion:(MRSaveCompletionHandler)completion;

#pragma mark - Helpers / Delete
+ (void) remove:(Conversion *)conversion completion:(MRSaveCompletionHandler)completion;

+ (void) removeAllOld:(NSInteger)timestamp completion:(MRSaveCompletionHandler)completion;

@end
