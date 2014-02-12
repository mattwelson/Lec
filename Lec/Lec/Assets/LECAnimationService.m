//
//  LECAnimationService.m
//  Lec
//
//  Created by Julin Le-Ngoc on 12/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECAnimationService.h"

@implementation LECAnimationService

static LECAnimationService *sharedService;

+ (LECAnimationService *) sharedAnimationService
{
    if (sharedService) return sharedService;
    
    sharedService = [[LECAnimationService alloc] init];
    return sharedService;
}

-(void)addSpringAnimationToView:(UIView *)view withDelay:(double)delay{
    
    view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, 101);
    //Leave the 0.6 delay in! The real iPhone loads stuff during the splash screen so we want to start it a little later.
    [UIView animateWithDuration:1.0
                          delay:delay
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 101);
                     }
                     completion:^(BOOL finished){
                         NULL;
                     }];
}

-(void)addAlphaToView:(UIView *)view withDelay:(double)delay{
    
    view.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionLayoutSubviews animations:^{
        view.alpha = 1.0;
        
    }completion:^(BOOL finished) {
        NULL;
    }];
     
}
@end
