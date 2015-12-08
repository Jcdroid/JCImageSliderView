//
//  ViewController.m
//  JCImageSliderView
//
//  Created by Jcdroid on 15/12/7.
//  Copyright © 2015年 Jcdroid. All rights reserved.
//

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

#import "ViewController.h"
#import "JCImageSliderView/JCImageSliderView.h"

@interface ViewController () <JCImageSliderViewDelegate>

@property (strong, nonatomic) JCImageSliderView *imageSliderView;

@property (strong, nonatomic) NSArray *imageSliderItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    // local images
    NSArray *images = @[[UIImage imageNamed:@"JCImageSliderView.bundle/pic01.png"],
                        [UIImage imageNamed:@"JCImageSliderView.bundle/pic02.png"],
                        [UIImage imageNamed:@"JCImageSliderView.bundle/pic03.png"],
                        [UIImage imageNamed:@"JCImageSliderView.bundle/pic04.png"],
                        [UIImage imageNamed:@"JCImageSliderView.bundle/pic05.gif"],
                        ];
    
    // net images
    _imageSliderItems = @[[JCImageSliderItem initWithTitle:@"Color Bike" withUrl:@"https://d13yacurqjgara.cloudfront.net/users/4593/screenshots/2383786/allanpeters_bikeart_dribbble_1x.png"],
                          [JCImageSliderItem initWithTitle:@"Let's Build" withUrl:@"https://d13yacurqjgara.cloudfront.net/users/4593/screenshots/2386806/pdco_prints_castle_1x.png"],
                          [JCImageSliderItem initWithTitle:@"Intruder" withUrl:@"https://d13yacurqjgara.cloudfront.net/users/92827/screenshots/2386347/campi-night_1x.png"],
                          [JCImageSliderItem initWithTitle:@"Illustration" withUrl:@"https://d13yacurqjgara.cloudfront.net/users/92827/screenshots/2362329/shothomepage02_1x.png"],
                          [JCImageSliderItem initWithTitle:@"I ate a lot of pickles." withUrl:@"https://d13yacurqjgara.cloudfront.net/users/566817/screenshots/2386264/nycgifathon03.gif"],
                          ];
    
    _imageSliderView = ({
        JCImageSliderView *imageSliderView = [[JCImageSliderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 3 / 4) imageSliderItems:_imageSliderItems pageControlPosition:JCPageControlPositionRight timeInterval:4.0];
        imageSliderView.delegate = self;
        [self.view addSubview:imageSliderView];
        imageSliderView;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_imageSliderView continueTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_imageSliderView pauseTimer];
}

- (void)dealloc {
    [_imageSliderView endTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - JCImageSliderViewDelegate

- (void)imageSliderView:(JCImageSliderView *)imageSliderView didSelectAtIndex:(NSInteger)index {
    JCImageSliderItem *item = _imageSliderItems[index];
    NSLog(@"%@", item.title);
}

@end
