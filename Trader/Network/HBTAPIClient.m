//
//  HBTAPIClient.m
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "HBTAPIClient.h"
#import "NSFoundationExtendedMethods.h"
#import "AIKResources.h"
#import <AFNetworking/AFNetworking.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

static const DDLogLevel ddLogLevel = DDLogLevelDebug;

NSString *HTTPOperationTypeGET = @"GET";
NSString *HTTPOperationTypePOST = @"POST";
NSString *HTTPOperationTypePUT = @"PUT";
NSString *HTTPOperationTypeDELETE = @"DELETE";
NSString *HTTPOperationTypePATCH = @"PATCH";

static NSString *accessKeyParameterName = @"access_key";
static NSString *currenciesParameterName = @"currencies";
static NSString *dateParameterName = @"date";
static NSString *formatParameterName = @"format";
static NSString *sourceParameterName = @"source";

static NSString *currenciesEndpointName = @"currencies.json";
static NSString *liveEndpointName = @"live";
static NSString *historicalEndpointName = @"historical";
static NSString *apiPathNameHistorical = @"historical";
static NSString *apiKey = @"791cfed4992935eae19dacb8e4945f6a";//@"f8a9b90bc6525a28e131b47630a60abc";
// 791cfed4992935eae19dacb8e4945f6a

@interface HBTAPIClient ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation HBTAPIClient

#pragma mark - Instantiation
+ (instancetype)sharedAPIClient {
    static id sharedApiClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedApiClient = [self new];
    });

    return sharedApiClient;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"YYYY-MM-DD"];
    }
    return _dateFormatter;
}

- (AFHTTPSessionManager *)apilayerManager {
    NSString *host = @"apilayer.net";
    NSString *APIPath = @"api";

    NSString *baseURL = [self baseURLForHost:host andAPIPath:APIPath andUseSSL:NO];

    return [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
}

- (AFHTTPSessionManager *)jsonRatesManager {
    NSString *host = @"jsonrates.com";
    NSString *APIPath = @"";
    
    NSString *baseURL = [self baseURLForHost:host andAPIPath:APIPath andUseSSL:NO];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
}

- (NSString *)baseURLForHost:(NSString *)host andAPIPath:(NSString *)apiPath andUseSSL:(BOOL)useSSL {

    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@://%@", useSSL ? @"https" : @"http", host];

    if (apiPath) {
        [urlString appendFormat:@"/%@", apiPath];
    }
    return urlString;
}

#pragma mark - Common operations
- (void)commonHttpOperationWithType:(NSString *)type
                           withPath:(NSString *)path
                     withParameters:(NSDictionary *)initialParameters
                         authorized:(BOOL)authorizedOperation
                         apiManager:(AFHTTPSessionManager *)manager
                       successBlock:(HBTAPIClientSuccessBlock)successBlock
                         errorBlock:(HBTAPIClientErrorBlock)errorBlock {

    NSMutableDictionary *parameters = [initialParameters mutableCopy];

    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }

    void (^responseSuccessBlock)(NSURLSessionDataTask *operation, id responseObject) = ^(NSURLSessionDataTask *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    };

    void (^responseErrorBlock)(NSURLSessionDataTask *operation, NSError *error) = ^(NSURLSessionDataTask *operation, NSError *error) {
        NSDictionary *errorServerDescription = (NSDictionary *)
        [NSData jsonObjectFromData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]];

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;

        NSError *blessedError = [NSError errorWithDomain:error.domain code:response.statusCode userInfo:error.userInfo];

        BOOL errorServerDescriptionErrorIsOk =
        [errorServerDescription isKindOfClass:[NSDictionary class]] && [errorServerDescription[@"error"] isNotNull] && [errorServerDescription[@"error"] isVisible];

        if (!errorServerDescriptionErrorIsOk) {
            errorServerDescription = @{
                                       @"error": error ? error.localizedDescription : [ILMStringsManager getGeneralErrorTitleString]
                                       };
        }

        BOOL errorServerDescriptionDetailsIsOk =
        [errorServerDescription isKindOfClass:[NSDictionary class]] && [errorServerDescription[@"developerDetails"] isNotNull] && [errorServerDescription[@"developerDetails"] isVisible];

        if (errorServerDescriptionDetailsIsOk) {
            DDLogDebug(@"%@ developerDetails: %@", self.class, errorServerDescription[@"developerDetails"]);
        }

        DDLogDebug(@"%@ error: %@", self.class, errorServerDescription[@"error"]);



        errorBlock(blessedError, errorServerDescription[@"error"]);
    };

    if (authorizedOperation) {
        // do something
    }

    NSDictionary *operationInfoHash = @{
                                        @"type" : type,
                                        @"path" : path,
                                        @"parameters" : parameters,
                                        @"headers" : [manager.requestSerializer valueForKey:@"mutableHTTPRequestHeaders"]
                                        };

    DDLogDebug(@"I will perform operation: %@", operationInfoHash);
    if ([type isEqualToString:HTTPOperationTypeGET]) {
        [manager GET:path parameters:parameters success:responseSuccessBlock failure:responseErrorBlock];
    } else if ([type isEqualToString:HTTPOperationTypePOST]) {
        [manager POST:path parameters:parameters success:responseSuccessBlock failure:responseErrorBlock];
    } else if ([type isEqualToString:HTTPOperationTypePUT]) {
        [manager PUT:path parameters:parameters success:responseSuccessBlock failure:responseErrorBlock];
    } else if ([type isEqualToString:HTTPOperationTypeDELETE]) {
        [manager DELETE:path parameters:parameters success:responseSuccessBlock failure:responseErrorBlock];
    } else if ([type isEqualToString:HTTPOperationTypePATCH]) {
        [manager PATCH:path parameters:parameters success:responseSuccessBlock failure:responseErrorBlock];
    }
}

