//
//  MainViewController.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseViewController.h"
#import "CourseCell.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property UITableView *courseView;

- (void) changeCoursePage;
@end
