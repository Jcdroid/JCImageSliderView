# JCImageSliderView
用OC写的一个iOS广告栏，实现循环播放，手动拖动时暂停自动播放。


![demo gif](https://raw.githubusercontent.com/Jcdroid/JCImageSliderView/master/demo.gif)

---


### Usage
```
JCImageSliderView *imageSliderView = [[JCImageSliderView alloc] initWithFrame:CGRectMake(0, 0, width, height) imageSliderItems:array pageControlPosition:JCPageControlPositionRight];

imageSliderView.delegate = self;

......


#pragma mark - JCImageSliderViewDelegate

- (void)imageSliderView:(JCImageSliderView *)imageSliderView didSelectAtIndex:(NSInteger)index {
    JCImageSliderItem *item = _imageSliderItems[index];
    NSLog(@"%@", item.title);
}
```
