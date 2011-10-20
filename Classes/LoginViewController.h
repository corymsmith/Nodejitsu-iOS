//
//  LoginViewController.h
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Nodejitsu.h"


@interface LoginViewController : UIViewController <NodejitsuLoginDelegate> {
	Nodejitsu *nodejitsu;
	UITextField *usernameTextField;
	UITextField *passwordTextField;
}

@end
