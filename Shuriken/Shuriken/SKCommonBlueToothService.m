//
//  SKCommonBlueToothService.m
//  Shuriken
//
//  Created by Orange on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SKCommonBlueToothService.h"
#define C2S_SESSION_ID @"sksessionc2s"

@implementation SKCommonBlueToothService
@synthesize delegate = _delegate;
@synthesize peerName = _peerName;

- (id)initWithName:(NSString*)aName 
{
    self = [super init];
    if (self) {
        self.peerName = aName;
    }
    return self;
}

- (void)findDevice
{
    GKPeerPickerController* _picker = [[GKPeerPickerController alloc] init];
    
    _picker.delegate = self;
    
    _picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    
    [_picker show];
}

- (void)sendData:(NSData*)data
{
    [_currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}

#pragma --peerpickercontroller delegate

-(GKSession *) peerPickerController: (GKPeerPickerController*) controller
           sessionForConnectionType: (GKPeerPickerConnectionType) type {
    if (!_currentSession) {
        _currentSession = [[GKSession alloc]
                           initWithSessionID:C2S_SESSION_ID
                           displayName:self.peerName//在线用户名
                           sessionMode:GKSessionModePeer];
        _currentSession.delegate = self;
    }
    [_currentSession setDataReceiveHandler:self withContext:nil];
    return _currentSession;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    //当picker接收到数据后将其释放掉，否则进入不了界面,这里是发起请求端的操作
    [picker dismiss];
    picker.delegate = nil;
    _actingAsHost = NO;//设为客户端
    if (_delegate && [_delegate respondsToSelector:@selector(didConnectToDevice:)]) {
        [_delegate didConnectToDevice:peerID];
    }
}
- (void)session:(GKSession *)session
didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    //已接受连接请求的代理方法，这里是接受请求端的操作
    _actingAsHost = NO;//设为客户端
    if (_delegate && [_delegate respondsToSelector:@selector(acceptDevice)]) {
        [_delegate acceptDevice];
    }
}

- (void)session:(GKSession *)session peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:
            [session setDataReceiveHandler: self withContext: nil];
            //这里待测试一下，把触发游戏开关设在这里
            break;
        case GKPeerStateAvailable:
            break;
        case GKPeerStateDisconnected:
            if (_delegate && [_delegate respondsToSelector:@selector(disconnectFromSession)]) {
                [_delegate disconnectFromSession];
            }
            break;
        case GKPeerStateConnecting:
            break;
        case GKPeerStateUnavailable:
            break;
            default:
            break;
    }
    
}

- (void) receiveData: (NSData*) data fromPeer: (NSString*) peerID
           inSession: (GKSession*) session context: (void*) context {
    if (_delegate && [_delegate respondsToSelector:@selector(receiveData:fromPeer:)]) {
        [_delegate receiveData:data fromPeer:peerID];
    }
}


@end
