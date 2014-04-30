//
//  AudioDelay.h
//  HiveReturn
//
//  Created by Chih-Wei on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __HiveReturn__AudioDelay__
#define __HiveReturn__AudioDelay__

#if !defined(__CDelay_hdr__)
#define __CDelay_hdr__

#include "RingBuffer.h"
#define MAX_DELAY 88200

/*	Fractional Delay
 ----------------
 Paramaters:
 - Delay time
 - Feedback
 - Wet/Dry Mix
 */

class CDelay
{
public:
    
	CDelay(int numChannels);
    
    
    enum DelayParam_t
    {
        kParamDelayTimeInS,
        kParamFeedbackGain,
        kParamWetDry,
        
        kNumDelayParams
    };
    
	// set:
	void setParam(/*hFile::enumType type*/ DelayParam_t type, float value);
    
	void prepareToPlay(int sampleRate, int bufferSize);
	void finishPlaying();
    
	void initDefaults();
	void setSampleRate(float sampleRate);
	void setChanNum(int numChan);
	void setDelayFeedback(float feedback);
	void setDelayTime(float delay);
	void setWetDry(float mix);
	void setMaxDelay(float delay);
	void setFeedback(float fdBack);
	float getMaxDelay();
	float getWetDry();
	float getDelay();
	float getFeedback();
	int   getSampleRate();
	// process:
	void process(float **inputBuffer, int numFrames, bool bypass);
    
	void reset();
	~CDelay ();
    
private:
    
	CRingBuffer<float> **ringBuffer;
    
	float sampleRate;
	int numChannels;
    
	float feedBack;
	float wetDry;
	float delayTime;
	float maxDelayTimeInS;
};

#endif

#endif /* defined(__HiveReturn__AudioDelay__) */
