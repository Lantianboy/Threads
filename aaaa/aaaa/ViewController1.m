//
//  ViewController1.m
//  aaaa
//
//  Created by 最爱是深蓝 on 2017/11/20.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "ViewController1.h"
#import "ImageData.h"

@interface ViewController1 ()
{
    NSMutableArray * _imageViews ;
}

@end
//多线程 NSThread 多线程并发
@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor] ;
    [self LayoutUI] ;
}

- (void)LayoutUI
{
    //创建多个图片控件用于显示图片
    _imageViews = [NSMutableArray array] ;

    for (int i = 0; i < 16; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 100 * (i/4), 20 + 140 * (i%4) , 80, 130)] ;
        imageView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.view addSubview:imageView] ;
        [_imageViews addObject:imageView] ;
    }
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btn.frame = CGRectMake(self.view.frame.size.width / 2 - 40, self.view.frame.size.height - 150, 80, 30) ;
    [btn setTitle:@"加载图片" forState:UIControlStateNormal] ;
    [btn addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside] ;
    btn.backgroundColor = [UIColor orangeColor] ;
    [self.view addSubview:btn] ;
    
}

#pragma mark - 创建多线程下载图片
- (void)loadImageWithMultiThread
{
    //创建多线程用于填充图片
    for (int i = 0; i < 16; ++i) {
    //    [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:i]] ;
        NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]] ;
        thread.name = [NSString stringWithFormat:@"myThread%i",i] ;//设置线程名字
        
        //thread.threadPriority 可以改变线程的优先级 范围为0-1 值越大优先级越高 先执行 默认为0.5
        
        [thread start] ;
    }
}

#pragma mark - 加载图片
- (void)loadImage:(NSNumber *)index
{
    //currentThread方法可以取到当前线程
    NSLog(@"current thread：%@",[NSThread currentThread]) ;
    
    int i = [index integerValue] ;
    
    
    NSData * data = [self requestData:i] ;
    
    ImageData * imageData = [[ImageData alloc] init] ;
    imageData.index = i ;
    imageData.data = data ;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES] ;
    
}

#pragma mark - 请求图片数据
- (NSData *)requestData:(int)index
{
    NSURL * url = [NSURL URLWithString:@"http://s12.mogujie.cn/b7/bao/131008/j7g0k_kqyw4rdikfbdivtwgfjeg5sckzsew_703x1010.jpg_200x999.jpg"] ;
    NSData * data = [NSData dataWithContentsOfURL:url] ;
    return data ;
 
}

#pragma mark - 显示图片
- (void)updateImage:(ImageData *)imageData
{
    UIImage * image = [UIImage imageWithData:imageData.data] ;
    UIImageView * imageView = _imageViews[imageData.index] ;
    imageView.image = image ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}


@end
