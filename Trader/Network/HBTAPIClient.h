//
//  HBTAPIClient.h
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *HTTPOperationTypeGET;
extern NSString *HTTPOperationTypePOST;
extern NSString *HTTPOperationTypePUT;
extern NSString *HTTPOperationTypeDELETE;
extern NSString *HTTPOperationTypePATCH;

typedef void (^HBTAPIClientSuccessBlock)(id responseObject);
typedef void (^HBTAPIClientErrorBlock)(NSError *error, NSString *errorDescription);


@interface HBTAPIClient : NSObject

+ (instancetype)sharedAPIClient;


- (void)liveRatesForSource:(NSString *)sourceCurrency
            withCurrencies:(NSArray *)currencies
              successBlock:(HBTAPIClientSuccessBlock)successBlock
                errorBlock:(HBTAPIClientErrorBlock)errorBlock;

- (void)historicalRatesForSource:(NSString *)sourceCurrency
                  withCurrencies:(NSArray *)currencies
                          atDate:(NSDate *)date
                    successBlock:(HBTAPIClientSuccessBlock)successBlock
                      errorBlock:(HBTAPIClientErrorBlock)errorBlock;

- (void)allCurrenciesWithSuccessBlock:(HBTAPIClientSuccessBlock)successBlock
                           errorBlock:(HBTAPIClientErrorBlock)errorBlock;
@end
