//
//  LECBaseCellViewModel.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECColourService.h"

@interface LECBaseCellViewModel : NSObject

@property LECColourService *colourService;

@property NSString *titleText;
@property NSString *subText;
@property UIColor *tintColour;
@property UIImage *disclosure;

@property NSString *colourString;

@end
