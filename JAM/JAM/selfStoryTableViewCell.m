//
//  selfStoryTableViewCell.m
//  JAM
//
//  Created by MaJixian on 4/5/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "selfStoryTableViewCell.h"
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@implementation selfStoryTableViewCell


- (void)setSelfStoryInfo:(Story *)selfStoryInfo
{
    _selfStoryInfo = selfStoryInfo;
    self.textLabel.text = _selfStoryInfo.storyName;
    self.detailTextLabel.text = _selfStoryInfo.storyDescription;
    self.imageView.image = [UIImage imageWithData:_selfStoryInfo.photo scale:0.5];
    self.longtitude = [_selfStoryInfo.longtitude doubleValue];
    self.latitude = [_selfStoryInfo.latitude doubleValue];
    [self setNeedsLayout];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.backgroundColor = Rgb2UIColor(235,235,235);
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    return self;
}

// Custmoize the size and position of imageView and textLabel
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 60.0f, 60.0f);
    self.textLabel.frame = CGRectMake(80.0f, 10.0f, 240.0f, 20.0f);
    self.detailTextLabel.frame = CGRectMake(80.0f, 30.0f, 240.0f, 20.0f);
}




@end
