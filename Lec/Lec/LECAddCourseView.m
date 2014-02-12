//
//  LECAddCourseView.m
//  Lec
//
//  Created by Julin Le-Ngoc on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECAddCourseView.h"
#import "LECDefines.h"
#import "LECDatabaseService.h"
#import "LECColourService.h"
#import "LECIconService.h"

@implementation LECAddCourseView{
    UITextField *courseNameInput;
    UITextField *courseDescriptorInput;
    UIView *colorButtonView;
    UIView *iconButtonView;
    UIButton *colorPickerButton;
    UIButton *iconPickerButton;
    NSString *selectedColour;
    NSString *selectedIcon;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self createAllFields];
    }
    return self;
}

+(LECAddCourseView *)createAddCourseView{
    LECAddCourseView *addCourseView = [[LECAddCourseView alloc]init];
    return addCourseView;
}

-(id)init {
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 64, 320, 0);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return self;
}

-(void)createAllFields{
    
    courseNameInput = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, self.frame.size.width-60, 0)];
    courseNameInput.placeholder = @"Course Name";
    courseNameInput.tag = 0;
    courseNameInput.delegate = self;
    [courseNameInput setFont:[UIFont fontWithName:DEFAULTFONT size:COURSENAMEECELLFONTSIZE]];
    [courseNameInput setTextColor:HEADERCOLOR];
    courseNameInput.alpha = 0.0;
    [courseNameInput setReturnKeyType:UIReturnKeyNext];
    [courseNameInput setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [self addSubview:courseNameInput];
    //[courseNameInput becomeFirstResponder];

    
    courseDescriptorInput = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, self.frame.size.width-60,0)];
    courseDescriptorInput.placeholder = @"Course Description";
    courseDescriptorInput.tag = 1;
    courseDescriptorInput.delegate = self;
    [courseDescriptorInput setFont:[UIFont fontWithName:DEFAULTFONT size:COURSEDESCRIPTIONCELLFONTSIZE]];
    [courseDescriptorInput setTextColor:HEADERCOLOR];
    courseDescriptorInput.alpha = 0.0;
    [courseDescriptorInput setReturnKeyType:UIReturnKeyDone];
    [courseDescriptorInput setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [self addSubview:courseDescriptorInput];
    
    colorButtonView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, 50, 0)];
    colorButtonView.backgroundColor = [UIColor clearColor];
    colorButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    colorButtonView.layer.borderWidth = 1.0f;
    [self addSubview:colorButtonView];
    
    iconButtonView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, 50, 0)];
    iconButtonView.backgroundColor = [UIColor clearColor];
    iconButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    iconButtonView.layer.borderWidth = 1.0f;
    [self addSubview:iconButtonView];
    
    colorPickerButton = [[UIButton alloc]initWithFrame:CGRectMake(9, 10, 32, 0)];
    colorPickerButton.backgroundColor = [UIColor blackColor];
    colorPickerButton.layer.cornerRadius = colorPickerButton.frame.size.width/2;
    colorPickerButton.layer.masksToBounds = YES;
    colorPickerButton.layer.borderWidth = 0;
    colorPickerButton.alpha = 0.0;
    [colorPickerButton addTarget:Nil action:@selector(colorViewAppear) forControlEvents:UIControlEventTouchDown];
    [colorButtonView addSubview:colorPickerButton];
    
    //Default colour
    selectedColour = @"Red";
    
    iconPickerButton = [[UIButton alloc]initWithFrame:CGRectMake(9, 10, 32, 0)];
    //iconPickerButton.backgroundColor = [UIColor blackColor];
    iconPickerButton.alpha = 0.0;
    iconPickerButton.tintColor = [UIColor lightGrayColor];
    [iconPickerButton addTarget:Nil action:@selector(iconViewAppear) forControlEvents:UIControlEventTouchDown];
    [iconButtonView addSubview:iconPickerButton];
    
    selectedIcon = @"cs";
}

- (void) colorViewAppear
{
    [self endEditing:YES];
    self.colorView = [LECColorCollectionView colourCollection];
    self.colorView.colourPickerDelegate = self;
    
    //Creates the array based on the plist
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.colorView];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.colorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                     }
                     completion:^(BOOL finished){
                     }];
    
}

- (void) iconViewAppear
{
    [self endEditing:YES];
    self.iconView = [LECIconCollectionView iconCollection];
    self.iconView.iconPickerDelegate = self;
    
    //Creates the array based on the plist
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.iconView];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.iconView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
                     }
                     completion:^(BOOL finished){
                     }];
    
}

- (void)colourPickerDismissed:(NSString *)colourString {
    selectedColour = colourString;
    [[LECColourService sharedColourService] changeGradientToColour:colourString forView:colorPickerButton];
}

- (void)iconPickerDismissed:(NSString *)iconString {
    selectedIcon = iconString;
    [iconPickerButton setImage:[[LECIconService sharedIconService]iconFor:selectedIcon] forState:UIControlStateNormal];
}

-(void)animateCourseAddView{
    self.frame = CGRectMake(0, 64, self.frame.size.width, 100);
    //self.courseTableView.frame = CGRectMake(0, 100, 320, self.frame.size.height);
    courseNameInput.frame = CGRectMake(60, 5, self.frame.size.width-60, 50);
    courseDescriptorInput.frame = CGRectMake(62, 50, self.frame.size.width-60,50);
    colorButtonView.frame = CGRectMake(-1, 0, 50, 52);
    iconButtonView.frame = CGRectMake(-1, 50, 50, 50);
    colorPickerButton.frame = CGRectMake(9, 10, 32, 32);
    iconPickerButton.frame = CGRectMake(9, 10, 32, 32);
    [[LECColourService sharedColourService] addGradientForColour:selectedColour toView:colorPickerButton];
    [iconPickerButton setImage:[[LECIconService sharedIconService]iconFor:selectedIcon] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         courseNameInput.alpha = 1.0;
                         courseDescriptorInput.alpha = 1.0;
                         colorPickerButton.alpha = 1.0;
                         iconPickerButton.alpha = 1.0;
                         //[courseNameInput becomeFirstResponder];
                     }
                     completion:^(BOOL finished){
                         [courseNameInput becomeFirstResponder];
                     }];
    

}

-(void)animateViewRemoved{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         courseNameInput.alpha = 0.0;
                         courseDescriptorInput.alpha = 0.0;
                         colorPickerButton.alpha = 0.0;
                         iconPickerButton.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [courseNameInput resignFirstResponder];
                     }];

    [UIView animateWithDuration:1.0
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(0, 64, self.frame.size.width, 0);
                         courseNameInput.frame = CGRectMake(60, 10, self.frame.size.width-60, 0);
                         courseDescriptorInput.frame = CGRectMake(60, 10, self.frame.size.width-60,0);
                         colorButtonView.frame = CGRectMake(-1, -1, 50, 0);
                         iconButtonView.frame = CGRectMake(-1, 0, 50, 0);
                         colorPickerButton.frame = CGRectMake(9, 10, 32, 0);
                         iconPickerButton.frame = CGRectMake(9, 10, 32, 0);
                     }
                     completion:^(BOOL finished){
                     }];
    
    

}

-(void)retrieveInputs {
    [self.saveCourseDelegate saveCourse:courseNameInput.text description:courseDescriptorInput.text colour:selectedColour icon:selectedIcon];
}

#pragma mark UITextField Delegate methods
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    NSInteger nextTag = textField.tag + 1;
    
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found responder, so set it
        [nextResponder becomeFirstResponder];
    } else {
        // Not found so remove keyboard
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

@end
