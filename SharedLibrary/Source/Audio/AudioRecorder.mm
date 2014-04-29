//
//  AudioRecorder.cpp
//  HiveReturn
//
//  Created by Chih-Wei on 3/8/14.
//  Copyright (c) 2014 GTCMT. All rights reserved.
//

#include "AudioRecorder.h"



AudioRecorder::AudioRecorder() : backgroundThread("recording thread"),nexSampleNum(0), nexSampleNumInBuffer(0) /*playbackThread("play threaad")*/
{
    sharedAudioDeviceManager->getAudioDeviceSetup(deviceSetup);
    sampleRate = deviceSetup.sampleRate;
    recordingStatus = false;
    playingStatus = false;
    activeWriter = nullptr;


    buffer  =   new AudioSampleBuffer(deviceSetup.inputChannels.toInteger(), 32768);
    backgroundThread.startThread();
    //playbackThread.startThread(3);
}

AudioRecorder::~AudioRecorder()
{
    stopRecording();
//    stopPlaying();
    buffer  =   nullptr;
    threadedWriter = nullptr;
    reader  =   nullptr;
    
}

void AudioRecorder::startRecording(String filePath)
{
    
    
    stopRecording();
    
    File currentFile (filePath);
    
    recordingStatus = true;
    if (sampleRate > 0)
    {
        currentFile.deleteFile();
        // use the file to write
        ScopedPointer<FileOutputStream> fileStream (currentFile.createOutputStream());
        
        if (fileStream != nullptr)
        {
            // prepare a writer to write the file
            WavAudioFormat wavFormat;
            ScopedPointer<AudioFormatWriter> writer;
            writer = wavFormat.createWriterFor (fileStream, deviceSetup.sampleRate, 1, 16, StringPairArray(), 0);
            
            if (writer != nullptr)
            {
                fileStream.release();
                threadedWriter = new AudioFormatWriter::ThreadedWriter (writer, backgroundThread, 32768);
                nexSampleNum = 0;
                
                //swap when everything is settled
                const ScopedLock sl (writerLock);
                activeWriter = threadedWriter;
            }
        }

    }
    
}

void AudioRecorder::stopRecording()
{
    recordingStatus = false;
    {
    const ScopedLock sl (writerLock);
    activeWriter = nullptr;
    }
    threadedWriter = nullptr;
}

//void AudioRecorder::startPlaying(const File &currentFile)
//{
//    playingStatus = true;
//    
//    //create a stream object from currentFile
//    ScopedPointer<FileInputStream> fileIncomingStream (currentFile.createInputStream());
//    if (fileIncomingStream != nullptr)
//    {
//    // prepare a reader to read current file
//    WavAudioFormat wavFormat;
//    reader = wavFormat.createReaderFor(fileIncomingStream, true);
//    
//    nexSampleNum = 0;
//    nexSampleNumInBuffer = 0;
//    }
//    
//    
//}
//
//void AudioRecorder::stopPlaying()
//{
//    playingStatus = false;
////    bufferedReader = nullptr;
//    reader  =   nullptr;
//}

//=============================================================

void AudioRecorder::audioDeviceAboutToStart (AudioIODevice *device)
{
    sampleRate = device->getCurrentSampleRate();
}

void AudioRecorder::audioDeviceIOCallback (const float** inputChannelData, int numInputChannels, float** outputChannelData, int numOutputChannels, int numSamples)
{
    // This class will do the recording first
    // critical section here
    
    if (recordingStatus == true)
    {
        const ScopedLock sl (writerLock);
        
        if (activeWriter != nullptr)
        {
            activeWriter->write(inputChannelData, numSamples);
            nexSampleNum += numSamples;
        }
        
        // keep cleaning up the output channels...
        for (int i = 0; i < numOutputChannels; ++i)
            if (outputChannelData[i] != nullptr)
                FloatVectorOperations::clear (outputChannelData[i], numSamples);
    }
    
    if (playingStatus == true)
    {
        reader->read(buffer, nexSampleNumInBuffer, numSamples, nexSampleNum, true, true);
        
        
        
        nexSampleNumInBuffer += numSamples;
        
        
        outputChannelData = buffer->getArrayOfChannels();
    }
    
}


void AudioRecorder::audioDeviceStopped()
{
    sampleRate = 0;
}



