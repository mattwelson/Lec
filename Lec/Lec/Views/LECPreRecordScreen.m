//
//  LECPreRecordScreen.m
//  Lec
//
//  Created by Julin Le-Ngoc on 7/04/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECPreRecordScreen.h"
#import "LECColourService.h"
#import "LECDefines.h"

#define kPLACEHOLDERNAME @"Type your lecture name here"

@implementation LECPreRecordScreen

- (id)initWithFrame:(CGRect)frame withViewModel:(LECCourseViewModel *)vm
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewModel = vm;
        self.backgroundColor = [UIColor colorWithWhite:0.99 alpha:0.99];
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0;
        
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews{
    self.lectureNumber = self.viewModel.i+1;
    
    self.lectureNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    self.lectureNumberLabel.text = [NSString stringWithFormat:@"Lecture %ld", (long)self.lectureNumber];
    self.lectureNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.lectureNumberLabel.font = [UIFont fontWithName:DEFAULTFONT size:30];
    self.lectureNumberLabel.textColor = [[LECColourService sharedColourService]baseColourFor:[self.viewModel colourString]];
    [self addSubview:self.lectureNumberLabel];
    
    self.lectureNumberStepper = [[UIStepper alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 80, 60, 45)];
    [self.lectureNumberStepper setValue:self.lectureNumber];
    [self.lectureNumberStepper setStepValue:1];
    [self.lectureNumberStepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.lectureNumberStepper setTintColor:[[LECColourService sharedColourService]baseColourFor:[self.viewModel colourString]]];
    [self addSubview:self.lectureNumberStepper];
    
    self.lectureNameField = [[UITextView alloc]initWithFrame:CGRectMake(60, 150, 200, 200)];
    self.lectureNameField.delegate = self;
    self.lectureNameField.backgroundColor = [UIColor clearColor];
    self.lectureNameField.text = kPLACEHOLDERNAME;
    self.lectureNameField.textAlignment = NSTextAlignmentCenter;
    self.lectureNameField.font = [UIFont fontWithName:DEFAULTFONT size:30];
    [self.lectureNameField setReturnKeyType: UIReturnKeyDone];
    self.lectureNameField.textColor = [UIColor lightGrayColor];
    [self addSubview:self.lectureNameField];
    
    self.startRecordingButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, 350, 40, 40)];
    [self.startRecordingButton setImage:[UIImage imageNamed:@"icon_mic.png"] forState:UIControlStateNormal];
    [self.startRecordingButton addTarget:self action:@selector(startRecording) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startRecordingButton];
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"icon_cancel.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchDown];
    [self addSubview:closeButton];
    [self bringSubviewToFront:closeButton];
}

-(void)dismissScreen
{
    [self removeFromSuperview];
}

-(void)startRecording
{
    [self.preRecordDelegate readyToRecord:self.lectureNumber withName:self.lectureNameField.text];
    [self removeFromSuperview];
}

#pragma mark UITextView Delegate methods
//If enter is pushed, dismiss keyboard
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kPLACEHOLDERNAME]) {
        textView.text = @"";
        textView.textColor = [[LECColourService sharedColourService]highlightColourFor:[self.viewModel colourString]];
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
