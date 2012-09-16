//
//  ArticleCell.m
//  HorizontalTables
//
//  Created by Mehmet Bahaddin Yasar on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsItemCell.h"
#import "../AppConstants.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewsItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
   
    if(self) {
        
        _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                frame.size.width - NEWS_ITEM_CELL_IMAGE_PADDING,
                                                                                frame.size.height-10)];
        _thumbnailImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _thumbnailImageView.layer.borderWidth = NEWS_ITEM_CELL_IMAGE_BORDER_WIDTH;
        
        [self.contentView addSubview:_thumbnailImageView];
        
        _titleLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        _thumbnailImageView.frame.size.height * (1.0 - NEWS_ITEM_CELL_LABEL_VIEW_HEIGHT_RATIO),
                                                                        _thumbnailImageView.frame.size.width,
                                                                        _thumbnailImageView.frame.size.height * NEWS_ITEM_CELL_LABEL_VIEW_HEIGHT_RATIO)];
        
        _titleLabelView.backgroundColor = NEWS_ITEM_CELL_LABEL_BACKGROUND_COLOR;
        _titleLabelView.textColor = NEWS_ITEM_CELL_LABEL_COLOR;
        _titleLabelView.font = NEWS_ITEM_CELL_LABEL_FONT;
        _titleLabelView.numberOfLines = NEWS_ITEM_CELL_LABEL_NUMBER_OF_LINES;
        _titleLabelView.textAlignment = UITextAlignmentCenter;
        
        [_thumbnailImageView addSubview:_titleLabelView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(NEWS_ITEM_CELL_ROTATION);
    }
    return self;
}

@end
