//
//  LECIconService.h
//  Lec
//
//  Created by Julin Le-Ngoc on 27/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECImportHeader.h"

@interface LECIconService : NSObject

@property NSDictionary *iconDictionary;

+ (LECIconService *)sharedIconService;

- (NSArray *) iconKeys;
-(UIImage *) iconFor:(NSString *)iconName;

-(void) addIcon:(NSString *)icon toView:(UIView *)view;
-(UIImageView *)addIconCourseScreen:(NSString *)icon toView:(UIView *)view;


@end
