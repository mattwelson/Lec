//
//  LECViewController.h
//  TableSelection
//
//  Created by Matt Welson on 11/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECCellModel.h"

@interface LECViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSArray *CellModelArray;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property UIColor *color;

@end
