//
//  ViewController.m
//  iOS - Socket
//
//  Created by xyanl on 2019/5/17.
//  Copyright © 2019 xyanl. All rights reserved.
//
/**
 Socket定义: 操作某个 IP 上某个端口来点对点通讯的效果
 
 开启两个终端 一个终端命令
 nc -l 6969  模拟服务器
 另一个终端命令
 nc 127.0.0.1 6969
 这两个终端就可以通信了
 
 
 TCP 的三次握手
 ACK:TCP协议规定,只有 ACK=1 时有效,也规定链接建立后所有发送的保温的 ACK 必须为 1
 SYN:在连接建立时用的同步序号,当 SYN=1 而ACK=0 时,表明这是一个连接请求报文.对方若同意简历连接,则应在响应报文中使SYN=1 和 ACK=1.因此,SYN=1 就表示这是一个连接请求或连接接受报文.
 FIN(finis)完,终结的意思.用来释放一个连接.当 FIN=1 时,表明此报文段的发送方的数据已经发送完毕,并w要求释放连接.
 
 TCP 四次挥手(断开连接)
 TCP 模式: 全双工,即互相发送发送数据
 客户端发送断开请求(第一次挥手),服务端回应断开请求(第二次挥手),这是两次挥手,但是因为TCP模式是全双工,所以,现在两者间的连接是没有断开的,还需要服务端发送断开请求(第三次挥手),然后客户端回应请求(第四次挥手),这时两者间才是彻底断开连接了.
 
 
 UDP  数据报文
 
 
 */

/**
 为什么是三次握手,而不是两次?
 最后一次是为了防止带宽资源浪费
 假如只有两次握手,第一次握手报文发送失败、超时了,那么会重新发送一次,这一次成功了,并且第二次握手也成功了,然后交互数据完成,断开第一次连接,这时之前那一次失败超时的握手又发送过来,并且成功建立握手,接着第二次握手也成功了,但是这时已经不需要交互数据了,所以现在的连接已经没有用了,就会造成带宽资源浪费了
 */
#import "ViewController.h"
//导入头文件
#import <netinet/in.h>
#import <sys/socket.h>
#import <arpa/inet.h>


//static const char * serevr_ip = "127.0.0.1";
//static const short  serevr_port = 2345;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (assign, nonatomic) int clientSocket;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSocket];
}


- (void) initSocket{
    // 一、创建 soket
    /**
     参数
     第一个参数:adress_family,协议簇 AF_INET --->IPV4
     第二个参数:数据格式 -->SOCK_STREAM(TCP)/SOCK_DGRAM(UDP)
     第三个参数:protocl IPPROTO_TCP,如果传入 0,会自动根据第二个参数,选中合适的协议.默认填 0 就可以
     返回值:成功 ----> 正值  失败---->-1
     */
    _clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (_clientSocket == -1) {
        NSLog(@"创建失败");
       
        return;
    }
    // 二、创建连接
    /**
     参数
     第一个参数: 客户端 socket
     第二个参数: 指向数据结构 socketAddr 的指针,其中包括目的IP地址 和端口.
     第三个参数: 结构体数据长度
     返回值:成功 ---->0  失败---->其他错误代号
     */
    struct sockaddr_in sAddr;
    sAddr.sin_len = sizeof(sAddr);//地址
    sAddr.sin_family = AF_INET; // 指定协议簇
    inet_aton("127.0.0.1", &sAddr.sin_addr);
//    sAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    // 端口转换,
    sAddr.sin_port = htons(6548);
    
    int connectFlag = connect(_clientSocket, (struct sockaddr *)&sAddr, sizeof(sAddr));
    
    if (connectFlag == 0) {
        NSLog(@"连接成功");
        NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveAction) object:nil];
        [thread start];
    }else{
        NSLog(@"连接失败");
    }
}

- (void)receiveAction{
    while (1) {
        char rec_msg[1024] = {0};
        recv(_clientSocket, rec_msg, sizeof(rec_msg), 0);
        printf("%s\n",rec_msg);
    }
}

- (void)sendMessage:(NSString *)msg{
    const char * send_message = [msg cStringUsingEncoding:NSUTF8StringEncoding];
    send(_clientSocket, send_message, strlen(send_message), 0);
    _msgTextField.text = @"";
}

- (IBAction)sendAction:(id)sender{
    if ([_msgTextField.text isEqualToString:@""]) {
        NSLog(@"发送的消息不能为空");
        return;
    }
    [self sendMessage:_msgTextField.text];
}
- (IBAction)connectSocket:(UIButton *)sender {
}
@end
