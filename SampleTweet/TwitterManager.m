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

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?id=%@", twitterId]];
   
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://search.twitter.com/search.json?q=@%@&result_type=mixed&count=%d", twitterId, count]];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request startAsynchronous];
}


/*** This is sub-optimal. When the initial table cells are displayed, in the example the tweets
 are all for the same user and therefore have the same profile pic. This causes several network
 requests to be made for the same resource. When at least one has been downloaded it is cached
 and when further tweets are displayed the no further network requests are made.
 */
- (void)getProfilePicForTweet:(Tweet *)tweet {
    // These are handled on a separate queue so they can be cancelled if the user
    // moves to another view
    if (profilePicQueue == nil) {
        self.profilePicQueue = [[NSOperationQueue alloc] init];
    }
    
//    NSLog(@"Downloading profile pic: %@", tweet.profile_pic_url);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tweet.profile_pic_url]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCompletionBlock:^{
        if (![request didUseCachedResponse]) {
            NSLog(@"Loaded pic from network.");
        }
        UIImage *profilePic = [UIImage imageWithData:[request responseData]];
        tweet.profile_pic = profilePic;
        [delegate twitterProfilePicAvailable:tweet.profile_pic_url image:profilePic];
    }];
    [request setQueue:profilePicQueue];
    [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *dataFromServer = [request responseData];
    NSArray *results = [NSJSONSerialization JSONObjectWithData:dataFromServer options:0 error:nil];
    
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:[results count]];
    for (NSDictionary *result in results) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        Tweet *tweet = [[Tweet alloc] init];
        tweet.created = [dateFormatter dateFromString:[result objectForKey:@"created_at"]];
        tweet.message = [result objectForKey:@"text"];
        NSDictionary *userDetails = [result objectForKey:@"user"];
        tweet.profile_pic_url = [userDetails objectForKey:@"profile_image_url"];
        tweet.userId = [userDetails objectForKey:@"screen_name"];
        tweet.username = [userDetails objectForKey:@"name"];
        [self getProfilePicForTweet:tweet];
        
        [tweets addObject:tweet];
    }
    
    [delegate tweetsAvailable:tweets];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    // Should add a method to TwitterManagerDelegate to allow errors to be reported
    // back to the caller.
}
@end
