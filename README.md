# JCImageSliderView
用OC写的一个iOS广告栏，实现循环播放，手动拖动时暂停自动播放。


![demo gif](https://raw.githubusercontent.com/Jcdroid/JCImageSliderView/master/demo.gif)

---


## Usage
### Creation of a JCImageSliderView

```
JCImageSliderView *imageSliderView = [[JCImageSliderView alloc] initWithFrame:CGRectMake(0, 0, width, height) imageSliderItems:array pageControlPosition:JCPageControlPositionRight timeInterval:4.0];
imageSliderView.delegate = self;
[self.view addSubView:imageSliderView];
```

### Delegate
```
- (void)imageSliderView:(JCImageSliderView *)imageSliderView didSelectAtIndex:(NSInteger)index {
    JCImageSliderItem *item = array[index];
    NSLog(@"%@", item.title);
}
```

### License
 See [LICENSE](https://github.com/Jcdroid/JCImageSliderView/blob/master/LICENSE) file for details.
