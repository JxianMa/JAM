//
//  CommunicationHandler.m
//  Jam
//
//  Created by MaJixian on 2/9/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "CommunicationHandler.h"

@implementation CommunicationHandler

- (void)setupConnectionWithDisplayName:(NSString *)displayName
{
    self.peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
}

- (void)setupSession
{
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)setupBrowser
{
    self.browser = [[MCBrowserViewController alloc]initWithServiceType:@"JAM-CPS" session:_session];
}

- (void)advertiseSelf
{
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"JAM-CPS" discoveryInfo:nil session:self.session];
    [self.advertiser start];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSDictionary *userInfo = @{@"peerID":peerID,@"state":@(state)};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JAM_targetDisconnectedWithNotification" object:nil userInfo:userInfo];
    });
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary *userInfo = @{@"data":data,@"peerID":peerID};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"JAM_DidReceiveDataNotification" object:nil userInfo:userInfo];
    });
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}



@end
