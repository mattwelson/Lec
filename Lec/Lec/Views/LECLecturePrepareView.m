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
        
        bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.848 alpha:1.000].CGColor;
        [self.layer addSublayer:bottomBorder];
        
        [self setupNewSubviews:vm];
        
    }
    return self;
}

-(void)setupNewSubviews:(id)viewModel{
    self.lectureNumber = self.courseViewModel.i+1;
    
    self.lectureNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, 35)];
    self.lectureNumberLabel.text = [NSString stringWithFormat:@"Lecture %ld", (long)self.lectureNumber];
    self.lectureNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.lectureNumberLabel.font = [UIFont fontWithName:DEFAULTFONT size:20];
    self.lectureNumberLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.lectureNumberLabel];
    
    
    self.lectureNameField = [[UITextField alloc]initWithFrame:CGRectMake(20, 35, SCREEN_WIDTH-25, 35)];
    self.lectureNameField.delegate = self;
    self.lectureNameField.backgroundColor = [UIColor clearColor];
    self.lectureNameField.placeholder = @"Lecture Name";
    self.lectureNameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.lectureNameField.textAlignment = NSTextAlignmentLeft;
    self.lectureNameField.font = [UIFont fontWithName:DEFAULTFONT size:30];
    [self.lectureNameField setReturnKeyType: UIReturnKeyGo];
    self.lectureNameField.textColor = [[LECColourService sharedColourService]highlightColourFor:[self.courseViewModel colourString]];
    
    [self addSubview:self.lectureNameField];
    [self.lectureNameField becomeFirstResponder];
}

-(void)animateEntry
{
    //self.frame = CGRectMake(0, 200, SCREEN_WIDTH, 75);
    self.lectureNumberLabel.alpha = 0.0;
    self.lectureNameField.alpha = 0.0;
    [UIView animateWithDuration:0.1
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.lectureNameField.alpha = 1.0;
                         self.lectureNumberLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [self.lectureNameField becomeFirstResponder];
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
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.lectureNameField.alpha = 0.0;
                         self.lectureNumberLabel.alpha = 0.0;
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.lectureNameField resignFirstResponder];
                     }];
    
    [UIView animateWithDuration:1.0
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(0, 200, self.frame.size.width, 0);
                     }
                     completion:^(BOOL finished){
                     }];
}


-(void)confirmDetails
{
    [self.lectureNameField resignFirstResponder];
    [self.preRecordDelegate confirmChanges:self.lectureNumber withName:self.lectureNameField.text];
    [self removeFromSuperview];
}

#pragma mark UITextField Delegate methods
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [self confirmDetails];
    return [textField resignFirstResponder];
}

@end
