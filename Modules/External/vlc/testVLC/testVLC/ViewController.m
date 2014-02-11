//
//  ViewController.m
//  testVLC
//
//  Created by fgx_lion on 13-9-13.
//  Copyright (c) 2013年 Dr.COM. All rights reserved.
//

#import "ViewController.h"
#import "VLCMovieViewController.h"

@interface ViewController ()
- (void)playActive:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _btnPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnPlay.frame = CGRectMake(100, 100, 100, 30);
    [_btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    [_btnPlay addTarget:self action:@selector(playActive:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playActive:(id)sender
{
    VLCMovieViewController* movieViewController = [[[VLCMovieViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UIImage * displayImage = [UIImage imageNamed:@"ActivityImage"];
    movieViewController.displayImage = displayImage;
    movieViewController.resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"];
    UINavigationController * navigationCtrl = self.navigationController;
    [navigationCtrl pushViewController:movieViewController animated:YES];
    
    static BOOL isVideo = NO;
    if (isVideo) {
        movieViewController.url = [NSURL URLWithString:@"rtsp://192.168.12.110/my.ts"];
    }else {
        movieViewController.url = [NSURL URLWithString:@"rtsp://192.168.12.110/test.mp3"];
    }
    isVideo = !isVideo;
    
//    ViewController *contrller = [[ViewController alloc] initWithNibName:nil bundle:nil];
//    [navigationCtrl pushViewController:contrller animated:YES];
}

@end
