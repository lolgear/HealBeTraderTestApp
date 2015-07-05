//
//  Currency.h
//  
//
//  Created by Lobanov Dmitry on 05.07.15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversion;

@interface Currency : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *currencies;
@end

@interface Currency (CoreDataGeneratedAccessors)

- (void)addCurrenciesObject:(Conversion *)value;
- (void)removeCurrenciesObject:(Conversion *)value;
- (void)addCurrencies:(NSSet *)values;
- (void)removeCurrencies:(NSSet *)values;

@end
