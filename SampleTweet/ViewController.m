//
//  ViewController.m
//  SampleTweet
//
//  Created by Ben Lamb on 25/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize tweetTable;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Noddy cache to store profile pics
    twitterProfilePics = [[NSMutableDictionary alloc] init];
    
    // Load some tweets.
    twitterManager = [[TwitterManager alloc] initWithDelegate:self];
    [twitterManager getTweetsForUser:@"O2" count:20];
}

- (void)viewDidUnload
{
    // In this example the view is not going to be unloaded but good practise
    // dictated you'd want to clear any references to the view when it gets
    // unloaded.
    twitterManager.delegate = nil;
    [super viewDidUnload];
}

#pragma mark - UISearchBarDelegate

/*** Load tweets for whatever Twitter ID was typed into the searchbar. */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [twitterManager getTweetsForUser:searchBar.text count:20];
}

#pragma mark - UITableViewDataSource

/*** There's only one section in our table. */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*** How many tweets are there to display? */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tweets count];
}

/*** Return one of our custom TwitterTableCells and configure it to display the contents
 of the tweet.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kTwitterCellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TwitterTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Tweet *tweet = [tweets objectAtIndex:[indexPath row]];
    [cell configureWithTweet:tweet];
    cell.profilePic.image = [self getTwitterProfilePic:tweet];
    return cell;
}

#pragma mark - UITableViewDelegate

/*** Return a custom height for the table cells. We know TwitterTableCell is 113 pixels so
 hard-code this value. */
/* For reasons I've never understood this method is part of UITableViewDelegate. */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  { 
    return 113.0;            
}

#pragma mark - TwitterManagerDelegate

/*** When new tweets are loaded refresh the entire table. */
- (void)tweetsAvailable:(NSArray *)latestTweets {
    tweets = latestTweets;
    [tweetTable reloadData];
}

- (void)twitterProfilePicAvailable:(NSString *)profilePicURL image:(UIImage *)profilePic {
    [twitterProfilePics setObject:profilePic forKey:profilePicURL];
    for (Tweet *tweet in tweets) {
        if ([tweet.profile_pic_url compare:profilePicURL] == NSOrderedSame) {
            NSUInteger tweetIndex = [tweets indexOfObject:tweet];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tweetIndex inSection:0];
            NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];
            [tweetTable reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
     }
}


- (UIImage *)getTwitterProfilePic:(Tweet *)tweet {
    UIImage *profilePic = [twitterProfilePics objectForKey:tweet.profile_pic_url];
    if (profilePic == nil) {
        [twitterManager getProfilePicForTweet:tweet];
    }
    return profilePic;
}

@end
