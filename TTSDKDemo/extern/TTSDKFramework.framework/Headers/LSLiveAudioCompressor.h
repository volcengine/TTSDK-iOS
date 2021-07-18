//
//  LSLiveAudioCompressor.h
//  LiveCore_d
//
//  Created by KeeeeC on 2020/1/29.
//

#import <Foundation/Foundation.h>
#import <memory>
#import <audiosdk/ae_effect_creator.h>

using std::unique_ptr;

#define LCCompressorAudio 1
#define LCCompressorOthers 0

namespace LiveCoreN {
    class LCAudioCompressor {
    public:
        LCAudioCompressor(int type, int sample_rate = 44100, int num_channels = 2);
        ~LCAudioCompressor();
        
        void ProcessBuffer(int16_t *data, int sample_per_channel, int number_of_channel);
    private:
        unique_ptr<mammon::Effect>      m_processor;
        int                             m_sample_rate;
        int                             m_num_channels;
        int                             m_type;
    };
}
