//
//  LECIconService.m
//  Lec
//
//  Created by Julin Le-Ngoc on 27/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECIconService.h"

@implementation LECIconService

static LECIconService *sharedService;

-(LECIconService *) init
{
    self = [super init];
    if (self)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Icons" ofType:@"plist"];
        self.iconDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSLog(@"DIctionary: %@",self.iconDictionary);
    }
    return self;
}

+ (LECIconService *) sharedIconService
{
    if (sharedService) return sharedService;
    
    sharedService = [[LECIconService alloc] init];
    return sharedService;
}

-(NSArray *)iconKeys
{
    return [[sharedService iconDictionary] allKeys];
}

-(UIImage *) iconFor:(NSString *)iconName{
    NSString *iconString = [[self iconDictionary] valueForKey:iconName];
    NSLog(@"Icon String: %@", iconString);
    //UIImage *iconImg = [[UIImage alloc]initWithContentsOfFile:iconString];
    UIImage *iconImg = [UIImage imageNamed:iconString];
    NSLog(@"Icon Image: %@", iconImg);
    return iconImg;
}


-(void) addIcon:(NSString *)icon toView:(UIView *)view{
    UIImageView *iconImgView = [[UIImageView alloc]initWithImage:[self iconFor:icon]];
    
    iconImgView.image = [iconImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [iconImgView setTintColor:[UIColor whiteColor]];
    
    //[gradient setFrame:[view frame]];
    [iconImgView setFrame:CGRectMake(15, 25, 50, 50)];
    //[view insertSubview:iconImgView atIndex:0];
    [view.layer insertSublayer:iconImgView.layer atIndex:0];
}


@end
