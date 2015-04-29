//
//  selfStoryTableViewCell.h
//  JAM
//
//  Created by MaJixian on 4/5/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface selfStoryTableViewCell : UITableViewCell

@property (nonatomic,strong)Story *selfStoryInfo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic, assign) double longtitude;
@property (nonatomic, assign) double latitude;
@end
