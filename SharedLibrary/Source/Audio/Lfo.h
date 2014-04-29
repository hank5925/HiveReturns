//
//  Lfo.h
//  HiveReturn
//
//  Created by Chih-Wei on 3/10/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#ifndef __HiveReturn__Lfo__
#define __HiveReturn__Lfo__

#if !defined(__Lfo_hdr__)
#define __Lfo_hdr__

#define _USE_MATH_DEFINES
#include <math.h>

#include "ErrorDef.h"
#include "RingBuffer.h"
#include "SignalGen.h"
class CLfo
{
public:
    CLfo(float fSampleRate) :
    m_fSampleRate(fSampleRate),
    m_fReadIndex(0),
    m_eType(kSine),
    m_pCRingBuff(0)
    {
        for (int i = 0; i < kNumLfoParams; i++)
            m_afParam[i]    = 0;
        
        m_pCRingBuff = new CRingBuffer<float>(m_kiBufferLength);
        
        setLfoType(kSine);
    }
    virtual ~CLfo()
    {
        delete m_pCRingBuff;
    }
    
    enum LfoType_t
    {
        kSine,
        kSaw,
        kRect,
        
        kNumLfoTypes
    };
    enum LfoParam_t
    {
        kLfoParamAmplitude,
        kLfoParamFrequency,
        
        kNumLfoParams
    };
    Error_t setLfoType (LfoType_t eType)
    {
        m_eType = eType;
        computeWaveTable();
        return kNoError;
    }
    Error_t setParam(LfoParam_t eParam, float fValue)
    {
        m_afParam[eParam]   = fValue;
        
        return kNoError;
    }
    float getParam (LfoParam_t eParam) const
    {
        return m_afParam[eParam];
    }
    
    float getNext()
    {
        float fValue = m_afParam[kLfoParamAmplitude] * m_pCRingBuff->get(m_fReadIndex);
        m_fReadIndex = m_fReadIndex + m_afParam[kLfoParamFrequency]/m_fSampleRate * m_kiBufferLength;
        
        if (m_fReadIndex >= m_kiBufferLength)
            m_fReadIndex -= m_kiBufferLength;
        return fValue;
    }
private:
    void computeWaveTable ()
    {
        float *pfBuff = new float [m_kiBufferLength];
        switch (m_eType)
        {
            case kSine:
                CSignalGen::generateSine (pfBuff, 1.F, 1.F*m_kiBufferLength, m_kiBufferLength);
                break;
            case kSaw:
                CSignalGen::generateSaw (pfBuff, 1.F, 1.F*m_kiBufferLength, m_kiBufferLength);
                break;
            case kRect:
                CSignalGen::generateRect (pfBuff, 1.F, 1.F*m_kiBufferLength, m_kiBufferLength);
                break;
        }
        
        m_pCRingBuff->put(pfBuff, m_kiBufferLength);
        
        delete [] pfBuff;
    }
    static const int m_kiBufferLength = 4096;
    
    float m_fSampleRate;
    float m_fReadIndex;
    float m_afParam[kNumLfoParams];
    
    LfoType_t m_eType;
    
    CRingBuffer<float> *m_pCRingBuff;
    static Error_t generateSine (float *pfOutBuf, float fFreqInHz, float fSampleFreqInHz, int iLength, float fAmplitude = 1.F, float fStartPhaseInRad = 0.F)
    {
        if (!pfOutBuf)
            return kFunctionInvalidArgsError;
        
        for (int i = 0; i < iLength; i++)
        {
            pfOutBuf[i] = fAmplitude * static_cast<float>(sin (2*M_PI*fFreqInHz * i/fSampleFreqInHz + fStartPhaseInRad));
        }
        
        return kNoError;
    }
    static Error_t generateDc (float *pfOutBuf, int iLength, float fAmplitude = 1.F)
    {
        if (!pfOutBuf)
            return kFunctionInvalidArgsError;
        
        for (int i = 0; i < iLength; i++)
        {
            pfOutBuf[i] = fAmplitude;
        }
        
        return kNoError;
    }
    static Error_t generateNoise (float *pfOutBuf, int iLength, float fAmplitude = 1.F)
    {
        if (!pfOutBuf)
            return kFunctionInvalidArgsError;
        
        for (int i = 0; i < iLength; i++)
        {
            pfOutBuf[i] = rand()*2*fAmplitude/RAND_MAX;
        }
        
        return kNoError;
    }
};
#endif // __Lfo_hdr__
#endif /* defined(__HiveReturn__Lfo__) */
