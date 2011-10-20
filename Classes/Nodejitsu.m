//
//  Nodejitsu.m
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import "Nodejitsu.h"
#import "ASIHTTPRequest.h"
#import "KeychainItemWrapper.h"

@implementation Nodejitsu
@synthesize delegate, loginDelegate;

- (id)init {
    self = [super init];
    if (self != nil) {
        apps = [[NSArray array] retain];
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
        _username = [[keychain objectForKey:(id) kSecAttrAccount] retain];
        _password = [[keychain objectForKey:(id) kSecValueData] retain];
        [keychain release];
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    _username = [username retain];
    _password = [password retain];
    NSString *urlString = [NSString stringWithFormat:@"http://api.nodejitsu.com/apps/%@", _username];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:_username];
    [request setPassword:_password];
    DLog(@"%@/%@", _username, _password);
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(loginFinished:)];
    [request setDidFailSelector:@selector(loginFailed:)];
    [request startAsynchronous];
}

- (void)loginFinished:(ASIHTTPRequest *)request {
    DLog(@"");
    NSDictionary *dict = [[request responseString] JSONValue];
    DLog(@"%@", [dict description]);
    DLog(@"%d", request.responseStatusCode);
    DLog(@"%@", [[request error] description]);
    DLog(@"%@", [request responseString]);
    DLog(@"%@", [[request url] description]);
    DLog(@"%@/%@", _username, _password);
    if (request.responseStatusCode == 200) {
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
        [keychain setObject:_username forKey:(id) kSecAttrAccount];
        [keychain setObject:_password forKey:(id) kSecValueData];
        [keychain release];
        [loginDelegate loginSucceeded];
    }
    else {
        [loginDelegate loginFailed:[dict valueForKey:@"error"]];
    }
}

- (BOOL)isAuthenticated {
    return _username != nil && _password != nil;
}

- (void)loginFailed:(ASIHTTPRequest *)request {
    DLog(@"%d", request.responseStatusCode);
    DLog(@"%@", [[request error] description]);
    DLog(@"%@", [request responseString]);

    [loginDelegate loginFailed:@"Please double check your username / password"];
}

- (void)getApplications {
    DLog(@"%@/%@", _username, _password);
    NSString *urlString = [NSString stringWithFormat:@"http://api.nodejitsu.com/apps/%@", _username];

    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:_username];
    [request setPassword:_password];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getApplicationsFinished:)];
    [request setDidFailSelector:@selector(getApplicationsFailed:)];
    [request startAsynchronous];
}

- (void)getApplicationsFinished:(ASIHTTPRequest *)request {
    DLog(@"%@", [[request url] description]);
    DLog(@"%d", request.responseStatusCode);
    DLog(@"%@", [[request error] description]);
    DLog(@"%@", [request responseString]);
    NSDictionary *dict = [[request responseString] JSONValue];
    DLog(@"%@", [dict description]);
    [apps release];
    apps = [[dict objectForKey:@"apps"] retain];

    for (NSDictionary *dict in apps) {
        NSString *notificationName = [NSString stringWithFormat:@"APP_UPDATED_%@", [dict valueForKey:@"id"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:dict];
    }

    [delegate loadedApplications];
}

- (NSArray *)allApplications {
    return apps;
}

- (void)getApplicationsFailed:(ASIHTTPRequest *)request {
    DLog(@"%d", request.responseStatusCode);
}

- (void)getLogsForApplication:(NSString *)appId {
    DLog(@"");
    NSString *urlString = [NSString stringWithFormat:@"http://api.nodejitsu.com/logs/%@/%@/", _username, appId];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setUsername:_username];
    [request setPassword:_password];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getLogsForApplicationFinished:)];
    [request setDidFailSelector:@selector(getLogsForApplicationFailed:)];
    [request startAsynchronous];
}

- (void)getLogsForApplicationFinished:(ASIHTTPRequest *)request {
    DLog(@"");
    NSArray *array = [[request responseString] JSONValue];
    [delegate loadedLogsForApplication:array];
    DLog(@"%@", [array description]);
}

- (void)getLogsForApplicationFailed:(ASIHTTPRequest *)request {
    DLog(@"%d", request.responseStatusCode);
}

//Start an Application
//POST /apps/:user-id/:app-id/start
- (void)startApplication:(NSString *)appId {
    NSString *urlString = [NSString stringWithFormat:@"http://api.nodejitsu.com/apps/%@/%@/start", _username, appId];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setRequestMethod:@"POST"];
    [request setUsername:_username];
    [request setPassword:_password];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(startApplicationFinished:)];
    [request setDidFailSelector:@selector(startApplicationFailed:)];
    [request startAsynchronous];
}

- (void)startApplicationFinished:(ASIHTTPRequest *)request {
    DLog(@"%@", [request responseString]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadApplications" object:nil];
}

- (void)startApplicationFailed:(ASIHTTPRequest *)request {
    DLog(@"%d", request.responseStatusCode);
    DLog(@"%@", [[request error] description]);
    DLog(@"%@", [request responseString]);
}

//Stop an Application
//POST /apps/:user-id/:app-id/stop
- (void)stopApplication:(NSString *)appId {
    NSString *urlString = [NSString stringWithFormat:@"http://api.nodejitsu.com/apps/%@/%@/stop", _username, appId];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setRequestMethod:@"POST"];
    [request setUsername:_username];
    [request setPassword:_password];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(stopApplicationFinished:)];
    [request setDidFailSelector:@selector(stopApplicationFailed:)];
    [request startAsynchronous];
}

- (void)stopApplicationFinished:(ASIHTTPRequest *)request {
    DLog(@"%@", [request responseString]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadApplications" object:nil];
}

- (void)stopApplicationFailed:(ASIHTTPRequest *)request {
    DLog(@"%d", request.responseStatusCode);
    DLog(@"%@", [request responseString]);
}

//Restart an Application
//POST /apps/:user-id/:app-id/restart
- (void)restartApplication:(NSString *)appId {
    NSString *urlString = [NSString stringWithFormat:@"http://api.nodejitsu.com/apps/%@/%@/restart", _username, appId];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:15];
    [request setRequestMethod:@"POST"];
    [request setUsername:_username];
    [request setPassword:_password];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(restartApplicationFinished:)];
    [request setDidFailSelector:@selector(restartApplicationFailed:)];
    [request startAsynchronous];
}

- (void)restartApplicationFinished:(ASIHTTPRequest *)request {
    DLog(@"%@", [request responseString]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadApplications" object:nil];
}

- (void)restartApplicationFailed:(ASIHTTPRequest *)request {
    DLog(@"%d", request.responseStatusCode);
    DLog(@"%@", [request responseString]);
}

- (void)dealloc {
    if (_username)
        [_username release];
    if (_password)
        [_password release];
    [apps release];
    [super dealloc];
}

@end
