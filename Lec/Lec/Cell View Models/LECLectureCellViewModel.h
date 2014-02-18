//
//  LECLectureCellViewModel.h
//  Lec
//
//  Created by Matt Welson on 26/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECBaseCellViewModel.h"
#import "Lecture.h"

@interface LECLectureCellViewModel : LECBaseCellViewModel

@property Lecture *lecture;

+(instancetype)lectureCellVMWithLecture:(Lecture *)lecture; // a view model that represents a lecture

@end
