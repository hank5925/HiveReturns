//
//  AudioStream.h
//  HiveReturn
//
//  Created by Govinda Ram Pingali on 3/7/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __HiveReturn__AudioStream__
#define __HiveReturn__AudioStream__

#include "SharedLibraryHeader.h"
#include "AudioEffects.h"
#include <cfloat>

class AudioStream   :   public AudioIODeviceCallback
{
    
public:
    
    
    AudioStream();
    ~AudioStream();
    
    
    void audioDeviceIOCallback(const float** inputChannelData,
							   int totalNumInputChannels,
							   float** outputChannelData,
							   int totalNumOutputChannels,
							   int blockSize) override;
	
	void audioDeviceAboutToStart (AudioIODevice* device) override;
    void audioDeviceStopped() override;
    void setEffectParam(int effectID, int parameterID, float value);
    void setEffectStatus(int effectID);
    void setMicGain(float newGainValue);
    
private:
    
    AudioDeviceManager::AudioDeviceSetup        deviceSetup;
    CVibrato *pMyVibrato;
    bool  vibratoStatus;
    CDelay *pMyDelay;
    bool  delayStatus;
    CLPF   *pMyLPF;
    bool  lowpassStatus;
    CRingModulator *pMyRingModulator;
    bool  ringModulatorStatus;
    
    
    float fSampleRate;
    int   iNumChannel;
    float **ppfOutputBuffer;
    float inputMicGain;
    
    float paramValue1;
    float paramValue2;
    float paramValue3;
    // alloc my effects here
    
};

#endif /* defined(__HiveReturn__AudioStream__) */
