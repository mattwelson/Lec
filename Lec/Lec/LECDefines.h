//
//  LECDefines.h
//  Lec
//
//  Created by Julin Le-Ngoc on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kPlayerNotification = @"PlayerNotification";

// tableview cell identifier
#define CELL_ID_HEADER @"courseheader"
#define CELL_ID_LECTURE_CELL @"lecturecell"
#define CELL_ID_COURSE_CELL @"coursecell"
#define CELL_ID_TAG_CELL @"tagcell"
#define CELL_ID_ADD_CELL @"addcell"

#define PARALLAX_ON NO
#define ANIMATIONS_ON YES
#define FILE_RECORDING_TYPE @"m4a"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


//#define DEFAULTFONT @"Avenir"
//#define DEFAULTFONTLIGHT @"Avenir-Book"

#define DEFAULTFONT @"ChalkboardSE-Regular"
#define DEFAULTFONTLIGHT @"ChalkboardSE-Light"


#define HEADERSIZE 22
#define HEADERCOLOR [UIColor colorWithRed:44/255. green:62/255. blue:80/255. alpha:1.0]
#define NAVTINTCOLOR [UIColor colorWithRed:2/255. green:208/255. blue:198/255. alpha:1.0]

#define COURSENAMEECELLFONTSIZE 32
#define COURSEDESCRIPTIONCELLFONTSIZE 16

#define LECTURENAMEECELLFONTSIZE 24
#define LECTUREDESCRIPTIONCELLFONTSIZE 16

@interface LECDefines : NSObject

@end
