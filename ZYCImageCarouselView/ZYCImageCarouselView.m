//
//  ZYCImageCarouselView.m
//  ZYCImageCarousel
//
//  Created by zyc on 16/4/22.
//  Copyright © 2016年 zyc. All rights reserved.
//

#import "ZYCImageCarouselView.h"
#import "UIImageView+WebCache.h"

#pragma mark - ZYCImageCell
@interface ZYCImageCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation ZYCImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end

#pragma mark - ZYCImageCarouselView
@interface ZYCImageCarouselView () <UICollectionViewDataSource, UICollectionViewDelegate>

/** collectionView */
@property (weak, nonatomic) UICollectionView *collectionView;

/** 定时器 */
@property (weak, nonatomic) NSTimer *timer;

@end

static NSString * const ID = @"collecitonViewCellID";
static NSInteger const ZYCItemCount = 20;

@implementation ZYCImageCarouselView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initImageCarouselView];
    }
    return self;
}

- (void)initImageCarouselView {
    // 流水布局
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 注册
    [collectionView registerClass:[ZYCImageCell class] forCellWithReuseIdentifier:ID];
    
    // 默认占位图片
    self.placeholder = [UIImage imageNamed:@"ZYCImageCarouselView.bundle/ZYCImageCarouselView_placeholder"];
    // 默认时间间隔
    self.second = 1.5;
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = self.collectionView.bounds.size;
}

#pragma mark - 设置数据
- (void)setImages:(NSArray *)images {
    
    _images = images;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:ZYCItemCount * self.images.count * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
    
    [self startTimer];
}

#pragma mark - 定时器
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.second target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
}

- (void)nextPage {
    CGPoint offset = self.collectionView.contentOffset;
    offset.x += self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:offset animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ZYCItemCount * self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYCImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    id obj = self.images[indexPath.item % self.images.count];
    
    if ([obj isKindOfClass:[UIImage class]]) {
        cell.imageView.image = obj;
    } else if ([obj isKindOfClass:[NSURL class]]) {
        [cell.imageView sd_setImageWithURL:obj placeholderImage:self.placeholder];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(imageCarouselView:didSelectedIndex:)]) {
        [self.delegate imageCarouselView:self didSelectedIndex:indexPath.item % self.images.count];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetPosition];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self resetPosition];
}

#pragma mark - methods
- (void)resetPosition {
    NSInteger oldIndexPath = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    
    NSInteger newIndexPath = ZYCItemCount * self.images.count * 0.5 + oldIndexPath % self.images.count;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newIndexPath inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
@end
