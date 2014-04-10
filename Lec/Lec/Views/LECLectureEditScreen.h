//
//  LECPreRecordScreen.h
//  Lec
//
//  Created by Julin Le-Ngoc on 7/04/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECCourseViewModel.h"
#import "LECLectureViewModel.h"

@protocol PreRecordDelegate <NSObject>

-(void) confirmChanges:(NSInteger)lectureNumber withName:(NSString *)lectureName;
-(void) preRecordCancelled;

@end

@interface LECLectureEditScreen : UIView<UITextViewDelegate>

- (id)initWithFrame:(CGRect)frame withCourseViewModel:(LECCourseViewModel *)vm;
- (id)initWithFrame:(CGRect)frame withLectureViewModel:(LECLectureViewModel *)vm;

@property LECCourseViewModel *courseViewModel;
@property LECLectureViewModel *lectureViewModel;
@property NSInteger lectureNumber;
@property UILabel *lectureNumberLabel;
@property UIStepper *lectureNumberStepper;
@property UITextView *lectureNameField;
@property UIButton *startRecordingButton;
@property (nonatomic, assign) id<PreRecordDelegate> preRecordDelegate;

@end
