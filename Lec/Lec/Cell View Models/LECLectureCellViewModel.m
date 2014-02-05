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
    // set accessory and has recorded!
    cellViewModel.hasRecording = [[lecture recordingPath] length] > 0;
    cellViewModel.colourString = [[lecture course] colour];
    [cellViewModel accessoryForCell];
    return cellViewModel;
}

-(void) accessoryForCell {
    UIImage *image;
    if (!self.hasRecording) {
        image = [UIImage imageNamed:@"icon_mic"];
    }
    self.accessory = image;
}

@end
