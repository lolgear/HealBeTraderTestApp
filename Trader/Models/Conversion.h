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

@end
