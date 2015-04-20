//
//  ViewController.m
//  NVDSPExample
//
//  Created by Bart Olsthoorn on 25/04/2013.
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


NVPeakingEQFilter *PEQ[10];
CGFloat QFactor;
CGFloat initialGain;
NVSoundLevelMeter *inputWatcher;
NVSoundLevelMeter *outPutWatcher;



- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    ringBuffer = new RingBuffer(32768, 2);
    audioManager = [Novocaine audioManager];
    float samplingRate = audioManager.samplingRate;
    
    // define center frequencies of the bands
    float centerFrequencies[10];
    
/*    centerFrequencies[0] = 50.0f;
    centerFrequencies[1] = 62.5f;
    centerFrequencies[2] = 125.0f;
    centerFrequencies[3] = 250.0f;
    centerFrequencies[4] = 500.0f;
    centerFrequencies[5] = 1000.0f;
    centerFrequencies[6] = 2000.0f;
    centerFrequencies[7] = 4000.0f;
    centerFrequencies[8] = 6000.0f;
    centerFrequencies[9] = 10000.0f;*/
    
    
    centerFrequencies[0] = 31.25f;
    centerFrequencies[1] = 62.5f;
    centerFrequencies[2] = 125.0f;
    centerFrequencies[3] = 250.0f;
    centerFrequencies[4] = 500.0f;
    centerFrequencies[5] = 1000.0f;
    centerFrequencies[6] = 2000.0f;
    centerFrequencies[7] = 4000.0f;
    centerFrequencies[8] = 8000.0f;
    centerFrequencies[9] = 16000.0f;
    
    /*centerFrequencies[0] = 50.0f;
    centerFrequencies[1] = 60.0f;
    centerFrequencies[2] = 70.0f;
    centerFrequencies[3] = 80.0f;
    centerFrequencies[4] = 90.0f;
    centerFrequencies[5] = 100.0f;
    centerFrequencies[6] = 110.0f;
    centerFrequencies[7] = 120.0f;
    centerFrequencies[8] = 130.0f;
    centerFrequencies[9] = 140.0f;*/
    
/*    centerFrequencies[0] = 60.0f;
    centerFrequencies[1] = 170.0f;
    centerFrequencies[2] = 310.0f;
    centerFrequencies[3] = 600.0f;
    centerFrequencies[4] = 1000.0f;
    centerFrequencies[5] = 3000.0f;
    centerFrequencies[6] = 6000.0f;
    centerFrequencies[7] = 12000.0f;
    centerFrequencies[8] = 14000.0f;
    centerFrequencies[9] = 16000.0f;*/
    
    // define Q factor of the bands
    QFactor = 2.0f;
    //QFactor = 20.0f;
    
    // define initial gain
    initialGain = 0.0f;
    
    // init PeakingFilters
    // You'll later need to be able to set the gain for these (as the sliders change)
    // So define them somewhere global using NVPeakingEQFilter *PEQ[10];
    for (int i = 0; i < 10; i++) {
        PEQ[i] = [[NVPeakingEQFilter alloc] initWithSamplingRate:samplingRate];
        //PEQ[i] = [[NVBandpassQPeakGainFilter alloc] initWithSamplingRate:samplingRate];
        PEQ[i].Q = QFactor;
        PEQ[i].centerFrequency = centerFrequencies[i];
        PEQ[i].G = initialGain;
    }
    
    // init SoundLevelMeters
    inputWatcher = [[NVSoundLevelMeter alloc] init];
    outPutWatcher = [[NVSoundLevelMeter alloc] init];
    
    // Audio File Reading
    //NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"TLC" withExtension:@"mp3"];
    NSURL *inputFileURL = [[NSBundle mainBundle] URLForResource:@"DemoSong" withExtension:@"m4a"];

    fileReader = [[AudioFileReader alloc]
                  initWithAudioFileURL:inputFileURL
                  samplingRate:audioManager.samplingRate
                  numChannels:audioManager.numOutputChannels];
    
    [fileReader play];
    fileReader.currentTime = 30.0;
    
    [audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         [fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
         //NSLog(@"Time: %f", fileReader.currentTime);
         
         // measure input level
         //inputLevelBuffer = [inputWatcher getdBLevel:outData numFrames:numFrames numChannels:numChannels];
         
         //HPF.cornerFrequency = _HPF_cornerFrequency;
         //HPF.Q = 0.5f;
         
         //[HPF filterData:data numFrames:numFrames numChannels:numChannels];
         //[BPF filterData:data numFrames:numFrames numChannels:numChannels];
         
         // apply the filter
         for (int i = 0; i < 10; i++) {
             [PEQ[i] filterData:data numFrames:numFrames numChannels:numChannels];
         }
     }];
}

- (void)EQ0SliderChanged:(UISlider *)sender
{
    PEQ[0].G = sender.value;
    //NSLog(@"PEQ[0].G=%f", PEQ[0].G);
}

- (void)EQ1SliderChanged:(UISlider *)sender
{
    PEQ[1].G = sender.value;
    //NSLog(@"PEQ[1].G=%f", PEQ[1].G);
}

- (void)EQ2SliderChanged:(UISlider *)sender
{
    PEQ[2].G = sender.value;
    //NSLog(@"PEQ[2].G=%f", PEQ[2].G);
}

- (void)EQ3SliderChanged:(UISlider *)sender
{
    PEQ[3].G = sender.value;
    //NSLog(@"PEQ[3].G=%f", PEQ[3].G);
}

- (void)EQ4SliderChanged:(UISlider *)sender
{
    PEQ[4].G = sender.value;
    //NSLog(@"PEQ[4].G=%f", PEQ[4].G);
}

- (void)EQ5SliderChanged:(UISlider *)sender
{
    PEQ[5].G = sender.value;
    //NSLog(@"PEQ[5].G=%f", PEQ[5].G);
}

- (void)EQ6SliderChanged:(UISlider *)sender
{
    PEQ[6].G = sender.value;
    //NSLog(@"PEQ[6].G=%f", PEQ[6].G);
}

- (void)EQ7SliderChanged:(UISlider *)sender
{
    PEQ[7].G = sender.value;
    //NSLog(@"PEQ[7].G=%f", PEQ[7].G);
}

- (void)EQ8SliderChanged:(UISlider *)sender
{
    PEQ[8].G = sender.value;
    //NSLog(@"PEQ[8].G=%f", PEQ[8].G);
}

- (void)EQ9SliderChanged:(UISlider *)sender
{
    PEQ[9].G = sender.value;
    //NSLog(@"PEQ[9].G=%f", PEQ[9].G);
}

- (void)QSliderChanged:(UISlider *)sender
{
    //for (int i=0; i<10; i++) {
        //PEQ[i].Q = sender.value;
    //}
    NSLog(@"Qslider.value = %f", sender.value);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
