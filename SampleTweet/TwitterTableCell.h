//
//  TwitterTableCell.h
//  Scooby
//
//  Created by Ben Lamb on 01/09/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

#define kTwitterCellIdentifier @"TweetCell"

@interface TwitterTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *created;
@property (nonatomic, retain) IBOutlet UILabel *fullname;
@property (nonatomic, retain) IBOutlet UILabel *username;
@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) IBOutlet UIImageView *profilePic;
@property (nonatomic, retain) IBOutlet UILabel *twitterTimestamp;

- (void)configureWithTweet:(Tweet *)tweet;
@end
