//
//  AudioRing.h
//  SharedLibrary
//
//  Created by Chih-Wei on 4/27/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __SharedLibrary__AudioRing__
#define __SharedLibrary__AudioRing__

#include <iostream>

#endif /* defined(__SharedLibrary__AudioRing__) */

class CRingModulator
{
public:
    CRingModulator(int iNumChannel);
    ~CRingModulator();
    
    void setModFreq(float fModFreq);
    void setModFreq2(float fModFreq2);
    void setModDepth(float fModDepth);
    void setSampleRate(float fSampleRate);
    void process(float **ppfInputBuffer, float **ppfOutputBuffer, int iBlockSize);
    
private:
    float m_fModFreq;
    float m_fModFreq2;
    float m_fModDepth;
    int m_iTimeIdx;
    int m_iNumChannel;
    float m_fSampleRate;
    float m_fModGain;
};