//
//  TwitterManager.m
//  Scooby
//
//  Created by Ben Lamb on 31/08/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterManager.h"

@implementation TwitterManager
@synthesize delegate;
@synthesize profilePicQueue;

- (id)initWithDelegate:(id<TwitterManagerDelegate>)aDelegate {
    self = [super init];
    if (self) {
        NSAssert(aDelegate != nil, @"Delegate is required");
        self.delegate = aDelegate;
    }
    return self;
}

- (void)getTweetsForUser:(NSString *)twitterId count:(NSInteger)count {
    NSAssert(twitterId != nil, @"twitterId must not be nil");
    
    NSLog(@"Retrieving tweets for user: %@", twitterId);
//    [self performSelector:@selector(returnDummyTweets) withObject:nil afterDelay:8];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?id=%@", twitterId]];

   
  //  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://search.twitter.com/search.json?q=@%@&result_type=mixed&count=%d", twitterId, count]];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request startAsynchronous];
}


- (void)getProfilePicForTweet:(Tweet *)tweet {

//- (void)getTwitterProfilePic:(NSString *)profilePicURL {
    // These are handled on a separate queue so they can be cancelled if the user
    // moves to another view
    if (profilePicQueue == nil) {
        self.profilePicQueue = [[NSOperationQueue alloc] init];
    }
    
    //NSLog(@"Downloading profile pic: %@", tweet.profile_pic_url);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tweet.profile_pic_url]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCompletionBlock:^{
        UIImage *profilePic = [UIImage imageWithData:[request responseData]];
        tweet.profile_pic = profilePic;
    }];
    [request setQueue:profilePicQueue];
    [request startAsynchronous];
    
}

- (void)returnDummyTweets {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:3];
    Tweet *tweet1 = [[Tweet alloc] init];
    Tweet *tweet2 = [[Tweet alloc] init];
    Tweet *tweet3 = [[Tweet alloc] init];
    tweet1.message = @"Hello world. The quick brown fox jumped over the lazy dog.";
    tweet2.message = @"Hello world. The quick brown fox jumped over the lazy dog.";
    tweet3.message = @"Hello world. The quick brown fox jumped over the lazy dog.";
    [tweets addObject:tweet1];
    [tweets addObject:tweet2];
    [tweets addObject:tweet3];
    [delegate tweetsAvailable:tweets];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)profilePicLoaded:(ASIHTTPRequest *)request {
   // UIImage *profilePic = [UIImage imageWithData:[request responseData]];
   // NSString *foo = [NSString stringWithContentsOfURL:[request url]];
   // NSLog(@"Profile Pic: %@", foo);
    //[delegate twitterProfilePicAvailable:foo image:profilePic];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    //NSLog(@"Got response from Twitter");
    NSData *dataFromServer = [request responseData];

    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSArray *results = [jsonParser objectWithData:dataFromServer];
    
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:[results count]];
    for (NSDictionary *result in results) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        Tweet *tweet = [[Tweet alloc] init];
        tweet.created = [dateFormatter dateFromString:[result objectForKey:@"created_at"]];
        tweet.message = [result objectForKey:@"text"];
        tweet.profile_pic_url = [result objectForKey:@"profile_image_url"];
        tweet.userId = [result objectForKey:@"from_user"];
        tweet.username = [result objectForKey:@"from_user_name"];
        [self getProfilePicForTweet:tweet];
        
        [tweets addObject:tweet];
    }
    
    [delegate tweetsAvailable:tweets];
}

- (void)requestFailed:(ASIHTTPRequest *)request {

}
@end
