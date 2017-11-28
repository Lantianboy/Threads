//
//  ViewController.m
//  aaaa
//
//  Created by 最爱是深蓝 on 2017/10/10.
//  Copyright © 2017年 ProductTest. All rights reserved.
//


#import "ViewController.h"
#import "ViewController1.h"
@interface ViewController ()
{
    UIImageView * _imageView ;
}

@end
//多线程 NSThread  解决线程阻塞问题
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor] ;
    self.title = @"线程阻塞" ;
    
    
    [self layoutUI] ;
}

#pragma  mark - 界面布局
- (void)layoutUI
{
    _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds] ;
    //让图片等比例缩放 自适应屏幕
    _imageView.contentMode = UIViewContentModeScaleAspectFit ;
    [self.view addSubview:_imageView] ;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btn.frame = CGRectMake(self.view.frame.size.width / 2 -40 , 600, 80, 25) ;
    btn.backgroundColor = [UIColor orangeColor] ;
    [btn setTitle:@"加载图片" forState:UIControlStateNormal] ;
    [btn addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:btn] ;
}

#pragma  mark - 多线程下载图片 创建一个新线程
- (void)loadImageWithMultiThread
{
    //方法一：使用对象方法
    //创建一个线程，第一个参数是请求的操作，第二个参数是操作方法的参数
    //    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil] ;
    //启动一个线程 注意启动一个线程并非久一定立即执行 而是处于就绪状态 当系统调度时才真正执行
    //    [thread start] ;
    
    //方法二 使用类方法
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil] ;
}

#pragma  mark - 请求图片数据
- (NSData *)requestData
{
    NSURL * url = [NSURL URLWithString:@"http://s6.mogujie.cn/b7/bao/131009/4425f_kqywu2cwkfbewvsugfjeg5sckzsew_310x310.jpg_200x999.jpg"] ;
    NSData * data = [NSData dataWithContentsOfURL:url] ;
    return data ;
}

#pragma mark - 加载图片
- (void)loadImage
{
    //请求数据
    NSData * data = [self requestData] ;
    /*
     将数据显示到UI控件 注意只能在主线程中进行UI更新
     performSelectorOnMainThread方法是NSobject的分类方法 每个NSObject对象都有此方法 它调用的selector方法是当前调用控件的方法 例如使用UIImageView调用的时候selector就是UIImageView的方法
     Object：代表调用方法的参数 不过只能传递一个参数（如果有多个参数请使用对象进行封装）
     waitUntilDone ： 是否线程任务完成执行
     */
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES] ;
    NSLog(@"我是一个粉刷将") ;
}

#pragma mark - 显示图片
- (void)updateImage:(NSData *)imageData
{
    UIImage * image = [UIImage imageWithData:imageData] ;
    _imageView.image = image ;
    NSLog(@"1111") ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    ViewController1 * vi = [[ViewController1 alloc] init] ;
    [self.navigationController pushViewController:vi animated:YES] ;
    NSLog(@"进入下一页") ;
}

@end
