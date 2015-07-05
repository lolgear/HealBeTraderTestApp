//
//  CurrenciesBackProtocol.h
//  Trader
//
//  Created by Lobanov Dmitry on 05.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CurrenciesBackProtocol <NSObject>

- (void) setCurrencyCode:(NSString *)code forDesination:(NSString *)destination;

@end
