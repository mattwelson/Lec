//
//  LECPreRecordScreen.h
//  Lec
//
//  Created by Julin Le-Ngoc on 7/04/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECCourseViewModel.h"

@protocol PreRecordDelegate <NSObject>

-(void) readyToRecord:(NSInteger)lectureNumber withName:(NSString *)lectureName;
-(void) preRecordCancelled;

@end

@interface LECPreRecordScreen : UIView<UITextViewDelegate>

- (id)initWithFrame:(CGRect)frame withCourseViewModel:(LECCourseViewModel *)vm;

@property LECCourseViewModel *viewModel;
@property NSInteger lectureNumber;
@property UILabel *lectureNumberLabel;
@property UIStepper *lectureNumberStepper;
@property UITextView *lectureNameField;
@property UIButton *startRecordingButton;
@property (nonatomic, assign) id<PreRecordDelegate> preRecordDelegate;

@end
