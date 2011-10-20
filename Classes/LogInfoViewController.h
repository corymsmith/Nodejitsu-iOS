//
//  LogInfoViewController.h
//  iNodejitsu
//
//  Created by Cory Smith on 11-09-06.
//  Copyright 2011 Leading Lines Design. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LogInfoViewController : UIViewController {
	NSDictionary *logEntry;
}
- (id)initWithLogEntry:(NSDictionary *)theLogEntry;


@end
