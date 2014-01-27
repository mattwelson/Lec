//
//  LECIconService.h
//  Lec
//
//  Created by Julin Le-Ngoc on 27/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LECIconService : NSObject

@property NSDictionary *iconDictionary;

+ (LECIconService *)sharedIconService;

- (NSArray *) iconKeys;

-(void) addIcon:(NSString *)icon toView:(UIView *)view;


@end
