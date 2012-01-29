//
//  TwitterTableCell.m
//  Scooby
//
//  Created by Ben Lamb on 01/09/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterTableCell.h"

@implementation TwitterTableCell
@synthesize created;
@synthesize fullname;
@synthesize message;
@synthesize profilePic;
@synthesize twitterTimestamp;
@synthesize username;

- (void)configureWithTweet:(Tweet *)tweet {
    message.text = tweet.message;
    profilePic.image = tweet.profile_pic;
    username.text = tweet.userId;
    fullname.text = tweet.username;
    twitterTimestamp.text = [tweet howLongAgo];
}

- (NSString *)reuseIdentifier {
	return kTwitterCellIdentifier;
}


@end
