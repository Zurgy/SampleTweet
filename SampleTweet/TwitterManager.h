//
//  TwitterManager.h
//  Scooby
//
//  Created by Ben Lamb on 31/08/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIDownloadCache.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "Tweet.h"

@protocol TwitterManagerDelegate

- (void)tweetsAvailable:(NSArray *)tweets;
- (void)twitterProfilePicAvailable:(NSString *)profilePicURL image:(UIImage *)profilePic;

@optional

- (void)errorRetrievingTweets;

@end

@interface TwitterManager : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic, retain) id<TwitterManagerDelegate> delegate;
@property (nonatomic, retain) NSOperationQueue *profilePicQueue;

- (void)getTweetsForUser:(NSString *)twitterId count:(NSInteger)count;
- (void)getProfilePicForTweet:(Tweet *)tweet;
//- (void)getTwitterProfilePic:(NSString *)profilePicURL;
- (id)initWithDelegate:(id<TwitterManagerDelegate>)delegate;
- (void)profilePicLoaded:(ASIHTTPRequest *)request;
- (void)returnDummyTweets;
@end
