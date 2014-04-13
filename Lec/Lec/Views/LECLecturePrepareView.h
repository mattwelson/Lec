//
//  LECLecturePrepareView.h
//  Lec
//
//  Created by Julin Le-Ngoc on 12/04/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECCourseViewModel.h"
#import "LECDefines.h"

@protocol PreRecordDelegate <NSObject>

-(void) confirmChanges:(NSInteger)lectureNumber withName:(NSString *)lectureName;
-(void) preRecordCancelled;

@end

@interface LECLecturePrepareView : UIView<UITextFieldDelegate>

- (id)initWithFrame:(CGRect)frame withCourseViewModel:(LECCourseViewModel *)vm;
- (void)animateEntry;
- (void)dismissScreen;

@property LECCourseViewModel *courseViewModel;
@property NSInteger lectureNumber;
@property UITextField *lectureNumberField;
@property UIStepper *lectureNumberStepper;
@property UITextField *lectureNameField;
@property UIButton *startRecordingButton;
@property (nonatomic, assign) id<PreRecordDelegate> preRecordDelegate;

@end
