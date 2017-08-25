//
//  ViewController.m
//  iosCeshi
//
//  Created by 最爱是深蓝 on 2017/8/18.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIImageView * imV ;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImage * im = [UIImage imageNamed:@"杨5.jpeg"] ;
     _imV = [[UIImageView alloc]initWithImage:im] ;
    _imV.frame = CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/4, 200, 300) ;
     _imV.userInteractionEnabled = YES ;
    [self.view addSubview:_imV] ;
    
    //创建点击手势
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1)] ;
   UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)] ;
    //创建捏合手势
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)] ;
    
    //创建旋转手势
    UIRotationGestureRecognizer * rot = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rote:)] ;
    
    //创建滑动手势
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)] ;
    
    //创建长按手势
    UILongPressGestureRecognizer * lone = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lone:)] ;
    
    //创建平移手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] ;
    
    
    //设置长安手势的触发时间 默认是0.5
    lone.minimumPressDuration = 3 ;
    
    //向右滑动或向左
    swipe.direction = UISwipeGestureRecognizerDirectionRight |UISwipeGestureRecognizerDirectionLeft ;
    
    //点击次数
    tap.numberOfTapsRequired = 1 ;
    //点击手指数
    tap.numberOfTouchesRequired = 1 ;
    
    tap1.numberOfTapsRequired = 2 ;
    tap1.numberOfTouchesRequired = 1 ;
    
    
    pinch.delegate = self ;
    rot.delegate   = self ;
    
    [_imV addGestureRecognizer:tap1] ;
    
    [_imV addGestureRecognizer:tap] ;
    
    [_imV addGestureRecognizer:pinch] ;
    
    [_imV addGestureRecognizer:rot] ;
    
    [_imV addGestureRecognizer:swipe] ;
    
    [_imV addGestureRecognizer:lone] ;
    
    [_imV addGestureRecognizer:pan] ;
    
    //双击的时候消除单机效果
    [tap requireGestureRecognizerToFail:tap1] ;
    
}
-(void)tap1
{
    NSLog(@"点击一次") ;
    //开始动画过程
    [UIView beginAnimations:nil context:nil] ;
    
    //动画时间 1秒
    [UIView setAnimationDuration:1] ;
    
    _imV.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    
    //动画结束
    [UIView commitAnimations] ;
    
}
-(void)tap2
{
    NSLog(@"点击两次") ;
    [UIView beginAnimations:nil context:nil] ;
    [UIView setAnimationDuration:1] ;
    
    _imV.frame = CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/4, 200, 300) ;
    
    [UIView commitAnimations] ;
}

//捏合手势
-(void)pinch:(UIPinchGestureRecognizer * )pin
{
    
    NSLog(@"放大or缩小") ;
    //获取监控视图对象
    UIImageView * ima = (UIImageView * )pin.view ;
    
    
    //对图像视图对象进行矩阵变换计算并赋值
    //transform：表示图形学中的变换矩阵
    //CGAffineTransformScale：通过缩放的方式形成一个新的矩阵
    //C1:原来的矩阵 C2:x轴的缩放比例 C3:y轴的缩放比例
    //返回值是缩放后的新矩阵
    ima.transform = CGAffineTransformScale(ima.transform, pin.scale, pin.scale) ;
    
    //将缩放值归位为单位值
    pin.scale = 1 ;
    
    
}

//旋转
-(void)rote:(UIRotationGestureRecognizer * )rot
{
    
    NSLog(@"旋转") ;
    UIImageView * ima = (UIImageView *)rot.view ;
    //计算旋转的变换矩阵并赋值
    ima.transform = CGAffineTransformRotate(ima.transform, rot.rotation) ;
    //选择角度清零
    rot.rotation = 0 ;
}
//是否可以同时响应两个手势 yes，no
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//滑动手势
-(void)swipe:(UISwipeGestureRecognizer * )sw
{
    if (sw.direction & UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"右滑") ;
    }
    else if (sw.direction & UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"左滑") ;
    }
}
//长按手势
-(void)lone:(UILongPressGestureRecognizer * )lon
{
    //手指的状态 到达三秒触发函数
    if (lon.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始") ;
    //离开屏幕时结束
    }else if (lon.state == UIGestureRecognizerStateEnded){
        NSLog(@"结束") ;
    }
}

//平移手势
-(void)pan:(UIPanGestureRecognizer *)pa
{
    
    //获取当前相对于按下点的坐标 即移动的偏移量
    CGPoint  pt = [pa translationInView:self.view] ;
    
    pa.view.center = CGPointMake(pa.view.center.x + pt.x, pa.view.center.y + pt.y) ;
    //将当前偏移量归零
    [pa setTranslation:CGPointZero inView:self.view] ;

    
    //获取移动时的相对速度
  //  CGPoint pta = [pa velocityInView:self.view] ;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
