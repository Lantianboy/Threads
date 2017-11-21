//
//  ViewController1.m
//  aaaa
//
//  Created by 最爱是深蓝 on 2017/11/20.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "ViewController1.h"
#import "ImageData.h"
#import "NSOperationController.h"
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NAVGATION_HEIGHT (kDevice_Is_iPhoneX ? 64:88)
@interface ViewController1 ()
{
    NSMutableArray * _imageViews ;
    NSMutableArray * _imageNames ;
    NSMutableArray * _threads ;
}

@end

/*
 //多线程 NSThread 多线程并发
 线程状态分为isExecuting（正在执行）、isFinished（已经完成）、isCancellled（已经取消）三种。其中取消状态程序可以干预设置，只要调用线程的cancel方法即可。但是需要注意在主线程中仅仅能设置线程状态，并不能真正停止当前线程，如果要终止线程必须在线程中调用exist方法，这是一个静态方法，调用该方法可以退出当前线程。
 为了简化多线程开发过程，苹果官方对NSObject进行分类扩展(本质还是创建NSThread)，对于简单的多线程操作可以直接使用这些扩展方法。
 
 - (void)performSelectorInBackground:(SEL)aSelector withObject:(id)arg：在后台执行一个操作，本质就是重新创建一个线程执行当前方法。
 
 - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait：在指定的线程上执行一个方法，需要用户创建一个线程对象。
 
 - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait：在主线程上执行一个方法（前面已经使用过）。
 */
@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"多线程并发" ;
    self.view.backgroundColor = [UIColor whiteColor] ;
    [self LayoutUI] ;
    
}

- (void)LayoutUI
{
    //创建多个图片控件用于显示图片
    _imageViews = [NSMutableArray array] ;

    for (int i = 0; i < 16; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 100 * (i/4), NAVGATION_HEIGHT + 140 * (i%4) , 80, 130)] ;
        imageView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.view addSubview:imageView] ;
        [_imageViews addObject:imageView] ;
    }
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btn.frame = CGRectMake(self.view.frame.size.width / 2 - 130, self.view.frame.size.height - 150 + NAVGATION_HEIGHT, 80, 30) ;
    [btn setTitle:@"加载图片" forState:UIControlStateNormal] ;
    [btn addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside] ;
    btn.backgroundColor = [UIColor orangeColor] ;
    [self.view addSubview:btn] ;
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    btn1.frame = CGRectMake(self.view.frame.size.width / 2 + 50, self.view.frame.size.height - 150 + NAVGATION_HEIGHT, 80, 30) ;
    [btn1 setTitle:@"停止加载" forState:UIControlStateNormal] ;
    [btn1 addTarget:self action:@selector(stoploadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside] ;
    btn1.backgroundColor = [UIColor orangeColor] ;
    [self.view addSubview:btn1] ;
    
}

#pragma mark - 创建多线程下载图片
- (void)loadImageWithMultiThread
{
    
    int count = 16 ;
    _threads = [NSMutableArray arrayWithCapacity:count] ;
    
    NSLog(@"开始加载") ;
    
    //创建多线程用于填充图片
    for (int i = 0; i < 16; ++i) {
    //    [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:i]] ;
        NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]] ;
        thread.name = [NSString stringWithFormat:@"myThread%d",i] ;//设置线程名字
        NSLog(@"thread.name:%@",thread.name) ;
        
        [_threads addObject:thread] ;
        //thread.threadPriority 可以改变线程的优先级 范围为0-1 值越大优先级越高 先执行 默认为0.5
        //[NSThread sleepForTimeInterval:2.0] ; 使线程休眠两秒 可针对某个线程进行设置
        
        [thread start] ;
        
        
        
    }
}

#pragma mark - 加载图片
- (void)loadImage:(NSNumber *)index
{
    
    int i = [index intValue] ;
    NSData * data = [self requestData:i] ;
    //currentThread方法可以取到当前线程
    NSThread * currentThread = [NSThread currentThread] ;
    //如果当前线程处于取消状态 则退出当前线程
    if (currentThread.isCancelled) {
        NSLog(@"thread：%@  will be cancelled",currentThread) ;
        [NSThread exit] ;//退出当前线程
    }
    
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
#pragma mark - 停止加载图片
- (void)stoploadImageWithMultiThread
{
    NSLog(@"停止加载") ;
    for (int i = 0; i < 16; i ++) {
        NSThread * thread = _threads[i] ;
        //判断线程是否完成 如果没有完成泽设置为取消状态
        //注意设置为取消状态仅仅是改变了线程状态而言 并不能终止线程
        if (!thread.isFinished) {
            [thread cancel] ;
        }
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSOperationController * oper = [[NSOperationController alloc] init] ;
    [self.navigationController pushViewController:oper animated:YES] ;
     NSLog(@"进入下一页") ;
}


@end
