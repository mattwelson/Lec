//
//  LECAddCourseView.h
//  Lec
//
//  Created by Julin Le-Ngoc on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECColorCollectionView.h"
#import "LECIconCollectionView.h"

//@class LECColorCollectionView;
//@class LECIconCollectionView;

@protocol AddCourseDelegate <NSObject>

-(void) saveCourse:(NSString *)courseNameString description:(NSString *)courseDescriptionString colour:(NSString *)colourString icon:(NSString *)iconString;

@end

@interface LECAddCourseView : UIView<ColourPickerDelegate, IconPickerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id<AddCourseDelegate> saveCourseDelegate;

@property LECColorCollectionView *colorView;
@property LECIconCollectionView *iconView;



+(LECAddCourseView *)createAddCourseView;
-(void)animateCourseAddView;
-(void)animateViewRemoved;
-(void)retrieveInputs;


@end


