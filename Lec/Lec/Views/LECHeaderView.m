//
//  LECCourseHeaderView.m
//  Lec
//
//  Created by Julin Le-Ngoc on 29/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECHeaderView.h"
#import "LECParallaxService.h"
#import "LECAnimationService.h"

@implementation LECHeaderView{
    CGRect startingFrame;
    UIImageView *subjectImg;
    UILabel *navTitle;
    UILabel *titleLabel;
    UILabel *descriptionLabel;
}

static void * localContext = &localContext;

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
        
        if(ANIMATIONS_ON) {
            [[LECAnimationService sharedAnimationService] addPop:subjectImg withSpeed:1.0 withDelay:0.0];
            [[LECAnimationService sharedAnimationService] addAlphaToView:subjectImg withSpeed:0.5 withDelay:0.0];
            [[LECAnimationService sharedAnimationService] addAlphaToView:titleLabel withSpeed:0.5 withDelay:0.1];
            [[LECAnimationService sharedAnimationService] addAlphaToView:descriptionLabel withSpeed:0.5 withDelay:0.2];
        }
        
        if(PARALLAX_ON) {
            [[LECParallaxService sharedParallaxService]addParallaxToView:subjectImg strength:1];
            [[LECParallaxService sharedParallaxService]addParallaxToView:titleLabel strength:2];
            [[LECParallaxService sharedParallaxService]addParallaxToView:descriptionLabel strength:1];

            }
    }
    return self;
}

- (void)dealloc
{
    [self deallocObservation:self.currentViewModel];
}

- (id)initWithCourse:(LECCourseViewModel *)courseModel
{
    self.currentViewModel = courseModel;
    self = [self initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    if (self) {
        [[LECColourService sharedColourService] addGradientForColour:courseModel.colourString toView:self];
        subjectImg = [[LECIconService sharedIconService] retrieveIcon:courseModel.icon toView:subjectImg];
        titleLabel.text = courseModel.navTitle;
        descriptionLabel.text = courseModel.subTitle;
        [self setupObservingOf:courseModel];
    }
    return self;
}

-(id)initWithLecture:(LECLectureViewModel *)lectureModel andIsRecording:(BOOL)isRecording
{
    self.currentViewModel = lectureModel;
    self = [self initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen] bounds].size.width, 200)];
    if (self) {
        [[LECColourService sharedColourService] addGradientForColour:lectureModel.colourString toView:self];
        subjectImg = [[LECIconService sharedIconService] retrieveIcon:lectureModel.icon toView:subjectImg];
        titleLabel.text = lectureModel.navTitle;
        descriptionLabel.text = lectureModel.subTitle;
        [self setupObservingOf:lectureModel];
    }
    return self;
}

-(void)changeAlpha:(CGFloat) tableOffset{
    if (tableOffset > 0 && tableOffset < 140) {
        subjectImg.alpha = 1-(tableOffset/50); // different to be more dynamic
        titleLabel.alpha = 1-(tableOffset/75);
        descriptionLabel.alpha = 1-(tableOffset/75);
        self.frame = CGRectMake(0, 0-tableOffset/3, SCREEN_WIDTH, 200);
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

#pragma mark - KVO
// seperated off as it's ugly as shit
-(void) setupObservingOf:(id)vm
{
    if ([vm isKindOfClass:[LECCourseViewModel class]]) {
        [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(colourString)) options:NSKeyValueObservingOptionNew context:localContext];
        [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(icon)) options:NSKeyValueObservingOptionNew context:localContext];
    }
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(subTitle)) options:NSKeyValueObservingOptionNew context:localContext];
    [vm addObserver:self forKeyPath:NSStringFromSelector(@selector(navTitle)) options:NSKeyValueObservingOptionNew context:localContext];
}


-(void)deallocObservation:(id)vm;
{
    @try {
        if ([vm isKindOfClass:[LECCourseViewModel class]]) {
            [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(colourString))];
            [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(icon))];
        }
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(subTitle))];
        [vm removeObserver:self forKeyPath:NSStringFromSelector(@selector(navTitle))];
    }
    @catch (NSException * __unused exception) {}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // sanity check to ensure subclassing hasn't screwed us over, best practice
    if (context != localContext) return;
    if ([NSNull null] == change[NSKeyValueChangeNewKey])
    {
        [self deallocObservation:object];
        return;
    }
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(subTitle))])
    {
        descriptionLabel.text = change[NSKeyValueChangeNewKey];
    }
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(navTitle))])
    {
        navTitle.text = change[NSKeyValueChangeNewKey];
        titleLabel.text = change[NSKeyValueChangeNewKey];
    }
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(colourString))])
    {
        [[LECColourService sharedColourService] changeGradientToColour:change[NSKeyValueChangeNewKey] forView:self];
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(icon))])
    {
        [[LECIconService sharedIconService] retrieveIcon:change[NSKeyValueChangeNewKey] toView:subjectImg];
    }
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(titleText))])
//    {
//        navTitle.text = change[NSKeyValueChangeNewKey];
//        [navTitle setNeedsDisplay];
//        titleLabel.text = change[NSKeyValueChangeNewKey];
//        [titleLabel setNeedsDisplay];
//    }
//    
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(subText))])
//    {
//        descriptionLabel.text = change[NSKeyValueChangeNewKey];
//        [descriptionLabel setNeedsDisplay];
//    }
}

@end
