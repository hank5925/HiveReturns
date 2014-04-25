//
//  AudioLowpass.cpp
//  SharedLibrary
//
//  Created by Chih-Wei on 4/24/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioLowpass.h"

#define PI 3.1415926

CLPF::CLPF(int iNumChannel):
m_fCutoffFreq(1), m_iNumChannel(iNumChannel), m_fApy(0), m_fCParam(0)
{
    m_pfPreviousValues = new float [m_iNumChannel];
    m_pfNewValues      = new float [m_iNumChannel];
    this->resetInstance();
}


CLPF::~CLPF()
{
    delete [] m_pfPreviousValues;
    delete [] m_pfNewValues;
}


void CLPF::setCutoff(float fCutoffFreq)
{
    m_fCutoffFreq = fCutoffFreq;
    m_fCParam = (tan(PI * m_fCutoffFreq * 0.5) - 1) / (tan(PI * m_fCutoffFreq * 0.5) + 1);
}


void CLPF::process(float **ppfInputBuffer, float **ppfOutputBuffer, int iBlockSize)
{
    
    
    
    for (int i = 0; i < iBlockSize; i++)
    {
        for (int c = 0; c < m_iNumChannel; c++)
        {
            m_pfNewValues[c] = ppfInputBuffer[c][i] - m_fCParam * m_pfPreviousValues[c];
            m_fApy = m_fCParam * m_pfNewValues[c] + m_pfPreviousValues[c];
            m_pfNewValues[c] = m_pfPreviousValues[c];
            ppfOutputBuffer[c][i] = 0.5 * (ppfInputBuffer[c][i] + m_fApy);
            
        }
    }
}

void CLPF::resetInstance()
{
    m_fCutoffFreq = 1.0;
    
    for (int i = 0; i < m_iNumChannel; i++)
    {
        m_pfPreviousValues[i] = 0;
        m_pfNewValues[i] = 0;
    }
}




