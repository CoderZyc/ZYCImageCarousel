//
//  ZYCImageCarouselView.h
//  ZYCImageCarousel
//
//  Created by zyc on 16/4/22.
//  Copyright © 2016年 zyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYCImageCarouselView;
@protocol ZYCImageCarouselViewDelegate <NSObject>

@optional
- (void)imageCarouselView:(ZYCImageCarouselView *)imageCarouselView didSelectedIndex:(NSInteger)index;

@end

@interface ZYCImageCarouselView : UIView

/** 图片数据 */
@property (strong, nonatomic) NSArray *images;
/** 占位图片 */
@property (strong, nonatomic) UIImage *placeholder;
/** 时间间隔 */
@property (assign, nonatomic) CGFloat second;
/** 代理 */
@property (weak, nonatomic) id <ZYCImageCarouselViewDelegate> delegate;

@end
