//
//  LECLecturePrepareView.m
//  Lec
//
//  Created by Julin Le-Ngoc on 12/04/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECLecturePrepareView.h"

@implementation LECLecturePrepareView{
    CALayer *bottomBorder;
}

- (id)initWithFrame:(CGRect)frame withCourseViewModel:(LECCourseViewModel *)vm
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.courseViewModel = vm;
        self.backgroundColor = [UIColor colorWithWhite:1.00 alpha:1.00];
        
        [self setupNewSubviews:vm];
        
    }
    return self;
}

-(void)layoutSubviews
{
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.848 alpha:1.000].CGColor;
    [self.layer addSublayer:bottomBorder];
}

-(void)setupNewSubviews:(id)viewModel{
    self.lectureNumber = self.courseViewModel.i+1;
    
    self.lectureNumberField = [[UITextField alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH-20, 35)];
    self.lectureNumberField.text = [NSString stringWithFormat:@"Lecture %ld", (long)self.lectureNumber];
    self.lectureNumberField.delegate = self;
    self.lectureNumberField.placeholder = @"Lecture Number";
    self.lectureNumberField.tag = 1;
    self.lectureNumberField.clearsOnBeginEditing = YES;
    self.lectureNumberField.keyboardType = UIKeyboardTypeDecimalPad;
    self.lectureNumberField.textAlignment = NSTextAlignmentLeft;
    self.lectureNumberField.font = [UIFont fontWithName:DEFAULTFONT size:25];
    self.lectureNumberField.textColor = [UIColor lightGrayColor];
    [self addSubview:self.lectureNumberField];
    
    self.lectureNameField = [[UITextField alloc]initWithFrame:CGRectMake(20, 55, 200, 60)];
    self.lectureNameField.delegate = self;
    self.lectureNameField.tag = 0;
    self.lectureNameField.backgroundColor = [UIColor clearColor];
    self.lectureNameField.placeholder = @"Lecture Name";
    self.lectureNameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.lectureNameField.textAlignment = NSTextAlignmentLeft;
    self.lectureNameField.font = [UIFont fontWithName:DEFAULTFONT size:30];
    [self.lectureNameField setReturnKeyType: UIReturnKeyDone];
    self.lectureNameField.textColor = [[LECColourService sharedColourService]baseColourFor:[self.courseViewModel colourString]];
    [self addSubview:self.lectureNameField];
    [self.lectureNameField becomeFirstResponder];
    
    //This is the little record button
        self.startRecordingButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-75, 60, 45, 45)];
        [self.startRecordingButton setImage:[[UIImage imageNamed:@"icon_mic.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.startRecordingButton setTintColor:[[LECColourService sharedColourService]highlightColourFor:[viewModel colourString]]];
        [self.startRecordingButton addTarget:self action:@selector(confirmDetails) forControlEvents:UIControlEventTouchUpInside];
        self.startRecordingButton.layer.cornerRadius = self.startRecordingButton.frame.size.height/2;
        self.startRecordingButton.layer.borderWidth = 1.0;
        self.startRecordingButton.layer.borderColor = [[LECColourService sharedColourService]highlightColourFor:[viewModel colourString]].CGColor;
        [self addSubview:self.startRecordingButton];
    
}

-(void)animateEntry
{
    //self.frame = CGRectMake(0, 200, SCREEN_WIDTH, 75);
    self.lectureNumberField.alpha = 0.0;
    self.lectureNameField.alpha = 0.0;
    self.startRecordingButton.alpha = 0.0;
    bottomBorder.opacity = 0.0;
    [UIView animateWithDuration:0.2
                          delay:0.4
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.lectureNameField.alpha = 1.0;
                         self.lectureNumberField.alpha = 1.0;
                         self.startRecordingButton.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [self.lectureNameField becomeFirstResponder];
                         bottomBorder.opacity = 1.0;
                     }];
}

-(void)dismissScreen
{

    [self.lectureNameField resignFirstResponder];
    [self.preRecordDelegate preRecordCancelled];
//    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.frame = CGRectMake(0, 135, SCREEN_WIDTH, 0);
//    }completion:^(BOOL completion){
//        [self.lectureNameField resignFirstResponder];
//        [self removeFromSuperview];
//    }];
    bottomBorder.opacity = 0.0;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.lectureNameField.alpha = 0.0;
                         self.lectureNumberField.alpha = 0.0;
                         self.startRecordingButton.alpha = 0.0;
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.lectureNameField resignFirstResponder];
                     }];
    
//    [UIView animateWithDuration:1.0
//                          delay:0.2
//                        options: UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         self.frame = CGRectMake(0, 200, self.frame.size.width, 0);
//                     }
//                     completion:^(BOOL finished){
//                     }];
}


-(void)confirmDetails
{
    [self.lectureNameField resignFirstResponder];
    [self.preRecordDelegate confirmChanges:self.lectureNumber withName:self.lectureNameField.text];
    [self removeFromSuperview];
}

#pragma mark UITextField Delegate methods
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag == 1) {
        if (textField.text.length !=0) {
            self.lectureNumber = [self.lectureNumberField.text integerValue];
        }
        self.lectureNumberField.text = [NSString stringWithFormat:@"Lecture %ld", (long)self.lectureNumber];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [self confirmDetails];
    return [textField resignFirstResponder];
}


@end
