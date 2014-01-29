//
//  LECCourseHeaderView.m
//  Lec
//
//  Created by Julin Le-Ngoc on 29/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECCourseHeaderView.h"

@implementation LECCourseHeaderView{
    CGRect startingFrame;
    UIImageView *subjectImg;
    UILabel *navTitle;
    UILabel *titleLabel;
    UILabel *descriptionLabel;
}

- (id)initWithFrame:(CGRect)frame course:(LECCourseViewModel *)courseModel
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        startingFrame = frame;
        [[LECColourService sharedColourService] addGradientForColour:courseModel.course.colour toView:self];
        
        subjectImg = [[LECIconService sharedIconService] addIconCourseScreen:courseModel.course.icon toView:self];
        [self addSubview:subjectImg];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.frame.size.width, 50)];
        titleLabel.text = courseModel.course.courseName;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:40];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        
        descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, self.frame.size.width, 50)];
        descriptionLabel.text = courseModel.course.courseDescription;
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.font = [UIFont fontWithName:@"Avenir-Book" size:15];
        descriptionLabel.textColor = [UIColor whiteColor];
        [self addSubview:descriptionLabel];
        
    }
    return self;
}

-(void)changeAlpha:(CGFloat) tableOffset{
    
    if (tableOffset > 0 && tableOffset < 140) {
        subjectImg.alpha = 1-(tableOffset/50); // different to be more dynamic
        titleLabel.alpha = 1-(tableOffset/75);
        descriptionLabel.alpha = 1-(tableOffset/75);
        self.frame = CGRectMake(0, 0-tableOffset/5, self.frame.size.width, 200);
        navTitle.alpha = -0.9 + (tableOffset/50);
    }
    
    else if(tableOffset == 0) {
        subjectImg.alpha = 1;
        titleLabel.alpha = 1;
        descriptionLabel.alpha = 1;
        navTitle.alpha = 0.0;
        self.frame = startingFrame;

    }
}

@end
