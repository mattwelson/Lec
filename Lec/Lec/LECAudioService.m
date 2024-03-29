//
//  LECAudioService.m
//  Lec
//
//  Created by Matt Welson on 1/02/14.
//  Copyright (c) 2014 South45. All rights reserved.
//

#import "LECAudioService.h"
#import "LECDefines.h"

@implementation LECAudioService {
    AVAudioSession *session;
    NSURL *recordingPath;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    void (^playbackFinished)(void);
    NSTimer *timer;
}

static LECAudioService *sharedService;

+ (LECAudioService *)sharedAudioService
{
    if (sharedService) return sharedService;
    
    sharedService = [[LECAudioService alloc] init];
    return sharedService;
}

#pragma mark Recording
-(void) setupAudioRecordingForPath:(NSString *)path
{
    session = [AVAudioSession sharedInstance];
    
    NSError *error;
    [session setCategory:AVAudioSessionCategoryRecord withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
    
    recordingPath = [self recordingPath:path];
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordingPath settings:[self audioRecordingSettings] error:&error];
    if (error) {
        @throw [NSException exceptionWithName:@"Audio Recording failed" reason:@"Dammit" userInfo:nil];
    }
    
    audioRecorder.delegate = self;
    
    if (![audioRecorder prepareToRecord])
    {
        @throw [NSException exceptionWithName:@"AudioPlayerNotReady" reason:@"Not sure" userInfo:nil];
    }
}

-(void) startRecording
{
    if (![audioRecorder record])
    {
        @throw [NSException exceptionWithName:@"Recording failed to start" reason:@"Reason? Don't know" userInfo:nil];
    }
}

-(void) stopRecording
{
    [audioRecorder stop];
}

#pragma mark Playback
-(void) setupAudioPlayback:(NSString *)path withCompletion:(void (^)(void))block
{
    NSError *error;
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    recordingPath = [self recordingPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordingPath error:&error];
    audioPlayer.delegate = self;
    playbackFinished = block;
    if (error || !audioPlayer) // if things are not initialised properly
    {
        @throw [NSException exceptionWithName:@"Preparing audio for playback" reason:@"Dammit" userInfo:nil];
    }
}

-(void) startPlayback
{
    [session setActive:YES error:nil];
    if ([audioPlayer prepareToPlay]) {
        audioPlayer.enableRate = YES;
        [audioPlayer play];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlayStateNotification object:self];
        assert([audioPlayer isPlaying]); // TODO: Take out? Once at a production stage
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(updateProgress)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    }
    else {
        @throw [NSException exceptionWithName:@"Audio player!" reason:@"Oh no!" userInfo:nil];
    }
}

-(void) stopPlayback
{
    [audioPlayer stop];
    assert(![audioPlayer isPlaying]);
}

-(void)pausePlayback{
    [audioPlayer pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayStateNotification object:self];
}


-(void)speedUpPlaybackRate{
    [audioPlayer setRate:2.0];
    if (!audioPlayer.isPlaying) {
        [self startPlayback];
    }
    else [audioPlayer play];
}

-(void)updateProgress
{
    double time = [audioPlayer currentTime];
    if (time > 0 && time < [self getRecordingLength] && [audioPlayer isPlaying]){
        [self.delegate playbackIsAtTime:[audioPlayer currentTime]];
    }
}

-(void)normalPlaybackRate{
    [audioPlayer setRate:1.0];
    if (!audioPlayer.isPlaying) {
        [self startPlayback];
    }
    else [audioPlayer play];
}

-(BOOL) isAudioPlaying
{
    return [audioPlayer isPlaying];
}

-(void)rewindPlaybackRate{
    [audioPlayer setRate:-1.0];
    if (!audioPlayer.isPlaying) {
        [self startPlayback];
    }
    else [audioPlayer play];
}

-(BOOL)isPlaying{
    if ([audioPlayer isPlaying]) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark Tag Stuff
-(void)goToTime:(NSNumber *)time
{
//    if (!audioPlayer.playing) [audioPlayer play];
    if (!audioPlayer.playing) [self startPlayback];

    audioPlayer.currentTime = [time doubleValue];
}

-(NSNumber *) getCurrentTime
{
    if (audioPlayer && [audioPlayer isPlaying])
    {
        return [NSNumber numberWithDouble:[audioPlayer currentTime]];
    } else if (audioRecorder && [audioRecorder isRecording]) {
        return [NSNumber numberWithDouble:[audioRecorder currentTime]];
    }
    @throw [NSException exceptionWithName:@"WhatTheFuckException" reason:@"Nothing is playing or recording" userInfo:nil];
}

-(double)getRecordingLength
{
    return [audioPlayer duration];
}

#pragma mark - Playback
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [timer invalidate];
    playbackFinished(); // this is a block, that was pretty confusing!
}

#pragma mark Private
-(NSURL *)recordingPath:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error;
    
    NSURL *documentFolderURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:Nil create:NO error:&error];
    if (error) @throw [NSException exceptionWithName:@"File Creation" reason:@"Failed to generate URL" userInfo:nil];
    
    return [documentFolderURL URLByAppendingPathComponent:path];
}

-(NSDictionary *)audioRecordingSettings {
    return @{
             AVFormatIDKey: @(kAudioFormatMPEG4AAC),
             AVSampleRateKey: @(44100.0f),
             AVNumberOfChannelsKey: @1,
             AVEncoderAudioQualityKey: @(AVAudioQualityLow)
             };
}

@end
