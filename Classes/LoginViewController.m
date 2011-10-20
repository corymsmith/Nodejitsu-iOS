    //
//  LoginViewController.m
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController

- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationController.navigationBar.tintColor = [UIColor grayColor];
	UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-type-white.png"]];
	[logo setFrame:CGRectMake(0,0,119,25)];
	self.navigationItem.titleView = logo;
	[logo release];
	
	usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20,25,280,40)];
	usernameTextField.placeholder = @"username";
	usernameTextField.font = [UIFont systemFontOfSize:26];
	usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:usernameTextField];

	passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20,80,280,40)];
	passwordTextField.placeholder = @"password";
	passwordTextField.font = [UIFont systemFontOfSize:26];
	passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
	passwordTextField.returnKeyType = UIReturnKeyGo;
	passwordTextField.secureTextEntry = YES;
	[self.view addSubview:passwordTextField];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login"
																			   style:UIBarButtonItemStyleBordered
																			  target:self 
																			  action:@selector(login)] autorelease];
	nodejitsu = [[Nodejitsu alloc] init];
	nodejitsu.loginDelegate = self;
}

- (void)login {
	[nodejitsu loginWithUsername:[usernameTextField.text lowercaseString] password:passwordTextField.text];
}

- (void)loginSucceeded {
	DLog(@"");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadApplications" object:nil];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)loginFailed:(NSString *)message {
	DLog(@"%@", message);
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[alertView show];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [nodejitsu release];
    [usernameTextField release];
    [passwordTextField release];
    [super dealloc];
}


@end
