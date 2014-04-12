//
//  LECPreRecordScreen.m
//  Lec
//
//  Created by Julin Le-Ngoc on 7/04/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECLectureEditScreen.h"
#import "LECColourService.h"
#import "LECDefines.h"

#define kPLACEHOLDERNAME @"Type your lecture name here"

@implementation LECLectureEditScreen


- (id)initWithFrame:(CGRect)frame withLectureViewModel:(LECLectureViewModel *)vm
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.lectureViewModel = vm;
        self.backgroundColor = [UIColor colorWithWhite:0.99 alpha:0.97];
        
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        
        //        self.layer.borderWidth = 1;
        //        self.layer.borderColor = [[LECColourService sharedColourService]highlightColourFor:[self.viewModel colourString]].CGColor;
        
        [self setupEditSubviews:vm];
        
    }
    return self;
}


-(void)setupEditSubviews:(id)viewModel{
    self.lectureNumber = [self.lectureViewModel.lecture.lectureNumber integerValue];

    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 40, 40)];
    [closeButton setImage:[[UIImage imageNamed:@"icon_cancel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [closeButton setTintColor:[[LECColourService sharedColourService]highlightColourFor:[viewModel colourString]]];
    [closeButton addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchDown];
    [self addSubview:closeButton];
    
    if(![viewModel isKindOfClass:[LECCourseViewModel class]]){
        UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(270, 25, 40, 40)];
        [confirmButton setImage:[[UIImage imageNamed:@"icon_checkmark.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [confirmButton setTintColor:[[LECColourService sharedColourService]highlightColourFor:[viewModel colourString]]];
        [confirmButton addTarget:self action:@selector(confirmDetails) forControlEvents:UIControlEventTouchDown];
        [self addSubview:confirmButton];
    }
    
    self.lectureNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    self.lectureNumberLabel.text = [NSString stringWithFormat:@"Lecture %ld", (long)self.lectureNumber];
    self.lectureNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.lectureNumberLabel.font = [UIFont fontWithName:DEFAULTFONT size:30];
    self.lectureNumberLabel.textColor = [[LECColourService sharedColourService]baseColourFor:[viewModel colourString]];
    [self addSubview:self.lectureNumberLabel];
    
    self.lectureNumberStepper = [[UIStepper alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 80, 60, 45)];
    [self.lectureNumberStepper setValue:self.lectureNumber];
    [self.lectureNumberStepper setStepValue:1];
    [self.lectureNumberStepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.lectureNumberStepper setTintColor:[[LECColourService sharedColourService]baseColourFor:[viewModel colourString]]];
    [self addSubview:self.lectureNumberStepper];
    
    self.lectureNameView = [[UITextView alloc]initWithFrame:CGRectMake(40, 120, 240, 120)];
    self.lectureNameView.delegate = self;
    self.lectureNameView.backgroundColor = [UIColor clearColor];
    if([viewModel isKindOfClass:[LECCourseViewModel class]]){
        self.lectureNameView.text = kPLACEHOLDERNAME;
    }
    else {
        self.lectureNameView.text = self.lectureViewModel.lecture.lectureName;
    }
    self.lectureNameView.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.lectureNameView.textAlignment = NSTextAlignmentCenter;
    self.lectureNameView.font = [UIFont fontWithName:DEFAULTFONT size:30];
    [self.lectureNameView setReturnKeyType: UIReturnKeyGo];
    if([viewModel isKindOfClass:[LECCourseViewModel class]]){
        self.lectureNameView.textColor = [UIColor lightGrayColor];
    }
    else {
        self.lectureNameView.textColor = [[LECColourService sharedColourService]highlightColourFor:[self.lectureViewModel colourString]];
    }
    [self addSubview:self.lectureNameView];
    [self.lectureNameView becomeFirstResponder];
    
    //This is the little record button
//    if([viewModel isKindOfClass:[LECCourseViewModel class]]){
//        self.startRecordingButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 320, 60, 60)];
//        [self.startRecordingButton setImage:[[UIImage imageNamed:@"icon_mic.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//        [self.startRecordingButton setTintColor:[[LECColourService sharedColourService]highlightColourFor:[viewModel colourString]]];
//        [self.startRecordingButton addTarget:self action:@selector(confirmDetails) forControlEvents:UIControlEventTouchUpInside];
//        self.startRecordingButton.layer.cornerRadius = self.startRecordingButton.frame.size.height/2;
//        self.startRecordingButton.layer.borderWidth = 1.0;
//        self.startRecordingButton.layer.borderColor = [[LECColourService sharedColourService]highlightColourFor:[viewModel colourString]].CGColor;
//        [self addSubview:self.startRecordingButton];
//    }
    
}

-(void)dismissScreen
{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha = 0.0;
//    }completion:^(BOOL finished){
//        
//    }];
    [self.lectureNameView resignFirstResponder];
    [self.preRecordDelegate preRecordCancelled];
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL completion){
        [self.lectureNameView resignFirstResponder];
        [self removeFromSuperview];
    }];
}

-(void)confirmDetails
{
    [self.lectureNameView resignFirstResponder];
    [self.preRecordDelegate confirmChanges:self.lectureNumber withName:self.lectureNameView.text];
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
    }completion:^(BOOL completion){
        [self removeFromSuperview];
    }];
}

#pragma mark UITextView Delegate methods
//If enter is pushed, dismiss keyboard
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self confirmDetails];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kPLACEHOLDERNAME]) {
        textView.text = @"";
        textView.textColor = [[LECColourService sharedColourService]highlightColourFor:[self.lectureViewModel colourString]];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = kPLACEHOLDERNAME;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


#pragma mark Stepper Delegates

-(void)stepperChanged:(UIStepper *)sender
{
    self.lectureNumber = sender.value;
    self.lectureNumberLabel.text = [NSString stringWithFormat:@"Lecture %ld", (long)self.lectureNumber];
}

@end
