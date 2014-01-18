//
//  LECDummyCourse.m
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECDummyCourse.h"

@implementation LECDummyCourse


+(LECDummyCourse *)dummyCourse:(NSString *)title
{
    LECDummyCourse *dummy = [[LECDummyCourse alloc] init];
    
    [dummy setCourseDescription:@"Hello this is descriptive"];
    [dummy setCourseName:title];
    [dummy setColour:@"Red"];
    
    return dummy;
}

@end
