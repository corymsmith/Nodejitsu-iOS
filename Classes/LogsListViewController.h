//
//  LogsListViewController.h
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-04.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LogsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NodejitsuDelegate> {
	NSDictionary *app;
	NSDictionary *logs;
	Nodejitsu *nodejitsu;
	UITableView *logsTableView;
}
- (id)initWithApp:(NSDictionary *)theApp;


@end
