//
//  ViewController.m
//  SocketDemo
//
//  Created by shen on 15/6/12.
//  Copyright (c) 2015年 shen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


//连接Socket 服务器
- (void)viewDidLoad {
    [super viewDidLoad];
    asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *err = nil;
    
    if(![asyncSocket connectToHost:@"localhost" onPort:12345 error:&err])
    {
        NSLog(@"Error: %@", err);
    }
    

}

// 连接成功回调
#pragma mark  - 连接成功回调
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    [sock readDataWithTimeout:1 tag:0];
    
    NSData* aData= [@"Fuck you" dataUsingEncoding: NSUTF8StringEncoding];
    [asyncSocket writeData:aData withTimeout:-1 tag:1];
}


//收到数据，解析，并返回
-(void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Receive string:%@",aStr);
    [sock readDataWithTimeout:1 tag:0];

}


- (void)onSocket:(AsyncSocket *)sock didSecure:(BOOL)flag
{
    NSLog(@"onSocket:%p didSecure:YES", sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"onSocket:%p willDisconnectWithError:%@", sock, err);
}

//断开连接
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //断开连接了
    NSLog(@"onSocketDidDisconnect:%p", sock);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
    asyncSocket=nil;
}
@end
