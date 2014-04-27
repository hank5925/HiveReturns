//
//  AudioPitchShift.cpp
//  SharedLibrary
//
//  Created by Chih-Wei on 4/26/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioPitchShift.h"
#include <cmath>

CPitchShift::CPitchShift(int iNumChannel):
m_iNumChannel(iNumChannel), m_fAlpha(1.0)
{
    m_iN2 = 10;
    m_iN1 = 10;
    m_fFactor = 1.0;
    ppfExtendedFrames = new float *[m_iNumChannel];
    for (int i = 0; i < m_iNumChannel; i++)
    {
        ppfExtendedFrames[i] = new float [MAX_FRAMES];
    }
}

CPitchShift::~CPitchShift()
{
    for (int i = 0; i < m_iNumChannel; i++)
    {
        delete [] ppfExtendedFrames[i];
    }
    delete ppfExtendedFrames;
}

void CPitchShift::process(float **ppfInputBuffer, float **ppfOutputBuffer, int iBlockSize)
{
    if (m_fAlpha <= 1.0)
    {
        m_fFactor = 1.0 / m_fAlpha;
        m_iN1 = round(m_iN2 * m_fFactor);
        int count = 0;
        for (int i = 0 ; i < iBlockSize; i++)
        {
            for (int c = 0; c < m_iNumChannel; c++)
            {
                
                for (int k = 0; k < (int)m_iN1; k++)
                {
                    ppfExtendedFrames[c][count] = ppfInputBuffer[c][i];
                    count = count + 1;
                }
            }
        }
        
        int exLength = count;
        count = 0;
        for (int i = 0 ; i < exLength; i++)
        {
            for (int c = 0; c < m_iNumChannel; c++)
            {
                if (i % m_iN2 == 0) //resample
                {
                    ppfExtendedFrames[c][count] = ppfExtendedFrames[c][i];
                    count = count + 1;
                }
            }
        }
        
        for (int i = 0; i < iBlockSize; i++)
        {
            for (int c = 0; c < m_iNumChannel; c++)
            {
                ppfOutputBuffer[c][i] = ppfExtendedFrames[c][i];
            }
        }
        
        
        
    }
    else if (m_fAlpha > 1.0)
    {
        int count = 0;
        m_fFactor = 1.0 / m_fAlpha;
        m_iN1 = ceil(m_iN2 * m_fFactor);
        for (int i = 0 ; i < iBlockSize; i++)
        {
            for (int c = 0; c < m_iNumChannel; c++)
            {
                
                for (int k = 0; k < (int)m_iN1; k++)
                {
                    ppfExtendedFrames[c][count] = ppfInputBuffer[c][i];
                    count = count + 1;
                }
            }
        }
        
        int exLength = count;
        count = 0;
        for (int i = 0 ; i < exLength; i++)
        {
            for (int c = 0; c < m_iNumChannel; c++)
            {
                if (i % m_iN2 == 0) //resample
                {
                    ppfExtendedFrames[c][count] = ppfExtendedFrames[c][i];
                    count = count + 1;
                }
            }
        }
        
        int sampledLength = count;
        int mTimes = ceil(iBlockSize / sampledLength);
        for (int i = 0; i < mTimes; i++)
        {
            for (int j = 0 ; j < sampledLength; j ++)
            {
                for (int c = 0; c < m_iNumChannel; c++)
                {
                    ppfExtendedFrames[c][i + j] = ppfExtendedFrames[c][j];
                }
            }
        }
        
        for (int i = 0; i < iBlockSize; i++)
        {
            for (int c = 0; c < m_iNumChannel; c++)
            {
                ppfOutputBuffer[c][i] = ppfExtendedFrames[c][i];
            }
        }
    }
}

void CPitchShift::setAlpha(float fNewAlpha)
{
    m_fAlpha = fNewAlpha;
}

void CPitchShift::resetInstance()
{
    
}






