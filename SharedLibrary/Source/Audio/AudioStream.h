//
//  AudioStream.h
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/7/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__AudioStream__
#define __SharedLibrary__AudioStream__

#include "SharedLibraryHeader.h"

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
    
    
    
private:
    
    AudioDeviceManager::AudioDeviceSetup        deviceSetup;
    
};

#endif /* defined(__SharedLibrary__AudioStream__) */
