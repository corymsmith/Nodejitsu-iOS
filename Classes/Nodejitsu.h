//
//  Nodejitsu.h
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NodejitsuDelegate

@optional
- (void)loadedApplications;
- (void)loadedLogsForApplication:(NSDictionary *)logsDictionary;

@end

@protocol NodejitsuLoginDelegate

@optional
- (void)loginSucceeded;
- (void)loginFailed:(NSString *)message;

@end


@interface Nodejitsu : NSObject {
	id <NodejitsuDelegate> delegate;
	id <NodejitsuLoginDelegate> loginDelegate;
	
	NSArray *apps;
	NSString *_username;
	NSString *_password;
}

@property (assign) id <NodejitsuDelegate> delegate;
@property (assign) id <NodejitsuLoginDelegate> loginDelegate;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password;

- (void)startApplication:(NSString *)appId;

- (void)stopApplication:(NSString *)appId;

- (void)restartApplication:(NSString *)appId;

- (BOOL)isAuthenticated;

- (void)getApplications;

- (NSArray *)allApplications;

- (void)getLogsForApplication:(NSString *)appId;


@end
