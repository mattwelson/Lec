//
//  LECCourseHeaderView.h
//  Lec
//
//  Created by Julin Le-Ngoc on 29/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECImportHeader.h"

@interface LECCourseHeaderView : UIView

- (id)initWithFrame:(CGRect)frame course:(LECCourseViewModel *)course;

-(void)changeAlpha:(CGFloat) tableOffset;

@end
