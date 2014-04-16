//
//  LECLectureViewModel.h
//  Lec
//
//  Created by Codie Westphall on 19/01/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECBaseViewModel.h"
#import "LECAudioService.h"

@protocol PlaybackViewDelegate <NSObject>

-(void)reloadTable;

@end

@interface LECLectureViewModel : LECBaseViewModel <AudioServicePlaybackDelegate>

+(LECLectureViewModel *)viewModelWithLecture:(Lecture *)lecture;

@property id<PlaybackViewDelegate> delegate;
@property NSString *icon;
@property Lecture *lecture;
@property NSMutableArray *tags;
@property (nonatomic) NSString *recordingPath;
@property BOOL canTag;
@property long currentTag;
@property double currentTagStartTime;
@property double currentTagFinishTime;

@property NSString *courseName;

// instance of AVAudio or Audio service?
-(void) prepareForRecordingAudio;
-(void) startRecordingAudio;
-(void) stopRecordingAudio;
-(void) addTagToCurrentTime;

-(void) prepareForPlaybackWithCompletion:(void (^)(void))block;
-(void) startAudioPlayback;
-(void) stopAudioPlayback;

-(BOOL) audioIsPlaying;
-(void) goToTag:(NSInteger)index;
-(BOOL) insertTagAtCurrentTime;
@end
