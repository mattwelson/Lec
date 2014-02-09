//
//  LECLectureViewModel.h
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECBaseViewModel.h"

@interface LECLectureViewModel : LECBaseViewModel

+(LECLectureViewModel *)viewModelWithLecture:(Lecture *)lecture;

@property NSString *icon;
@property Lecture *lecture;
@property NSMutableArray *tags;
@property (nonatomic) NSString *recordingPath;
@property BOOL needsRecording;

@property NSString *courseName;

// instance of AVAudio or Audio service?
-(void) prepareForRecordingAudio;
-(void) startRecordingAudio;
-(void) stopRecordingAudio;
-(void) addTagToCurrentTime;

-(void) prepareForPlayback;
-(void) startAudioPlayback;
-(void) stopAudioPlayback;
@end
