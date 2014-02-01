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

- (id)initWithFrame:(CGRect)frame course:(LECCourseViewModel *)course;
- (id)initWithFrame:(CGRect)frame lecture:(LECLectureViewModel *)lecture;

-(void)changeAlpha:(CGFloat) tableOffset;

@end
