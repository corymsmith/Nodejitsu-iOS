//
//  AppDetailViewController.m
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import "AppDetailViewController.h"
#import "LogsListViewController.h"

@interface AppDetailViewController ()
- (void)updateView;

@end

@implementation AppDetailViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithApp:(NSDictionary *)theApp {
    self = [super init];
    if (self) {
        // Custom initialization.
        app = [theApp retain];
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];

    NSString *notificationName = [NSString stringWithFormat:@"APP_UPDATED_%@", [app valueForKey:@"id"]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadedApp:)
                                                 name:notificationName
                                               object:nil];


    appTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    appTableView.backgroundColor = [UIColor whiteColor];
    appTableView.delegate = self;
    appTableView.dataSource = self;
    [self.view addSubview:appTableView];

    nodejitsu = [[Nodejitsu alloc] init];
    nodejitsu.delegate = self;
    [self updateView];
}

- (void)updateView {
    self.title = [app valueForKey:@"name"];
    [appTableView reloadData];
}

- (void)reloadedApp:(NSNotification *)notification {
    [app release];
    app = [notification.userInfo retain];
    //DLog(@"%@", [notification.userInfo description]);
    [self updateView];
}

- (void)toggleState {
    // Only show the stop and restart buttons when started
    if ([[app valueForKey:@"state"] isEqualToString:@"started"]) {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Change State?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Stop", @"Restart", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
        [popupQuery release];
    }
    else {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Change State?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Start", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
        [popupQuery release];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL showSpinner = NO;
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    UITableViewCell *theCell = [appTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    if ([buttonTitle isEqualToString:@"Start"]) {
        theCell.textLabel.text = @"starting...";
        showSpinner = YES;
        [nodejitsu startApplication:[app valueForKey:@"id"]];
    } else if ([buttonTitle isEqualToString:@"Stop"]) {
        theCell.textLabel.text = @"stopping...";
        showSpinner = YES;
        [nodejitsu stopApplication:[app valueForKey:@"id"]];
    } else if ([buttonTitle isEqualToString:@"Restart"]) {
        theCell.textLabel.text = @"restarting...";
        showSpinner = YES;
        [nodejitsu restartApplication:[app valueForKey:@"id"]];
    } else if ([buttonTitle isEqualToString:@"Delete"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Application"
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete '%@'?", [app valueForKey:@"name"]]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes, delete it!", nil];
        [alert show];
        [alert release];
    }

    if (showSpinner) {
        theCell.accessoryView = nil;
        theCell.textLabel.textColor = [UIColor grayColor];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setFrame:CGRectMake(280, 12, 20, 20)];
        [spinner startAnimating];
        [spinner setHidesWhenStopped:YES];
        [spinner setTag:1345];
        [theCell addSubview:spinner];
        [spinner release];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        // Delete the application
        DLog(@"Cancel");
    }
    else {
        NSLog(@"Delete");
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    if ([cell viewWithTag:1345])
        [[cell viewWithTag:1345] removeFromSuperview];

    NSString *imageName = @"app-off.png";
    if ([[app valueForKey:@"state"] isEqualToString:@"started"])
        imageName = @"app-on.png";

    if (indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = [app valueForKey:@"state"];
        [cell setAccessoryView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if (indexPath.row == 1) {

        cell.textLabel.text = @"Logs";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self toggleState];
    }
    if (indexPath.row == 1) {
        LogsListViewController *logsViewController = [[LogsListViewController alloc] initWithApp:app];
        [self.navigationController pushViewController:logsViewController animated:YES];
        [logsViewController release];
    }
    [appTableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [app release];
    [appTableView release];
    [nodejitsu release];
    [super dealloc];
}


@end
