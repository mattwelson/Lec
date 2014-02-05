//
//  PullupTableViewController.h
//  Lec
//
//  Created by Matt Welson on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
// The controller for our custom header table view!

#import <UIKit/UIKit.h>
@class LECHeaderView;

@interface PullupTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property UITableView *tableView;
@property  LECHeaderView *headerView;

-(void) deleteObjectFromViewModel:(NSInteger)index;

-(void) courseTableViewSetup;
-(void) navigationTopBar;

@end
