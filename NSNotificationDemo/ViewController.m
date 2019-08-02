//
//  ViewController.m
//  NSNotificationDemo
//
//  Created by Helios on 2019/8/2.
//  Copyright © 2019 Helios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static int count = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //观察方式1:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action) name:@"cctnoti" object:nil];
    
    /**
     观察方式2:

     @param queue:指定执行的队列，主队列：[NSOperationQueue mainQueue]
     */
    [[NSNotificationCenter defaultCenter] addObserverForName:@"cctnoti" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
//        NSLog(@"current thread %@ 刷新UI", [NSThread currentThread]);
        NSLog(@"noti B %d", ++count);
    }];
    
    [self addNotiAction];
}

- (void)action{
    // 问题  ：postNotificationName方法，是同步的还是异步的？
    // 答案  ：同步
    NSLog(@"noti A %d", ++count);
}

- (void)addNotiAction{
    
    //发送方式1:
//    NSNotification *noti = [NSNotification notificationWithName:@"cctnoti" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:noti];
//
//    //发送方式2:
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"cctnoti" object:nil];
    
    
    // ————————————————————————————————————————————————————————————
    
    //异步发送通知：
    /*
     NSPostWhenIdle = 1, // 当runloop处于空闲状态时post
     NSPostASAP = 2,     // 当当前runloop完成之后立即post
     NSPostNow = 3       // 立即post，同步
    */
//    NSNotification *noti = [NSNotification notificationWithName:@"cctnoti" object:nil];
//    [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostASAP];
//    NSLog(@"测试同步还是异步");
    
    
    // ————————————————————————————————————————————————————————————
    
    //对当前队列的通知根据NSNotificationCoalescing类型进行合成（即将几个合成一个）。
    
    /*
     NSNotificationNoCoalescing = 0,  // 不合成
     NSNotificationCoalescingOnName = 1,  // 根据NSNotification的name字段进行合成
     NSNotificationCoalescingOnSender = 2  // 根据NSNotification的object字段进行合成
     */
    
//    NSNotification *noti = [NSNotification notificationWithName:@"cctnoti" object:nil];
//    [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostASAP coalesceMask:NSNotificationNoCoalescing forModes:nil];
//    [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:nil];
//    [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostNow coalesceMask:NSNotificationNoCoalescing forModes:nil];
//    NSLog(@"测试同步还是异步");
    
    NSNotification *noti = [NSNotification notificationWithName:@"cctnoti" object:nil];
    [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostWhenIdle coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    [[NSNotificationQueue defaultQueue] enqueueNotification:noti postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnName forModes:nil];
    NSLog(@"测试同步还是异步");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //忘记remove的问题
    //若在iOS8或之前版本系统中，对一个对象addObserver:selector:name:object:（假设name为@“111”），
    //但是并没有在dealloc的之前或之中，对其进行remove操作。那么，在发送通知（name为@“111”）的时候，会因为bad_access（野指针）而crash。
    //若在iOS9及以后，同上操作，不会crash。
    
//    iOS8及以前，NSNotificationCenter持有的是观察者的unsafe_unretained指针（可能是为了兼容老版本），
//    这样，在观察者回收的时候未removeOberser，而后再进行post操作，则会向一段被回收的区域发送消息，所以出现野指针crash。
//    而iOS9以后，unsafe_unretained改成了weak指针，即使dealloc的时候未removeOberser，再进行post操作，则会向nil发送消息，所以没有任何问题。

}

@end
