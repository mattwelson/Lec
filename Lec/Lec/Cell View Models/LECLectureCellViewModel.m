//
//  LECLectureCellViewModel.m
//  Lec
//
//  Created by Matt Welson on 26/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECLectureCellViewModel.h"
#import "Course.h"

@implementation LECLectureCellViewModel

+(instancetype)lectureCellVMWithLecture:(Lecture *)lecture
{
    LECLectureCellViewModel *cellViewModel = [[LECLectureCellViewModel alloc] init];
    
    cellViewModel.lecture = lecture;
    cellViewModel.tintColour = [[LECColourService sharedColourService] baseColourFor:[lecture.course colour]];
    cellViewModel.titleText = [NSString stringWithFormat:@"Lecture %@",lecture.lectureNumber];
    cellViewModel.subText = [lecture lectureName];
    cellViewModel.colourString = [[lecture course] colour];
    return cellViewModel;
}

@end
