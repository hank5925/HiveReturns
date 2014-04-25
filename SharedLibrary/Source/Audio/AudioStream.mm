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
    
    // initial values
    vibratoStatus = false;
    delayStatus   = false;
    lowpassStatus = false;
    iNumChannel = 2;
    inputMicGain = 1.0;
    
    // instantiate my effects here
    CVibrato::createInstance(pMyVibrato);
    pMyDelay = new CDelay(iNumChannel);
    pMyLPF   = new CLPF(iNumChannel);

}

AudioStream::~AudioStream()
{
    sharedAudioDeviceManager->removeAudioCallback(this);
    
    // destroy instances here
    CVibrato::destroyInstance(pMyVibrato);
    delete pMyDelay;
    delete pMyLPF;
}

void AudioStream::audioDeviceAboutToStart(AudioIODevice* device)
{
    // init effects
    fSampleRate = device->getCurrentSampleRate();
    pMyVibrato->initInstance(0.25, fSampleRate , iNumChannel);
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
            if (parameterID == 2)
            {
                paramValue2 = value * (10);
                pMyVibrato->setParam(CVibrato::kParamModFreqInHz, paramValue2);
            }
            break;
            
        case 2: //delay //need to fix the mapping values
            if (parameterID == 1)
            {
                paramValue1 = value * (1.0); //delay time in sec
                pMyDelay->setDelayTime(paramValue1);

            }
            if (parameterID == 2)
            {
                paramValue2 = value * (0.8); //feedback gain
                pMyDelay->setFeedback(paramValue2);
            }
            
        case 3: //lowpass filter
            if (parameterID == 1)
            {
                paramValue1 = value * 0.5;
                pMyLPF->setCutoff(paramValue1);
            }
            if (parameterID == 2)
            {
                paramValue2 = value * 0.05; //no mapping
                //pMyLPF->setCutoff(paramValue2);
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
        case 3:
            lowpassStatus = !lowpassStatus;
            break;
            
        default:
            break;
    }
}

void AudioStream::setMicGain(float newGainValue)
{
    inputMicGain = newGainValue;
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
    for (int sample = 0; sample < blockSize; sample++)
    {
        for (int channel = 0; channel < totalNumOutputChannels; channel++)
        {
            outputChannelData[channel][sample] = inputMicGain * inputChannelData[channel][sample];
        }
    }
    
    
    //  ================== process chain start ======================
    // ======== effect 1
    if (vibratoStatus)
    {
        pMyVibrato->process(outputChannelData, outputChannelData, blockSize);
    }

    
    // ======== effect 2
    if (delayStatus)
    {
        pMyDelay->process(outputChannelData, blockSize, false);
    }
    
    // ======== effect 3
    if (lowpassStatus)
    {
        pMyLPF->process(outputChannelData, outputChannelData, blockSize);
    }
    

    //  ================== process chain end ======================
    
}





