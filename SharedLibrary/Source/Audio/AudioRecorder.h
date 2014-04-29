//
//  AudioRecorder.h
//  HiveReturn
//
//  Created by Chih-Wei on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __HiveReturn__AudioRecorder__
#define __HiveReturn__AudioRecorder__

#include <iostream>

#endif /* defined(__HiveReturn__AudioRecorder__) */

#include "SharedLibraryHeader.h"


class AudioRecorder : public AudioIODeviceCallback
{
public:
    
    AudioRecorder();
    ~AudioRecorder();
    
    void startRecording (String filePath);
    void stopRecording ();
//    void startPlaying (const File &currentFile);
//    void stopPlaying ();
    
    
// ===============================================================
    void audioDeviceAboutToStart (AudioIODevice* device) override;
    
    void audioDeviceIOCallback (const float** inputChannelData, int numInputChannels, float** outputChannelData, int numOutputChannels, int numSamples) override;
    void audioDeviceStopped () override;
    
    
    
    
private:
    double sampleRate;
    bool   recordingStatus;
    bool   playingStatus;
    ScopedPointer<AudioSampleBuffer> buffer;
    ScopedPointer<AudioFormatWriter::ThreadedWriter> threadedWriter;

    CriticalSection writerLock;
    AudioFormatWriter::ThreadedWriter* volatile activeWriter;

    TimeSliceThread backgroundThread;
    //TimeSliceThread playbackThread;
    int64 nexSampleNum;
    int   nexSampleNumInBuffer;
    ScopedPointer<AudioFormatReader> reader;
    AudioDeviceManager::AudioDeviceSetup deviceSetup;
    
    
    
};