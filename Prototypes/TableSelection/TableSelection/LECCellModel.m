//
//  LECCellModel.m
//  TableSelection
//
//  Created by Matt Welson on 11/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECCellModel.h"

@implementation LECCellModel

+ (LECCellModel *) cellUnselected
{
    LECCellModel *cell = [[LECCellModel alloc] init];
    [cell setSelected:NO];
    return cell;
}

@end
