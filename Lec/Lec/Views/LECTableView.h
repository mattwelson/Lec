//
//  LECTableView.h
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECTableViewDataSource.h"

@interface LECTableView : UIView

@property (nonatomic, assign) id<LECTableViewDataSource> dataSource;

@end
