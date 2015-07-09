//
//  RatesTableViewCell.m
//  Trader
//
//  Created by Lobanov Dmitry on 05.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "RatesTableViewCell.h"
#import "NSNumberFormatter+CustomFormatting.h"
#import "NSString+CustomFormatting.h"

@interface RatesTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *trendLabel;

@end

@implementation RatesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSAttributedString *) stringFromTrend:(NSNumber *)trend {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.decimalSeparator = @".";
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 2;
    formatter.textAttributesForNegativeValues = @{
                                                  NSForegroundColorAttributeName : [UIColor redColor]
                                                  };
    formatter.textAttributesForPositiveValues = @{NSForegroundColorAttributeName : [UIColor greenColor]
                                                  };
    formatter.textAttributesForZero = @{
                                        NSForegroundColorAttributeName : [UIColor grayColor]
                                        };
    formatter.positivePrefix = @"+";
    formatter.negativePrefix = @"-";

    return nil;
}

- (NSAttributedString *) stringFromQuote:(NSNumber *)quote {
    return nil;
}

- (void) setTrend:(NSNumber *)trend andQuote:(NSNumber *)quote {
//    if ([trend floatValue] < 0) {
//        trendColor = [UIColor redColor];
//        trendPrefix = @"-";
//    }
//    
//    if ([trend floatValue] > 0) {
//        trendColor = [UIColor greenColor];
//        trendPrefix = @"+";
//    }
//    
//    if ([trend floatValue] == 0) {
//        trendColor = [UIColor grayColor];
//        trendPrefix = @"=";
//    }
    
    NSString *trendString = [[NSNumberFormatter trendFormatter] stringFromNumber:trend];
    NSString *quoteString = [[NSNumberFormatter quoteFormatter] stringFromNumber:quote];
    
    // color if needed
    self.trendLabel.text = [NSString labelTextWithTrend:trendString andQuote:quoteString];
}

@end
