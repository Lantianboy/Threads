//
//  GCDViewController.m
//  aaaa
//
//  Created by 最爱是深蓝 on 2017/11/28.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()
@property (strong, nonatomic) UIImageView * img ;
@property (nonatomic, strong) UIImage * img1 ;
@property (nonatomic, strong) UIImage * img2 ;
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击屏幕合成图片" ;
    self.view.backgroundColor = [UIColor whiteColor] ;
   
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 300, 300)] ;
    [self.view addSubview:self.img] ;

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //GCD延时 非阻塞的执行方式 在子线程中执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"点击了屏幕") ;
    });
    /*
     *****几种延时方式的比较****
     1.此方式要求必须在主线程中执行，否则无效(在子线程中可以配合runloop使用)。是一种非阻塞的执行方式，暂时未找到取消执行的方法。
         [self performSelector:@selector(delayMethod) withObject:nil     afterDelay:1.0f];
     
     2.此方式要求必须在主线程中执行，否则无效。是一种非阻塞的执行方式，可以通过NSTimer类的- (void)invalidate;取消执行。
         [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
     
     3. 此方式在主线程和子线程中均可执行。是一种阻塞的执行方式，建议放到子线程中，以免卡住界面，没有找到取消执行的方法。
         [NSThread sleepForTimeInterval:4.0f];
         [self delayMethod];
     
     *************插一句关于拷贝*****************************************
         对于NSString,NSDictionary,NSArray用copy的是不可变对象，默认的都是浅拷贝，可变对象时为深拷贝。用mutablecopy时，无论是可变对象还是不可变对象实现的都是深拷贝
     ******************************************************************
     */
    
    [self layoutUI] ;
}

- (void)layoutUI{
    //下载两张图片然后结合成在一起
    //下载图片1
    //创建队列组
    dispatch_group_t group = dispatch_group_create() ;
    //1.开子线程下载图片
    //创建队列(并发)
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0) ;
    dispatch_group_async(group, queue, ^{
        //1.获取url地址
        NSURL * url = [NSURL URLWithString:@"http://www.huabian.com/uploadfile/2015/0914/20150914014032274.jpg"] ;
        //2.下载图片
        NSData * data = [NSData dataWithContentsOfURL:url] ;
        //3.把二进制数据转换成图片
        self.img1 = [UIImage imageWithData:data];
        NSLog(@"1-----%@",self.img1) ;
        
    }) ;
    
    //下载图片2
    dispatch_group_async(group, queue, ^{
        NSURL * url = [NSURL URLWithString:@"http://img1.3lian.com/img2011/w12/1202/19/d/88.jpg"] ;
        NSData * data = [NSData dataWithContentsOfURL:url] ;
        self.img2 = [UIImage imageWithData:data] ;
        NSLog(@"2----%@",self.img2) ;
    }) ;
    // 合成
    dispatch_group_notify(group, queue, ^{
        //开启图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200)) ;
        //画1
        [self.img1 drawInRect:CGRectMake(0, 0, 200, 100)] ;
        //画2
        [self.img2 drawInRect:CGRectMake(0, 100, 200, 100)] ;
        //根据图形上下文拿到图片
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext() ;
        //关闭上下文
        UIGraphicsEndImageContext() ;
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.img.image = image ;
            
            NSLog(@"%@---刷新UI ",[NSThread currentThread]) ;
            
        }) ;
    }) ;
    
}

@end
