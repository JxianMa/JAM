//
//  CommunicationHandler.h
//  Jam
//
//  Created by MaJixian on 2/9/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CommunicationHandler : NSObject <MCSessionDelegate>

@property (nonatomic,strong) MCPeerID *peerID;
@property (nonatomic,strong) MCSession *session;
@property (nonatomic,strong) MCBrowserViewController *browser;
@property (nonatomic,strong) MCAdvertiserAssistant *advertiser;

- (void)setupConnectionWithDisplayName :(NSString *)displayName;
- (void)setupSession;
- (void)setupBrowser;
- (void)advertiseSelf;

@end
