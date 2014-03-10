//
//  AudioStream.cpp
//  SharedLibrary
//
//  Created by Govinda Ram Pingali on 3/7/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioStream.h"


AudioStream::AudioStream()
{
    //--- Audio Device Settings ---//
    sharedAudioDeviceManager->getAudioDeviceSetup(deviceSetup);
    
    // instantiate my effects here
}

AudioStream::~AudioStream()
{
    sharedAudioDeviceManager->removeAudioCallback(this);
}

void AudioStream::audioDeviceAboutToStart(AudioIODevice* device)
{
    
}

void AudioStream::audioDeviceStopped()
{
    
}

//==============================================================================
// Process Block
// !!! Running on Audio Thread
//==============================================================================

void AudioStream::audioDeviceIOCallback( const float** inputChannelData,
                                        int totalNumInputChannels,
                                        float** outputChannelData,
                                        int totalNumOutputChannels,
                                        int blockSize)
{
    // switch effect cases here
    
    // if id/ status
    // process (tmp out)
    // else bypass (tmp out)
    
    // process by block
    
    for (int sample = 0; sample < blockSize; sample++)
    {
        for (int channel = 0; channel < totalNumOutputChannels; channel++)
        {
            

            
            
            outputChannelData[channel][sample] = inputChannelData[channel][sample];
        }
    }
    
    
}





