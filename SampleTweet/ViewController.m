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
    
    // Load some tweets.
    twitterManager = [[TwitterManager alloc] initWithDelegate:self];
    [twitterManager getTweetsForUser:@"O2" count:20];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - UISearchBarDelegate

/*** Load tweets for whatever Twitter ID was typed into the searchbar. */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [twitterManager getTweetsForUser:searchBar.text count:20];
}

#pragma mark - UITableViewDataSource

/*** Return a custom height for the table cells. We know TwitterTableCell is 113 pixels so
 hard-code this value. */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  { 
    return 113.0;            
}

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
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet Tapped" message:@"You tapped a tweet." delegate:nil cancelButtonTitle:@"I'm Done" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - TwitterManagerDelegate

/*** When new tweets are loaded refresh the entire table. */
- (void)tweetsAvailable:(NSArray *)latestTweets {
    tweets = latestTweets;
    [tweetTable reloadData];
}

- (void)twitterProfilePicAvailable:(NSString *)profilePicURL image:(UIImage *)profilePic {
  //  [twitterProfilePics setObject:profilePic forKey:profilePicURL];
    /*  for (Tweet *tweet in self.tweets) {
     if ([tweet.profile_image_url compare:profilePicURL] == NSOrderedSame) {
     // Refresh this cell
     //            [venueDetailsTable reload
     }
     }*/
}

@end
