//
//  LECCourseCellViewModel.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECBaseCellViewModel.h"
#import "LECImportHeader.h"

@interface LECCourseCellViewModel : LECBaseCellViewModel

@property Course *course;
@property NSString *icon;

+(LECCourseCellViewModel *) courseCellWith:(Course *)course;

@end
