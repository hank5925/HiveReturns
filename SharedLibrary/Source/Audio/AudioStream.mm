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
    vibratoStatus = false;
    delayStatus   = false;
    
    // instantiate my effects here
    CVibrato::createInstance(pMyVibrato);
    iNumChannel = 2;
    pMyDelay = new CDelay(iNumChannel);

}

AudioStream::~AudioStream()
{
    sharedAudioDeviceManager->removeAudioCallback(this);
    
    // destroy instances here
    CVibrato::destroyInstance(pMyVibrato);
    delete pMyDelay;
}

void AudioStream::audioDeviceAboutToStart(AudioIODevice* device)
{
    // init effects
    fSampleRate = device->getCurrentSampleRate();
    pMyVibrato->initInstance(0.25, fSampleRate , iNumChannel);
    pMyDelay->initDefaults();
    pMyDelay->setSampleRate(fSampleRate);
    
    
}

void AudioStream::audioDeviceStopped()
{
    
}

void AudioStream::setEffectParam(int effectID, int parameterID, float value)
{
    switch (effectID)
    {
        case 1: //vibrato
            if (parameterID == 1)
            {
                //value = 0~1
                paramValue1 = value * (0.01);
                pMyVibrato->setParam(CVibrato::kParamModWidthInS, paramValue1);
            }
            else if (parameterID == 2)
            {
                paramValue2 = value * (10);
                pMyVibrato->setParam(CVibrato::kParamModFreqInHz, paramValue2);
            }
            break;
            
        case 2: //delay
            if (parameterID == 1)
            {
                paramValue1 = value * (1);
                pMyDelay->setParam(0, paramValue1);
            }
            else if (parameterID == 2)
            {
                paramValue2 = value * (0.8);
                pMyDelay->setParam(1, paramValue2);
            }
            
        default:
            break;
    }
}

void AudioStream::setEffectStatus(int effectID)
{
    switch (effectID)
    {
        case 1:
            vibratoStatus = !vibratoStatus;
            break;
        case 2:
            delayStatus = !delayStatus;
            break;
        default:
            break;
    }
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
    // put inputChannelData into buffer
    
    ppfInputBuff = new float *[totalNumInputChannels];
    ppfOutputBuff = new float *[totalNumInputChannels];
    for (int i = 0; i < totalNumInputChannels; i++)
    {
        ppfInputBuff[i] = new float [blockSize];
        ppfOutputBuff[i] = new float [blockSize];
    }
    for (int sample = 0; sample < blockSize; sample++)
    {
        for (int channel = 0; channel < totalNumOutputChannels; channel++)
        {
            
            ppfInputBuff[channel][sample] = inputChannelData[channel][sample];
        }
    }
    
    
    //  ================== process chain start ======================
    // ======== effect 1
    if (vibratoStatus)
    {
        pMyVibrato->process(ppfInputBuff, ppfOutputBuff, blockSize);
    }
    else
    {
        for (int sample = 0; sample < blockSize; sample++)
        {
            for (int channel = 0; channel < totalNumOutputChannels; channel++)
            {
                ppfOutputBuff[channel][sample] = ppfInputBuff[channel][sample];
            }
        }
    }
    
    // ======== effect 2
    if (delayStatus)
    {
        pMyDelay->process(ppfOutputBuff, blockSize, false);
    }

    //  ================== process chain end ======================
    
    
    for (int sample = 0; sample < blockSize; sample++)
    {
        for (int channel = 0; channel < totalNumOutputChannels; channel++)
        {
            
            outputChannelData[channel][sample] = ppfOutputBuff[channel][sample];
        }
    }
    
    // clean up the buffer
    for (int i = 0; i < totalNumInputChannels; i++)
    {
        delete ppfInputBuff[i];
        delete ppfOutputBuff[i];
    }
    delete ppfInputBuff;
    delete ppfOutputBuff;

    
}





