//
//  iNodejitsuAppDelegate.h
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppsViewController.h" 

@interface iNodejitsuAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	AppsViewController *appsList;
	UINavigationController *appsNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

