//
//  LECTableViewDataSource.h
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LECTableViewDataSource <NSObject>

// Indicates the number of rows in the table
-(NSInteger)numberOfRows;

// Obtains the cell for the given row
-(UIView *)cellForRow:(NSInteger)row;

@end
