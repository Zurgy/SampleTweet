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
  //  NSTimeInterval howLong = [now timeIntervalSinceDate:self.created];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *breakdownInfo = [gregorian components:unitFlags fromDate:self.created toDate:now  options:0];
    
   // NSLog(@"Break down: %dmin %dhours %ddays %dmoths",[breakdownInfo minute], [breakdownInfo hour], [breakdownInfo day], [breakdownInfo month]);
    
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
