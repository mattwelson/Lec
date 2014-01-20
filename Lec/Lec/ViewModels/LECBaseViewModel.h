//
//  LECBaseViewModel.h
//  Lec
//
//  Created by Matt Welson on 18/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECColourService.h"
#include "LECDatabaseService.h"

@interface LECBaseViewModel : NSObject

@property NSString *navTitle;

@property LECColourService *colourService;

@property LECDatabaseService *dataService;

@end