//
//  PullupTableViewController.h
//  Lec
//
//  Created by Matt Welson on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
// The controller for our custom header table view!

#import <UIKit/UIKit.h>
#import "LECPullDownReminder.h"

@class LECHeaderView;
@class LECPlaybackControls;
@class LECActionBar;

@interface PullupTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // Should be over ridden by children
    NSInteger contentSection;
    NSInteger actionSection;
    LECActionBar *actionBar;
    LECPlaybackControls *playbackBar;
    BOOL hasFooter;
    BOOL isRecordingScreen;
    BOOL isPlaybackScreen;
    NSInteger noSections;
    NSArray *visibleCells;
    int loadedCells;
    NSIndexPath *deleteIndexPath;
    LECPullDownReminder *reminderView;
}

@property UITableView *tableView;
@property  LECHeaderView *headerView;

-(void) deleteObjectFromViewModel:(NSInteger)index;

-(void) courseTableViewSetup;
-(void) navigationTopBar;

@end
