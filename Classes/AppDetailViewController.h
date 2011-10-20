//
//  AppDetailViewController.h
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NodejitsuDelegate, UIActionSheetDelegate> {
	NSDictionary *app;
	Nodejitsu *nodejitsu;
	UITableView *appTableView;
}
- (id)initWithApp:(NSDictionary *)theApp;


@end
