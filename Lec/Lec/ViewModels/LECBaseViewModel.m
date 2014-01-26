//
//  LECBaseViewModel.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECBaseViewModel.h"

@implementation LECBaseViewModel

-(instancetype)init
{
    self= [super init];
    if(self)
    {
        [self setTableData:[NSMutableArray array]]; // allocs an empty array to hold cellviewmodels!
    }
    return self;
}

@end
