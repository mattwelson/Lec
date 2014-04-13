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

@protocol LectureEditDelegate <NSObject>

-(void) confirmChanges:(NSInteger)lectureNumber withName:(NSString *)lectureName;
-(void) preRecordCancelled;

@end

@interface LECLectureEditScreen : UIView<UITextViewDelegate>

- (id)initWithFrame:(CGRect)frame withLectureViewModel:(LECLectureViewModel *)vm;

@property LECLectureViewModel *lectureViewModel;
@property NSInteger lectureNumber;
@property UILabel *lectureNumberLabel;
@property UIStepper *lectureNumberStepper;
@property UITextField *lectureNameField;
@property UITextView *lectureNameView;
@property UIButton *startRecordingButton;
@property (nonatomic, assign) id<LectureEditDelegate> preRecordDelegate;

@end
