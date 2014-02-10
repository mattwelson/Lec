//
//  LECCourseHeaderView.m
//  Lec
//
//  Created by Julin Le-Ngoc on 29/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECHeaderView.h"
#import "LECParallaxService.h"


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
        [subjectImg setFrame:CGRectMake(130, 30, 60, 60)];
        [self addSubview:subjectImg];
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.frame.size.width, 50)];
        titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:DEFAULTFONTLIGHT size:40];
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        
        descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, self.frame.size.width, 50)];
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.font = [UIFont fontWithName:DEFAULTFONTLIGHT size:15];
        descriptionLabel.textColor = [UIColor whiteColor];
        [self addSubview:descriptionLabel];
        
        if(PARALLAX_ON) {
//            NSArray *subviews = [self subviews];
//            for (UIView *subview in subviews) {
//                if (subview == titleLabel) {
//                    [[LECParallaxService sharedParallaxService]addParallaxToView:subview strength:2];
//                }
//                else {
//                    [[LECParallaxService sharedParallaxService]addParallaxToView:subview strength:1];
//                }
            [[LECParallaxService sharedParallaxService]addParallaxToView:subjectImg strength:1];
            [[LECParallaxService sharedParallaxService]addParallaxToView:titleLabel strength:2];
            [[LECParallaxService sharedParallaxService]addParallaxToView:descriptionLabel strength:1];

            }
    }
    return self;
}

- (id)initWithCourse:(LECCourseViewModel *)courseModel
{
    self = [self initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    if (self) {
        [[LECColourService sharedColourService] addGradientForColour:courseModel.colourString toView:self];
        subjectImg = [[LECIconService sharedIconService] retrieveIcon:courseModel.icon toView:subjectImg];
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
        subjectImg = [[LECIconService sharedIconService] retrieveIcon:lectureModel.icon toView:subjectImg];
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