- (NSMutableDictionary *)commonParametersDictionary {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[accessKeyParameterName] = apiKey;
    params[formatParameterName] = @1;
    return params;
}

- (NSString *)stringFromDate:(NSDate *)date {
    return [self.dateFormatter stringFromDate:date];
}

- (AFURLConnectionOperation *)urlConnectionOperationWithType:(NSString *)type
                              withPath:(NSString *)path
                        withParameters:(NSDictionary *)initialParameters
                            authorized:(BOOL)authorizedOperation
                            apiManager:(AFHTTPSessionManager *)manager {
    NSMutableDictionary *parameters = [initialParameters mutableCopy];
    
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }

    NSDictionary *operationInfoHash = @{
                                        @"type" : type,
                                        @"path" : path,
                                        @"parameters" : parameters,
                                        @"headers" : [manager.requestSerializer valueForKey:@"mutableHTTPRequestHeaders"]
                                        };
    DDLogDebug(@"%@ this is operation: %@", self, operationInfoHash);
    NSString *parametersString = [NSString stringFromURLParamsDictionary:parameters];
    
    NSURL *fullPathURL = [manager.baseURL URLByAppendingPathComponent:path];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:[fullPathURL absoluteString]];
    
    [components setQuery:parametersString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[components URL]];

    DDLogDebug(@"%@ I have request url: %@", self, request.URL.absoluteString);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    return operation;
}

#pragma mark - Operations

// Endpoint : {Live}
// Params : {
//    "access_key" : "YOUR_ACCESS_KEY"
//    "source" : "GBP"
//    "currencies" : "USD,AUD,CAD,PLN,MXN"
//    "format" : 1
// }
- (AFURLConnectionOperation *)liveOperationForSource:(NSString *)sourceCurrency
                                      withCurrencies:(NSArray *)currencies {
    NSMutableDictionary *params = [self commonParametersDictionary];
    if ([sourceCurrency isVisible]) {
        params[sourceParameterName] = sourceCurrency;
    }
    
    if (currencies) {
        params[currenciesParameterName] = [currencies componentsJoinedByString:@","];
    }
    
    return [self urlConnectionOperationWithType:HTTPOperationTypeGET withPath:liveEndpointName withParameters:params authorized:NO apiManager:[self apilayerManager]];
}

- (void)liveRatesWithSuccessBlock:(HBTAPIClientSuccessBlock)successBlock errorBlock:(HBTAPIClientErrorBlock)errorBlock {
    [self liveRatesForSource:nil withCurrencies:nil successBlock:successBlock errorBlock:errorBlock];
}

- (void)liveRatesForSource:(NSString *)sourceCurrency
            withCurrencies:(NSArray *)currencies
              successBlock:(HBTAPIClientSuccessBlock)successBlock
                errorBlock:(HBTAPIClientErrorBlock)errorBlock {
    NSMutableDictionary *params = [self commonParametersDictionary];

    if ([sourceCurrency isVisible]) {
        params[sourceParameterName] = sourceCurrency;
    }
    
    if (currencies) {
        params[currenciesParameterName] = [currencies componentsJoinedByString:@","];
    }

    [self commonHttpOperationWithType:HTTPOperationTypeGET withPath:liveEndpointName withParameters:params authorized:NO apiManager:[self apilayerManager] successBlock:successBlock errorBlock:errorBlock];
}

// Endpoint : { Historical }
// Params : {
//    "access_key" : "YOUR_ACCESS_KEY"
//    "date" : "YYYY-MM-DD"
//    "source" : "EUR"
//    "currencies" : "USD,AUD,CAD,PLN,MXN"
//    "format" : 1
// }
- (void)historicalRatesForSource:(NSString *)sourceCurrency
                  withCurrencies:(NSArray *)currencies
                          atDate:(NSDate *)date
                    successBlock:(HBTAPIClientSuccessBlock)successBlock
                      errorBlock:(HBTAPIClientErrorBlock)errorBlock {
    NSMutableDictionary *params = [self commonParametersDictionary];
    
    params[sourceParameterName] = sourceCurrency;
    params[currenciesParameterName] = [currencies componentsJoinedByString:@","];
    params[dateParameterName] = [self stringFromDate:date];
    
    [self commonHttpOperationWithType:HTTPOperationTypeGET withPath:historicalEndpointName withParameters:params authorized:NO apiManager:[self apilayerManager] successBlock:successBlock errorBlock:errorBlock];
}

// http://jsonrates.com/currencies.json
// Endpoint : { currencies.json }
// Params : {}
// https://currencylayer.com/downloads/cl-currencies-table.txt
// doesn't work well
// however:
// pbpaste | perl -lne '/<td>/ && s/>(.+)<// && print $1' | ruby -e 'require "json"; print STDIN.readlines.map(&:strip).each_slice(2).reduce({}){|t, elems| t[elems[0]] = elems[1] ;t}.to_json' | pbcopy
// ok, now we have everything to complete task :3
// (shitty shit)
- (void)allCurrenciesWithSuccessBlock:(HBTAPIClientSuccessBlock)successBlock
                           errorBlock:(HBTAPIClientErrorBlock)errorBlock {
    
    [self commonHttpOperationWithType:HTTPOperationTypeGET withPath:currenciesEndpointName withParameters:nil authorized:NO apiManager:[self jsonRatesManager] successBlock:successBlock errorBlock:errorBlock];
}

@end
