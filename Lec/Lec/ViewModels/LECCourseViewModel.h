//
//  LECCourseViewModel.h
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECBaseViewModel.h"

@interface LECCourseViewModel : LECBaseViewModel

@property Course *currentCourse;

@property NSString *icon; // the image that represents the course
@property unsigned long i; //the Lecture Number


-(instancetype)initWithCourse:(Course *) course;
-(void)deleteLectureAtIndex:(NSInteger)index;
-(void)addLecture:(NSString *)name withLectureNumber:(NSInteger)number;

@end
