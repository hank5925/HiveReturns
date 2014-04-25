//
//  AudioDelay.cpp
//  SharedLibrary
//
//  Created by Chih-Wei on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioDelay.h"

CDelay::CDelay(int numChannels):
numChannels(numChannels)
{
	feedBack = 0;
	wetDry = 0;
	ringBuffer = new CRingBuffer<float> *[numChannels];
	for (int n = 0; n < numChannels; n++)
	{
		ringBuffer[n]	= new CRingBuffer<float>((int)(2 * MAX_DELAY));
        // set indices and buffer contents to zero:
		ringBuffer[n]->resetInstance();
	};
    
	initDefaults();
}

CDelay::~CDelay()
{
    for (int n = 0; n < numChannels; n++)
	{
		delete ringBuffer[n];
	}
    delete ringBuffer;
}


void CDelay::initDefaults()
{
	setFeedback(0.5);
	setDelayTime(0.1);
	setWetDry(0.5);
}

void CDelay::setSampleRate(float smplRate)
{
	if (smplRate >0)
		sampleRate = smplRate;
    this->setMaxDelay(round(MAX_DELAY/smplRate)); // in second
}

void CDelay::setChanNum(int numChan)
{
	if (numChan >= 1)
		numChannels = numChan;
}

void CDelay::setDelayTime(float delay)
{
    delayTime = delay;
    for (int c = 0 ; c < numChannels; c++)
    {
        ringBuffer[c]->setReadIdx(ringBuffer[c]->getWriteIdx()- delayTime * sampleRate);
    }
}

void CDelay::setWetDry(float mix)
{
	if (abs(mix) <= 1)
		wetDry = mix;
}

void CDelay::setFeedback(float fdBack)
{
	if (fdBack >= 0 && fdBack <= 1)
		feedBack = fdBack;
}

void CDelay::setMaxDelay(float delayTimeInS)
{
	if (delayTimeInS > 0)
		maxDelayTimeInS = delayTimeInS;
}

void CDelay::setParam(int type, float value)
{
	switch(type)
	{
		case 0:
			// delayTime_target	= value;
			if (value > 0)
				delayTime = value;
            break;
		case 1:
			// feedBack_target		= value;
			if (value >= 0 && value <= 1)
				feedBack = value;
            break;
		case 2:
			// wetDry_target		= value;
			if (abs(value) <= 1)
				wetDry = value;
            break;
		default: break;
	};
}

void CDelay::process(float **inputBuffer, int numFrames, bool bypass)
{
	
	// for each channel, for each sample:
	for (int i = 0; i < numFrames; i++)
	{
		for (int c = 0; c < numChannels; c++)
		{            
            // My fixed simple delay (CW)
            inputBuffer[c][i] = inputBuffer[c][i] + getFeedback() * ringBuffer[c]->getPostInc();
            
			ringBuffer[c]->putPostInc(inputBuffer[c][i]);
		};
	};
}


int CDelay::getSampleRate()
{
	return sampleRate;
}

float CDelay::getWetDry()
{
	return wetDry;
}

float CDelay::getDelay()
{
	return delayTime;
}

float CDelay::getFeedback()
{
	return feedBack;
}

float CDelay::getMaxDelay()
{
	return maxDelayTimeInS;
}

void CDelay::reset()
{
    for (int c = 0; c < numChannels; c++)
    {	
        ringBuffer[c]->resetInstance();
    };
}