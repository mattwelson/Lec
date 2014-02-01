//
//  LECCourseHeaderView.m
//  Lec
//
//  Created by Julin Le-Ngoc on 29/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECHeaderView.h"

@implementation LECHeaderView{
    CGRect startingFrame;
    UIImageView *subjectImg;
    UILabel *navTitle;
    UILabel *titleLabel;
    UILabel *descriptionLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        startingFrame = frame;
        
        subjectImg = [UIImageView new];
        [subjectImg setTintColor:[UIColor whiteColor]];
        [subjectImg setFrame:CGRectMake(120, 30, 60, 60)];
        [self addSubview:subjectImg];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.frame.size.width, 50)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:DEFAULTFONTLIGHT size:40];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        
        descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, self.frame.size.width, 50)];
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.font = [UIFont fontWithName:DEFAULTFONTLIGHT size:15];
        descriptionLabel.textColor = [UIColor whiteColor];
        [self addSubview:descriptionLabel];
    }
    return self;
}

- (id)initWithCourse:(LECCourseViewModel *)courseModel
{
    self = [self initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    if (self) {
        [[LECColourService sharedColourService] addGradientForColour:courseModel.colourString toView:self];
        subjectImg = [[LECIconService sharedIconService] addIconCourseScreen:courseModel.icon toView:subjectImg];
        titleLabel.text = courseModel.navTitle;
        descriptionLabel.text = courseModel.subTitle;
    }
    return self;
}

-(id)initWithLecture:(LECLectureViewModel *)lectureModel
{
    self = [self initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width, 200)];
    if (self) {
        [[LECColourService sharedColourService] addGradientForColour:lectureModel.colourString toView:self];
        subjectImg = [[LECIconService sharedIconService] addIconCourseScreen:lectureModel.icon toView:subjectImg];
        titleLabel.text = lectureModel.navTitle;
        descriptionLabel.text = lectureModel.subTitle;
    }
    return self;
}

-(void)changeAlpha:(CGFloat) tableOffset{
    
    if (tableOffset > 0 && tableOffset < 140) {
        subjectImg.alpha = 1-(tableOffset/50); // different to be more dynamic
        titleLabel.alpha = 1-(tableOffset/75);
        descriptionLabel.alpha = 1-(tableOffset/75);
        self.frame = CGRectMake(0, 0-tableOffset/3, self.frame.size.width, 200);
        navTitle.alpha = -0.9 + (tableOffset/50);
    }
    
    else if(tableOffset < 2) {
        subjectImg.alpha = 1;
        titleLabel.alpha = 1;
        descriptionLabel.alpha = 1;
        navTitle.alpha = 0.0;
        self.frame = startingFrame;

    }
}

@end
