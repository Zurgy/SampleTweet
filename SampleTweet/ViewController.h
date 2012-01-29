//
//  ViewController.h
//  SampleTweet
//
//  Created by Ben Lamb on 25/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterManager.h"
#import "TwitterTableCell.h"

@interface ViewController : UIViewController <TwitterManagerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray *tweets;
    TwitterManager *twitterManager;
}

@property (nonatomic, retain) IBOutlet UITableView *tweetTable;

@end
