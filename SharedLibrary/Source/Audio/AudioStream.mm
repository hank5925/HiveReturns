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
    CVibrato::createInstance(pMyVibrato);

}

AudioStream::~AudioStream()
{
    sharedAudioDeviceManager->removeAudioCallback(this);
    
    // destroy instances here
    CVibrato::destroyInstance(pMyVibrato);
}

void AudioStream::audioDeviceAboutToStart(AudioIODevice* device)
{
    // init effects
    iNumChannel = 2;
    fSampleRate = device->getCurrentSampleRate();
    pMyVibrato->initInstance(0.25, fSampleRate , iNumChannel);
    pMyVibrato->setParam(CVibrato::kParamModFreqInHz, 5);
    pMyVibrato->setParam(CVibrato::kParamModWidthInS, 0.05);
    
    
}

void AudioStream::audioDeviceStopped()
{
    
}

void setEffectParam(int effectID, int parameterID, float value)
{
    
  
    
}












//==============================================================================
// Process Block
// !!! Running on Audio Thread
//==============================================================================

void AudioStream::audioDeviceIOCallback(const float** inputChannelData,
                                        int totalNumInputChannels,
                                        float** outputChannelData,
                                        int totalNumOutputChannels,
                                        int blockSize)
{
    // switch effect cases here
    
    // if id/ status
    // process (tmp out)
    // else bypass (tmp out)
    
    ppfInputBuff = new float *[totalNumInputChannels];
    for (int i = 0; i < totalNumInputChannels; i++)
    {
        ppfInputBuff[i] = new float [blockSize];
    }
    
    for (int sample = 0; sample < blockSize; sample++)
    {
        for (int channel = 0; channel < totalNumOutputChannels; channel++)
        {
            
            ppfInputBuff[channel][sample] = inputChannelData[channel][sample];
        }
    }
    
    
    // process by block
    pMyVibrato->process(ppfInputBuff, outputChannelData, blockSize);
    
    
    
    
    // clean up the buffer
    for (int i = 0; i < totalNumInputChannels; i++)
    {
        delete ppfInputBuff[i];
    }
    delete ppfInputBuff;
    
//    for (int sample = 0; sample < blockSize; sample++)
//    {
//        for (int channel = 0; channel < totalNumOutputChannels; channel++)
//        {
//            
//            outputChannelData[channel][sample] = inputChannelData[channel][sample];
//        }
//    }
//    
    
}





