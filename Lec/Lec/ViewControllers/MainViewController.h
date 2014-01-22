//
//  MainViewController.h
//  Lec
//
//  Created by Juni Lee on 17/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECImportHeader.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property UITableView *courseView;
@property LECHomeViewModel *viewModel;

- (void) changeCoursePage;
@end
