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
   

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击了屏幕") ;
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
