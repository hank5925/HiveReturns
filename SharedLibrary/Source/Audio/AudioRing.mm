//
//  AudioRing.cpp
//  SharedLibrary
//
//  Created by Chih-Wei on 4/27/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

// Note that this is a "double" ring modulator (which will generate wierd sounds!!!)
// to modify this, you may simple set m_fModFreq2 = 0 then it's a normal ring modulator



#include "AudioRing.h"
#include <cmath>
#define PI 3.1415926

CRingModulator::CRingModulator(int iNumChannel):
m_fModFreq(0.0), m_fModDepth(1.0), m_iTimeIdx(0), m_fModGain(1)
{
    m_iNumChannel = iNumChannel;
    m_fSampleRate = 0;
    m_fModFreq2 = 0;
}

CRingModulator::~CRingModulator()
{
    
}

void CRingModulator::setModFreq(float fModFreq)
{
    m_fModFreq = fModFreq;
}

void CRingModulator::setModFreq2(float fModFreq2)
{
    m_fModFreq2 = fModFreq2;
}

void CRingModulator::setModDepth(float fModDepth)
{
    m_fModDepth = fModDepth;
}

void CRingModulator::setSampleRate(float fSampleRate)
{
    m_fSampleRate = fSampleRate;
}


void CRingModulator::process(float **ppfInputBuffer, float **ppfOutputBuffer, int iBlockSize)
{
    for (int i = 0; i < iBlockSize; i++)
    {
        m_iTimeIdx++;
        m_iTimeIdx = (m_iTimeIdx % (int)m_fSampleRate);

        m_fModGain = fabs(m_fModDepth * (cos(2.0 * PI * m_fModFreq2/m_fSampleRate * m_iTimeIdx)) * sin(2.0 * PI * m_fModFreq / m_fSampleRate * m_iTimeIdx));
        
        for (int c = 0; c < m_iNumChannel; c++)
        {
            ppfOutputBuffer[c][i] = (1 - m_fModDepth) * ppfInputBuffer[c][i] + m_fModGain * ppfInputBuffer[c][i];

        }
    }
    
}



