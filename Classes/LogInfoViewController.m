    //
//  LogInfoViewController.m
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-06.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import "LogInfoViewController.h"


@implementation LogInfoViewController

- (id)initWithLogEntry:(NSDictionary *)theLogEntry {
    self = [super init];
    if (self) {
			// Custom initialization.
		logEntry = [theLogEntry retain];
		
    }
    return self;
}

- (void)loadView {
	[super loadView];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, 200, 20)];
	titleLabel.contentMode = UIViewContentModeTop;
	titleLabel.numberOfLines = 1;
	titleLabel.font = [UIFont boldSystemFontOfSize:16];
	titleLabel.tag = 1111;
	titleLabel.text = [[logEntry valueForKey:@"json"] valueForKey:@"level"];
	
	if([[[logEntry valueForKey:@"json"] valueForKey:@"level"] isEqualToString:@"error"])
		titleLabel.textColor = [UIColor redColor];
	else {
		titleLabel.textColor = [UIColor grayColor];
	}
	
	[self.view addSubview:titleLabel];
	[titleLabel release];
	
	UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 240, 15)];
	dateLabel.textColor = [UIColor darkGrayColor];
	dateLabel.textAlignment = UITextAlignmentLeft;
		//dateLabel.backgroundColor = [UIColor redColor];
	dateLabel.numberOfLines = 1;
	dateLabel.font = [UIFont systemFontOfSize:12];
	dateLabel.tag = 2222;
	dateLabel.text = [logEntry valueForKey:@"timestamp"];
	[self.view addSubview:dateLabel];
	[dateLabel release];
	
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10,50,300,400)];
	textView.text = [[logEntry valueForKey:@"json"] valueForKey:@"desc"];
	textView.font = [UIFont systemFontOfSize:16];
	textView.editable = NO;
	[self.view addSubview:textView];

	//CGRect frame = textView.frame;
	//frame.size.height = textView.contentSize.height;
		//textView.frame = frame;

    [textView release];
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
    [logEntry release];
    [super dealloc];
}


@end
