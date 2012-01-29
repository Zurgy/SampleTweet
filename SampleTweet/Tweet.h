//
//  Tweet.h
//  Scooby
//
//  Created by Ben Lamb on 31/08/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) UIImage *profile_pic;
@property (nonatomic, retain) NSString *profile_pic_url;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *username;

- (NSString *)howLongAgo;
@end
