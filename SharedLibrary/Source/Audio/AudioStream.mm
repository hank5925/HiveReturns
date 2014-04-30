//
//  AudioStream.cpp
//  HiveReturn
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
    vibratoStatus    = false;
    delayStatus      = false;
    lowpassStatus    = false;
    ringModulatorStatus = false;
    iNumChannel = 2;
    inputMicGain = 1.0;
    
    // instantiate my effects here
    CVibrato::createInstance(pMyVibrato);
    pMyDelay = new CDelay(iNumChannel);
    pMyLPF   = new CLPF(iNumChannel);
    pMyRingModulator = new CRingModulator(iNumChannel);

}

AudioStream::~AudioStream()
{
    sharedAudioDeviceManager->removeAudioCallback(this);
    
    // destroy instances here
    CVibrato::destroyInstance(pMyVibrato);
    delete pMyDelay;
    delete pMyLPF;
    delete pMyRingModulator;
}

void AudioStream::audioDeviceAboutToStart(AudioIODevice* device)
{
    // init effects
    fSampleRate = device->getCurrentSampleRate();
    pMyVibrato->initInstance(0.25, fSampleRate , iNumChannel);
    pMyDelay->setSampleRate(fSampleRate);
    pMyRingModulator->setSampleRate(fSampleRate);
}

void AudioStream::audioDeviceStopped()
{
    
}

void AudioStream::setEffectParam(int effectID, int parameterID, float value)
{
    switch (effectID)
    {
        case 1: //vibrato
            if (parameterID == CVibrato::kParamModFreqInHz)
            {
                //value = 0~1
                paramValue1 = value * (0.01);
                pMyVibrato->setParam(CVibrato::kParamModWidthInS, paramValue1);
            }
            if (parameterID == CVibrato::kParamModWidthInS)
            {
                paramValue2 = value * (10);
                pMyVibrato->setParam(CVibrato::kParamModFreqInHz, paramValue2);
            }
            break;
            
        case 2: //delay //need to fix the mapping values
            if (parameterID == CDelay::kParamDelayTimeInS)
            {
                paramValue1 = value * (1.0); //delay time in sec
                pMyDelay->setDelayTime(paramValue1);

            }
            if (parameterID == CDelay::kParamFeedbackGain)
            {
                paramValue2 = value * (0.8); //feedback gain
                pMyDelay->setFeedback(paramValue2);
            }
            
        case 3: //lowpass filter
            if (parameterID == 0)
            {
                paramValue1 = value * 0.7;
                pMyLPF->setCutoff(paramValue1);
            }
            if (parameterID == 1)
            {
                paramValue2 = value * 0.05; //no mapping
                //pMyLPF->setCutoff(paramValue2);
            }
            
        case 4: //Ring Modulator
            if (parameterID == 0)
            {
                paramValue1 = 880 * value;
                pMyRingModulator->setModFreq2(paramValue1);
            }
            if (parameterID == 1)
            {
                paramValue2 = 2 + value * 6;
                pMyRingModulator->setModFreq(paramValue2);
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
        case 4:
            ringModulatorStatus = !ringModulatorStatus;
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
    
    // ======== effect 4
    if (ringModulatorStatus)
    {
        pMyRingModulator->process(outputChannelData, outputChannelData, blockSize);
    }
    

    //  ================== process chain end ======================
    
}





