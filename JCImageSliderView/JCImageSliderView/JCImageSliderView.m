//
//  JCImageSliderView.m
//  JCImageSliderView
//
//  Created by Jcdroid on 15/12/7.
//  Copyright © 2015年 Jcdroid. All rights reserved.
//

#import "JCImageSliderView.h"

#define kPadding 5.0f
#define kLabelHeight 21.0f
#define kBottomViewHeight 30.0f

@interface JCImageSliderView () <UIScrollViewDelegate> {
    NSMutableArray *_imageViewsContainer;
    
    CGFloat _allImageWidth, _singleImageWidth;
}

@property (strong, nonatomic, nonnull) NSArray *imageSliderItems;
@property (nonatomic, assign) JCPageControlPosition pageControlPosition;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation JCImageSliderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageSliderItems:(NSArray *)imageSliderItems pageControlPosition:(JCPageControlPosition)pageControlPosition {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageSliderItems = imageSliderItems;
        self.pageControlPosition = pageControlPosition;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    if (!_imageSliderItems || _imageSliderItems.count == 0) {
        NSLog(@"图片数组不能为空或数量不能为0");
        return;
    }
    
    self.backgroundColor = (YES)?[UIColor whiteColor]:[UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0];// test
    
    _scrollView =  ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.frame = self.frame;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.alwaysBounceVertical = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(self.frame.size.width * _imageSliderItems.count * 3, 0);// 设置三组ImageViews的空间
        scrollView.delegate = self;
        [self addSubview:scrollView];
        scrollView;
    });
    
    _bottomView = ({
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.500];
        bottomView.frame = CGRectMake(0, self.frame.size.height - kBottomViewHeight, self.frame.size.width, kBottomViewHeight);
        [self addSubview:bottomView];
        bottomView;
    });
    
    _pageControl = ({
        UIPageControl *pageControl = [UIPageControl new];
        pageControl.numberOfPages = _imageSliderItems.count;
        pageControl.currentPage = 0;
        pageControl.enabled = NO;
        CGSize pageControlSize = [pageControl sizeForNumberOfPages:_imageSliderItems.count];
        switch (self.pageControlPosition) {
            case JCPageControlPositionCenter:
                pageControl.frame = CGRectMake((self.frame.size.width - pageControlSize.width)/2, 0, pageControlSize.width, kBottomViewHeight);
                break;
                
            case JCPageControlPositionRight:
                pageControl.frame = CGRectMake(self.frame.size.width - pageControlSize.width - kPadding, 0, pageControlSize.width, kBottomViewHeight);
            default:
                break;
        }
        [_bottomView addSubview:pageControl];
        pageControl;
    });
    
    _label = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(kPadding, kBottomViewHeight/2 - kLabelHeight/2, self.frame.size.width - (kBottomViewHeight - kLabelHeight), kLabelHeight);
        JCImageSliderItem *item = _imageSliderItems[0];
        label.text = item.title;
        [_bottomView addSubview:label];
        label;
    });
    
    // 创建三组ImageViews，然后添加到_imageViewsContainer中
    _imageViewsContainer = @[].mutableCopy;
    for (int i = 0; i < 3; i++) {
        NSMutableArray *imageViews = @[].mutableCopy;
        for (int j = 0; j < _imageSliderItems.count; j++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * _imageSliderItems.count * i + self.frame.size.width * j, 0, self.frame.size.width, self.frame.size.height)];
            JCImageSliderItem *item = _imageSliderItems[j];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.url]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = [UIImage imageWithData:imageData];
                });
            });
            imageView.contentMode = UIViewContentModeScaleToFill;
            [imageViews addObject:imageView];
            [self.scrollView addSubview:imageView];
        }
        [_imageViewsContainer addObject:imageViews];
    }
    
    _singleImageWidth = self.scrollView.frame.size.width;
    _allImageWidth = _singleImageWidth * _imageSliderItems.count;
    [_scrollView setContentOffset:CGPointMake(_allImageWidth, 0)];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectIndex:)]];
    
    [self createTimer];
}

#pragma mark - UIScrollViewDelegate M

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= _allImageWidth * 2) {// 到达第三组ImageViews
        [_scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x - _allImageWidth, 0)];
    } else if (scrollView.contentOffset.x < _allImageWidth) {// 到达第一组ImageViews
        [_scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + _allImageWidth, 0)];
    }
    _pageControl.currentPage = (scrollView.contentOffset.x - _allImageWidth) / _singleImageWidth;
    JCImageSliderItem *item = _imageSliderItems[_pageControl.currentPage];
    _label.text = item.title;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= _allImageWidth * 2) {// 到达第三组ImageViews
        [_scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x - _allImageWidth, 0)];
    } else if (scrollView.contentOffset.x < _allImageWidth) {// 到达第一组ImageViews
        [_scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + _allImageWidth, 0)];
    }
    _pageControl.currentPage = (scrollView.contentOffset.x - _allImageWidth) / _singleImageWidth;
    JCImageSliderItem *item = _imageSliderItems[_pageControl.currentPage];
    _label.text = item.title;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self continueTimer];
}

#pragma mark - Action M

- (void)selectIndex:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageSliderView:didSelectAtIndex:)]) {
        [self.delegate imageSliderView:self didSelectAtIndex:_pageControl.currentPage];
    }
}

#pragma mark - Private M

- (void)scrollToNext:(NSTimer *)timer {
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + _singleImageWidth, 0) animated:YES];
}

- (void)createTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollToNext:) userInfo:nil repeats:YES];
    }
}

- (void)pauseTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)continueTimer {
    [self createTimer];
}

- (void)endTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end

@implementation JCImageSliderItem

+ (instancetype)initWithTitle:(NSString *)title withUrl:(NSString *)url {
    JCImageSliderItem *item = [[JCImageSliderItem alloc] init];
    if (self) {
        item.title = title;
        item.url = url;
    }
    return item;
}

@end
