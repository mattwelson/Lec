//
//  CourseViewController.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECImportHeader.h"
#import "LECPreRecordScreen.h"
#import "PullupTableViewController.h"

@interface CourseViewController : PullupTableViewController<UITextFieldDelegate, PreRecordDelegate>

@property UITableView *tableView;

- (id)initWithCourse:(Course *)course;

@end
