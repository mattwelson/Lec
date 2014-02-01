//
//  LECCourseHeaderView.h
//  Lec
//
//  Created by Julin Le-Ngoc on 29/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECImportHeader.h"

@interface LECHeaderView : UIView

- (id)initWithCourse:(LECCourseViewModel *)course;
- (id)initWithLecture:(LECLectureViewModel *)lecture;

-(void)changeAlpha:(CGFloat) tableOffset;

@end
