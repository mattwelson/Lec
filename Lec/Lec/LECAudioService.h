//
//  LECAudioService.h
//  Lec
//
//  Created by Matt Welson on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LECAudioService : NSObject <AVAudioRecorderDelegate>

+ (LECAudioService *)sharedAudioService;


-(void) setupAudioRecordingForPath:(NSString *)path;
-(void) startRecording;
-(void) stopRecording;

@end
