//
//  JCImageSliderView.h
//  JCImageSliderView
//
//  Created by Jcdroid on 15/12/7.
//  Copyright © 2015年 Jcdroid. All rights reserved.
//

/**
 原理：根据外部传进来的imageSliderItems的数量，创建三组imageViews，默认设置scrollView的ContentOffset为第二组的开始位置，也就是 屏幕宽*imageSliderItems数量
 
 1. 前进超越第二组的最后一张图片时，手动将scrollView的ContentOffset设置为第二组的对应位置
 2. 后退超越第二组的第一张图片时，手动将scrollView的ContentOffset设置为第二组的对应位置
 3. 在第二组中时，不需要做任何特殊处理
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JCPageControlPosition) {
    JCPageControlPositionRight = 0,
    JCPageControlPositionCenter = 1,
};

@class JCImageSliderView;

@protocol JCImageSliderViewDelegate <NSObject>

- (void)imageSliderView:(nullable JCImageSliderView *)imageSliderView didSelectAtIndex:(NSInteger)index;

@end

@interface JCImageSliderView : UIView

- (nonnull instancetype)initWithFrame:(CGRect)frame imageSliderItems:(nonnull NSArray *)imageSliderItems pageControlPosition:(JCPageControlPosition)pageControlPosition;

@property (nonatomic, weak, nullable) id <JCImageSliderViewDelegate> delegate;

@end

@interface JCImageSliderItem : NSObject

@property (copy, nonatomic, nullable) NSString *title;
@property (copy, nonatomic, nullable) NSString *url;

+ (nonnull instancetype)initWithTitle:(nonnull NSString *)title withUrl:(nonnull NSString *)url;

@end