//
//  LECAnimationService.h
//  Lec
//
//  Created by Julin Le-Ngoc on 12/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECDefines.h"

@interface LECAnimationService : NSObject

+ (LECAnimationService *)sharedAnimationService;

-(void)addSpringAnimationToView:(UIView *)view withDelay:(double)delay;
-(void)addAlphaToView:(UIView *)view withDelay:(double)delay;

@end
