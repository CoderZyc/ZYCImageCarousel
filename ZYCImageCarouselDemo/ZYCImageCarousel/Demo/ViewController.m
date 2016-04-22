//
//  ViewController.m
//  ZYCImageCarousel
//
//  Created by zyc on 16/4/22.
//  Copyright © 2016年 zyc. All rights reserved.
//

#import "ViewController.h"

#import "ZYCImageCarouselView.h"

@interface ViewController () <ZYCImageCarouselViewDelegate>

@end

@implementation ViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZYCImageCarouselView *imageCarouselView = [[ZYCImageCarouselView alloc] init];
    
    imageCarouselView.frame = CGRectMake(0, 20, 375, 200);
    imageCarouselView.images = @[
                                 [UIImage imageNamed:@"img_00"],
                                 [UIImage imageNamed:@"img_01"],
                                 [NSURL URLWithString:@"http://c.hiphotos.baidu.com/zhidao/pic/item/ae51f3deb48f8c54d6a7bff238292df5e1fe7ff2.jpg"],
                                 [UIImage imageNamed:@"img_03"],
                                 [UIImage imageNamed:@"img_04"]
                                 ];
    imageCarouselView.delegate = self;
    
    [self.view addSubview:imageCarouselView];
}

#pragma mark - ZYCImageCarouselViewDelegate
- (void)imageCarouselView:(ZYCImageCarouselView *)imageCarouselView didSelectedIndex:(NSInteger)index {
    NSLog(@"%zd", index);
}


@end
