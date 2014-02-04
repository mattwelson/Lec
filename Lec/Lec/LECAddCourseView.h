//
//  LECAddCourseView.h
//  Lec
//
//  Created by Julin Le-Ngoc on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECColorCollectionView.h"

@protocol SaveCourseDelegate <NSObject>

-(void) saveCourse:(NSString *)courseNameString description:(NSString *)courseDescriptionString colour:(NSString *)colourString;

@end

@interface LECAddCourseView : UIView<ColourPickerDelegate>

@property LECColorCollectionView *colorView;

@property (nonatomic, assign) id<SaveCourseDelegate> saveCourseDelegate;

+(LECAddCourseView *)createAddCourseView;
-(void)animateCourseAddView;
-(void)animateViewRemoved;
-(void)retrieveInputs;


@end
