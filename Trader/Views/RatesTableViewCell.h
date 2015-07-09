//
//  RatesTableViewCell.h
//  Trader
//
//  Created by Lobanov Dmitry on 05.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatesTableViewCell : UITableViewCell

- (void) setTrend:(NSNumber *)trend andQuote:(NSNumber *)quote;

@end
