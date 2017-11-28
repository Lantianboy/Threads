//
//  GCDController.m
//  aaaa
//
//  Created by 最爱是深蓝 on 2017/11/27.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "GCDController.h"
#import "ImageData.h"
#import "GCDViewController.h"
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NAVGATION_HEIGHT (kDevice_Is_iPhoneX ? 64:88)
@interface GCDController ()
{
    NSMutableArray * _imageViews ;
    NSMutableArray * _imageNames ;
}

@end

@implementation GCDController
/* **************串行队列和并发队列************
 在GDC中一个操作是多线程执行还是单线程执行取决于当前队列类型和执行方法，只有队列类型为并行队列并且使用异步方法执行时才能在多个线程中执行。
 串行队列可以按顺序执行，并行队列的异步方法无法确定执行顺序。
 UI界面的更新最好采用同步方法，其他操作采用异步方法。
 *****关于同步异步、串行并行的小结********
 1、串行队列不管是异步还是同步，都是按顺序一个一个执行的。
 2、同步操作不管是并行队列还是串行队列，都是按顺序一个一个执行的但是原因不一样(并行是因为线程阻塞)。
 3、异步操作会开辟线程，不阻塞当前线程。同步操作不会开辟线程，会阻塞当前线程。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"串行队列" ;
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    [self LayoutUI] ;

}

- (void)LayoutUI
{
    //创建多个图片控件用于显示图片
    _imageViews = [NSMutableArray array] ;
    
    for (int i = 0; i < 16; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + 100 * (i%4), NAVGATION_HEIGHT + 140 * (i/4) , 80, 130)] ;
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

- (void)loadImageWithMultiThread
{
    /* 一、串行队列
     创建一个串行队列
     第一个参数:队列名称
     第二个参数:队列类型
     */
    dispatch_queue_t serialQueue = dispatch_queue_create("myThreadQueue", DISPATCH_QUEUE_SERIAL) ;//注意queue对象不是指针类型
    /*二、并发队列
     取得全局队列
     第一个参数:线程优先级
     第二个参数:标记参数 目前没有用 一般传入0
     
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) ;
    
     */
    //创建多个线程用于填充图片
    for (int i = 0; i < 16; ++i) {
        //异步执行队列任务
        dispatch_async(serialQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]] ;
        }) ;
    }
}

- (void) loadImage:(NSNumber *)index{
    //如果在串行队列中会发现当前线程打印变化完全一样 因为她们在一个线程中
    NSLog(@"thread is:%@",[NSThread currentThread]) ;
    
    int i = [index intValue] ;
    //请求数据
    NSData * data = [self requestData:i] ;
    //更新UI界面 此处调用了GCD主线程队列的的方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue() ;
    //同步
    dispatch_sync(mainQueue, ^{
        [self updateImageWithData:data andIndex:i] ;
    }) ;
    
}

- (NSData *)requestData:(int)index{
    NSURL * url = [NSURL URLWithString:@"http://s6.mogujie.cn/b7/bao/131011/zovz9_kqyuwtdykfbgo2dwgfjeg5sckzsew_290x383.jpg_200x999.jpg"] ;
    NSData * data = [NSData dataWithContentsOfURL:url] ;
    return data ;
}
- (void)updateImageWithData:(NSData *)data andIndex:(int )index
{
    UIImage * image = [UIImage imageWithData:data] ;
    UIImageView * imageView = _imageViews[index] ;
    imageView.image = image ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    GCDViewController * gcd = [[GCDViewController alloc] init] ;
    [self.navigationController pushViewController:gcd animated:YES] ;
    NSLog(@"进入下一页") ;
}


@end
