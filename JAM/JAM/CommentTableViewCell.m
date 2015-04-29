//
//  CommentTableViewCell.m
//  JAM
//
//  Created by MaJixian on 4/12/15.
//  Copyright (c) 2015 MaJixian. All rights reserved.
//

#import "CommentTableViewCell.h"
#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
@implementation CommentTableViewCell

-(void)setComment:(CommentModel *)comment
{
    _comment = comment;
    self.commentLabel.text = _comment.comment;
    double uploadTime = [_comment.uploadTime doubleValue];
    double currentTime = [[NSDate date] timeIntervalSince1970];
    NSInteger ti = currentTime - uploadTime;
    NSInteger hours = (ti / 3600);
    if (hours > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld hours ago", (long)hours];
    }else {
        NSInteger mins = (ti/60);
        if (mins > 0) {
            self.timeLabel.text = [NSString stringWithFormat:@"%ld mins ago", (long)mins];
        }else {
            NSInteger secs = ti;
            if (secs > 0) {
                self.timeLabel.text = [NSString stringWithFormat:@"%ld secs ago", (long)secs];
            }else {
                self.timeLabel.text = [NSString stringWithFormat:@"0 secs ago"];
            }
        }
    }
    [self setNeedsLayout];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10.0f, 10.0f, 240.0f, 20.0f);
    self.detailTextLabel.frame = CGRectMake(80.0f, 10.0f, 240.0f, 20.0f);
}


@end
