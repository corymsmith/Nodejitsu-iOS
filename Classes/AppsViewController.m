//
//  AppsViewController.m
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-02.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import "AppsViewController.h"
#import "AppDetailViewController.h"

@interface AppsViewController ()
- (void)logout;

@end

@implementation AppsViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self
                                                                              action:@selector(promptForLogout)] autorelease];

    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-type-white.png"]];
    [logo setFrame:CGRectMake(0, 0, 119, 25)];
    self.navigationItem.titleView = logo;
    [logo release];

    appsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    appsTableView.delegate = self;
    appsTableView.dataSource = self;
    [self.view addSubview:appsTableView];

    nodejitsu = [[Nodejitsu alloc] init];
    nodejitsu.delegate = self;


    [[NSNotificationCenter defaultCenter] addObserver:nodejitsu
                                             selector:@selector(getApplications)
                                                 name:@"ReloadApplications"
                                               object:nil];
    if ([nodejitsu isAuthenticated])
        [nodejitsu getApplications];
}

- (void)promptForLogout {
    // Only show the stop and restart buttons when started

        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to logout?"
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:@"Logout"
                                                       otherButtonTitles:nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
        [popupQuery release];

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self logout];
    } else {
        DLog(@"");
    }

//    if (showSpinner) {
//        theCell.accessoryView = nil;
//        theCell.textLabel.textColor = [UIColor grayColor];
//        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [spinner setFrame:CGRectMake(280, 12, 20, 20)];
//        [spinner startAnimating];
//        [spinner setHidesWhenStopped:YES];
//        [spinner setTag:1345];
//        [theCell addSubview:spinner];
//        [spinner release];
//    }
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


- (void)logout {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
}

- (void)reloadApplications {
    [nodejitsu getApplications];
}

- (void)loadedApplications {
    [appsTableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[nodejitsu allApplications] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    NSString *state = [[[nodejitsu allApplications] objectAtIndex:indexPath.row] valueForKey:@"state"];
    NSDecimalNumber *ctime = [[[[nodejitsu allApplications] objectAtIndex:indexPath.row] objectForKey:@"active"] objectForKey:@"ctime"];
    NSString *version = [[[nodejitsu allApplications] objectAtIndex:indexPath.row] valueForKey:@"version"];

    unsigned long long seconds = [ctime unsignedLongLongValue] / 1000;
    DLog(@"%llu", seconds);

    NSDate *newDate2 = [NSDate dateWithTimeIntervalSince1970:seconds];
    DLog(@"newDate2: %@", [newDate2 description]);

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 25)];
    titleLabel.contentMode = UIViewContentModeTop;
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.tag = 1111;
    titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[[nodejitsu allApplications] objectAtIndex:indexPath.row] valueForKey:@"name"], version];
    [cell addSubview:titleLabel];
    [titleLabel release];

    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 240, 15)];
    dateLabel.textColor = [UIColor darkGrayColor];
    dateLabel.textAlignment = UITextAlignmentLeft;
    dateLabel.numberOfLines = 1;
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.tag = 2222;
    dateLabel.text = [NSString stringWithFormat:@"Deployed: %@", [newDate2 description]];
    [cell addSubview:dateLabel];
    [dateLabel release];

    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 45, 190, 15)];
    dateLabel.textColor = [UIColor darkGrayColor];
    dateLabel.textAlignment = UITextAlignmentRight;
    dateLabel.numberOfLines = 1;
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.tag = 2222;
    [dateLabel release];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-2, 17, 32, 32)];
    if ([state isEqualToString:@"started"])
        [imageView setImage:[UIImage imageNamed:@"app-on.png"]];
    else {
        [imageView setImage:[UIImage imageNamed:@"app-off.png"]];
    }
    [cell addSubview:imageView];
    [imageView release];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *appDictionary = [[nodejitsu allApplications] objectAtIndex:indexPath.row];
    AppDetailViewController *appDetail = [[AppDetailViewController alloc] initWithApp:appDictionary];
    [self.navigationController pushViewController:appDetail animated:YES];
    [appsTableView deselectRowAtIndexPath:indexPath animated:YES];
    [appDetail release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0f;
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
    [appsTableView release];
    [super dealloc];
}


@end
