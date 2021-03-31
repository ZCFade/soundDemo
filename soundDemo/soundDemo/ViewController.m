//
//  ViewController.m
//  soundDemo
//
//  Created by 瓜而不皮 on 2021/3/31.
//

#import "ViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong)MPVolumeView *volumeView;
@property (nonatomic, strong)UISlider *volumeSlider;

@end

@implementation ViewController


-(void)dealloc {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // 允许静音播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [[AVAudioSession sharedInstance]outputVolume];
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    if (([musicPlayer respondsToSelector:@selector(setVolume:)]) && [[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0) {
        //消除警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([self getVolume] == 0) {
            [musicPlayer setVolume:0.5];
        }
#pragma clang diagnostic pop
    }else {
        // 低版本按照正常的设置依然不能控制音量  故使用了MPMusicPlayerController
        if ([self getVolume] == 0) {
            [musicPlayer setVolume:0.5];
        }
    }
    
}

- (MPVolumeView *)volumeView
{
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        // 下面两行代码都会使音量界面重新显示
         [_volumeView setHidden:YES];
         [_volumeView removeFromSuperview];
        [self.view addSubview:_volumeView];
    }
    return _volumeView;
}

- (UISlider*)volumeSlider
{
    UISlider* volumeSlider =nil;
    for(UIView*view in[self.volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider*)view;
            break;
        }
    }
    return volumeSlider;
}

- (float)getVolume
{
    return self.volumeSlider.value > 0 ? self.volumeSlider.value : [[AVAudioSession sharedInstance] outputVolume];
}


@end
