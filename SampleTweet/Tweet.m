//
//  Tweet.m
//  Scooby
//
//  Created by Ben Lamb on 31/08/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet
@synthesize created;
@synthesize message;
@synthesize profile_pic;
@synthesize profile_pic_url;
@synthesize userId;
@synthesize username;

- (NSString *)howLongAgo {
    NSDate *now = [NSDate date];

    // Most Twitter users tweet regularly so it's rare that the most recent tweets will be more
    // than a couple of weeks old. Therefore I don't bother breaking out the number of months
    // or years. Instead the age of anything older than a day is reported in days.
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit;    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *breakdownInfo = [gregorian components:unitFlags fromDate:self.created toDate:now  options:0];
    
   // NSLog(@"Breakdown: %dmin %dhours %ddays %dmoths",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]);
    
    if ([breakdownInfo day] > 1) {
        return [NSString stringWithFormat:@"%d days ago", [breakdownInfo day]];
        
    } else if ([breakdownInfo day] == 1) {
        return @"1 day ago";
    } else if ([breakdownInfo hour] == 0) {
        return [NSString stringWithFormat:@"%d minutes ago", [breakdownInfo minute]];
    } else {
        return [NSString stringWithFormat:@"%d hours %d minutes ago", [breakdownInfo hour], [breakdownInfo minute]];
    }
}

@end
