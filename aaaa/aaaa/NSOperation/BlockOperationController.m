//
//  BlockOperationController.m
//  aaaa
//
//  Created by 最爱是深蓝 on 2017/11/21.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "BlockOperationController.h"
#import "ImageData.h"
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NAVGATION_HEIGHT (kDevice_Is_iPhoneX ? 64:88)
@interface BlockOperationController ()
{
    NSMutableArray * _imageViews ;
    NSMutableArray * _imageNames ;
    
}

@end
//NSBlockOperation
/*
 1.使用NSBlockOperation方法，所有的操作不必单独定义方法，同时解决了只能传递一个参数的问题。
 2.调用主线程队列的addOperationWithBlock:方法进行UI更新，不用再定义一个参数实体（之前必须定义一个KCImageData解决只能传递一个参数的问题）。
 3.使用NSOperation进行多线程开发可以设置最大并发线程，有效的对线程进行了控制（下面的代码运行起来你会发现打印当前进程时只有有限的线程被创建，如上面的代码设置最大线程数为5，则图片基本上是五个一次加载的）。
 */
@implementation BlockOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor] ;
    self.title = @"多线程加载图片" ;
    
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
    btn.frame = CGRectMake(self.view.frame.size.width / 2 - 40, self.view.frame.size.height - 150 + NAVGATION_HEIGHT, 80, 30) ;
    [btn setTitle:@"加载图片" forState:UIControlStateNormal] ;
    [btn addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside] ;
    btn.backgroundColor = [UIColor orangeColor] ;
    [self.view addSubview:btn] ;
    
  
    
}

#pragma mark - 创建多线程下载图片
- (void)loadImageWithMultiThread
{
   
    //创建操作队列
    NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init] ;
    operationQueue.maxConcurrentOperationCount = 5 ;//设置最大并发线程数
    //创建多个线程用于填充图片
    for (int i = 0; i < 16; ++i) {
        /*
        //方法1:创建操作块添加队列
        //创建多线程操作
        NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]] ;
        }] ;
        blockOperation.name = [NSString stringWithFormat:@"myThread%d",i] ;
        //创建操作队列
        [operationQueue addOperation:blockOperation] ;
         */
        //方法2:直接使用操作队列添加操作
        [operationQueue addOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]] ;
         
        }];
    }
    
}

#pragma mark - 加载图片
- (void)loadImage:(NSNumber *)index
{
    
    int i = [index intValue] ;
    NSData * data = [self requestData:i] ;
    //currentThread方法可以取到当前线程
    NSThread * currentThread = [NSThread currentThread] ;
    NSLog(@"%@",currentThread) ;
    
    //更新UI界面，此处调用了主线程队列的方法（mainQueue是UI主线程）
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self updateImageWithData:data andIndex:i] ;
    }] ;
    
}

#pragma mark - 请求图片数据
- (NSData *)requestData:(int)index
{
    NSURL * url = [NSURL URLWithString:@"http://s13.mogujie.cn/b7/bao/131012/vud8_kqyterczkfbhmzdwgfjeg5sckzsew_310x404.jpg_200x999.jpg"] ;
    NSData * data = [NSData dataWithContentsOfURL:url] ;
    return data ;
    
}

#pragma mark - 显示图片
- (void)updateImageWithData:(NSData *)data andIndex:(int)index
{
    UIImage * image = [UIImage imageWithData:data] ;
    UIImageView * imageView = _imageViews[index] ;
    imageView.image = image ;
}

@end
