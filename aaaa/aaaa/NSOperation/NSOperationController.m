//
//  NSOperationController.m
//  aaaa
//
//  Created by 最爱是深蓝 on 2017/11/21.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "NSOperationController.h"
#import "BlockOperationController.h"
@interface NSOperationController ()
{
     UIImageView * _imageView ;
}

@end
//加载一张图片  NSInvocationOeration
/*
 使用NSOperation和NSOperationQueue进行多线程开发类似于C#中的线程池，只要将一个NSOperation（实际开中需要使用其子类NSInvocationOperation、NSBlockOperation）放到NSOperationQueue这个队列中线程就会依次启动。NSOperationQueue负责管理、执行所有的NSOperation，在这个过程中可以更加容易的管理线程总数和控制线程之间的依赖关系。
 
 NSOperation有两个常用子类用于创建线程操作：NSInvocationOperation和NSBlockOperation，两种方式本质没有区别，但是是后者使用Block形式进行代码组织，使用相对方便
 */
@implementation NSOperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor] ;
    self.title = @"单线程" ;
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
    //创建一个调用操作  object:调用方法参数
    NSInvocationOperation * invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage) object:nil] ;
    //创建完NSInvocationoperation对象并不会调用，它由一个start方法启动操作，但是注意直接调用start方法，则此操作会在主线程中调用，一般不会这么操作，而是添加到NSOperationQueue中
    //[invocationOperation start] ;
    
    //创建操作队列
    NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init] ;
    //注意添加到操作队列后，队列会开启一个线程执行此操作
    [operationQueue addOperation:invocationOperation] ;
}

#pragma  mark - 请求图片数据
- (NSData *)requestData
{
    NSURL * url = [NSURL URLWithString:@"http://s6.mogujie.cn/b7/bao/131010/10ssu8_kqytgrc7kfbgutcugfjeg5sckzsew_375x575.jpg_200x999.jpg"] ;
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
    NSLog(@"加载图片") ;
}

#pragma mark - 显示图片
- (void)updateImage:(NSData *)imageData
{
    UIImage * image = [UIImage imageWithData:imageData] ;
    _imageView.image = image ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BlockOperationController * block = [[BlockOperationController alloc] init] ;
    [self.navigationController pushViewController:block animated:YES] ;
     NSLog(@"进入下一页") ;
}

@end
