    //
//  LogsListViewController.m
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-04.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import "LogsListViewController.h"
#import "LogInfoViewController.h"

@implementation LogsListViewController

- (id)initWithApp:(NSDictionary *)theApp {
    self = [super init];
    if (self) {
			// Custom initialization.
		app = [theApp retain];
		logs = [[NSDictionary dictionary] retain];
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.title = @"Logs";
	logsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	logsTableView.delegate = self;
	logsTableView.dataSource = self;
	[self.view addSubview:logsTableView];
	
	nodejitsu = [[Nodejitsu alloc] init];
	nodejitsu.delegate = self;
	[nodejitsu getLogsForApplication:[app valueForKey:@"id"]];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																												 target:self 
																												 action:@selector(refresh)] autorelease];
}

- (void)loadedLogsForApplication:(NSDictionary *)logsDictionary  {
	[logs release];
	logs = [logsDictionary retain];
	[logsTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [[logs objectForKey:@"data"] count];
}


	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

	NSString *level = [[[[logs objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"json"] valueForKey:@"level"]; 
	NSString *description = [[[[logs objectForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"json"] valueForKey:@"desc"];
	
	cell.textLabel.text = description;
	cell.detailTextLabel.text = level;
		
	if([level isEqualToString:@"error"])
		cell.detailTextLabel.textColor = [UIColor redColor];
	else {
		cell.detailTextLabel.textColor = [UIColor grayColor];
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
	NSDictionary *logEntry = [[logs objectForKey:@"data"] objectAtIndex:indexPath.row];
	LogInfoViewController *logInfoViewController = [[LogInfoViewController alloc] initWithLogEntry:logEntry];
	[logsTableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController pushViewController:logInfoViewController animated:YES];
    [logInfoViewController release];
}

- (void)refresh {
	[nodejitsu getLogsForApplication:[app valueForKey:@"id"]];
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
    [logs release];
    [logsTableView release];
    [nodejitsu release];
    [super dealloc];
}


@end
