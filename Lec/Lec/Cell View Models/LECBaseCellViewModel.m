//
//  LECBaseCellViewModel.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECBaseCellViewModel.h"

@implementation LECBaseCellViewModel

// format strings to be displayed sexually
-(NSString *)formatTimeToString:(double)time
{
    if (time == 0) return @"Start of recording";
    int timeMinutes = round(time / 60);
    int timeSeconds = (int)round(time)%60;
    return [NSString stringWithFormat:@"%02d:%02d minutes", timeMinutes, timeSeconds];
}

@end
