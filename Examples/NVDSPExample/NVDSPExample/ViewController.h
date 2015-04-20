//
//  ViewController.h
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

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"

#import "NVDSP.h"
#import "NVHighpassFilter.h"
#import "NVLowpassFilter.h"
#import "NVBandpassFilter.h"
#import "NVBandpassQPeakGainFilter.h"
#import "NVPeakingEQFilter.h"
#import "NVSoundLevelMeter.h"


@interface ViewController : UIViewController {
  RingBuffer *ringBuffer;
  Novocaine *audioManager;
  AudioFileReader *fileReader;
  AudioFileWriter *fileWriter;
//NVHighpassFilter *HPF;
  NVLowpassFilter *HPF;
//  NVBandpassFilter *BPF;
//  NVBandpassQPeakGainFilter *BPF;
  NVPeakingEQFilter *BPF;
}
- (IBAction)EQ0SliderChanged:(UISlider *)sender;
- (IBAction)EQ1SliderChanged:(UISlider *)sender;
- (IBAction)EQ2SliderChanged:(UISlider *)sender;
- (IBAction)EQ3SliderChanged:(UISlider *)sender;
- (IBAction)EQ4SliderChanged:(UISlider *)sender;
- (IBAction)EQ5SliderChanged:(UISlider *)sender;
- (IBAction)EQ6SliderChanged:(UISlider *)sender;
- (IBAction)EQ7SliderChanged:(UISlider *)sender;
- (IBAction)EQ8SliderChanged:(UISlider *)sender;
- (IBAction)EQ9SliderChanged:(UISlider *)sender;
- (IBAction)QSliderChanged:(UISlider *)sender;

@property float HPF_cornerFrequency;

@end
