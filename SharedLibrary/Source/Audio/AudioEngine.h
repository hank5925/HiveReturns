//
//  AudioEngine.h
//  HiveReturn
//
//  Created by Govinda Ram Pingali on 3/8/14.
//  Modified by Chih-Wei Wu
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __HiveReturn__AudioEngine__
#define __HiveReturn__AudioEngine__

#include "SharedLibraryHeader.h"
#include "AudioStream.h"

class AudioEngine

{
public:
    
    AudioEngine();
    ~AudioEngine();
    
    void startAudioStreaming();
    void stopAudioStreaming();
    void setEffectParam(int effectID, int parameterID, float value);
    void setEffectStatus(int effectID);
    void setMicGain(float micGainValue);
    
    
private:
    String filePath;
    ScopedPointer<AudioStream>  liveAudioStream;
        
};

#endif /* defined(__HiveReturn__AudioEngine__) */
