//
//  AppsViewController.h
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppsViewController : UIViewController <NodejitsuDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
	UITableView *appsTableView;
	Nodejitsu *nodejitsu;
}

@end
