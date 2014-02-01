//
//  LECLectureViewModel.h
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECBaseViewModel.h"

@interface LECLectureViewModel : LECBaseViewModel

+(LECLectureViewModel *)viewModelWithLecture:(Lecture *)lecture;

@property NSString *icon;
@property Lecture *lecture;
@property NSMutableArray *tags;
// instance of AVAudio

@end
