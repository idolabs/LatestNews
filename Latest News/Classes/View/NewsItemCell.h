//
//  ArticleCell.h
//  HorizontalTables
//
//  Created by Mehmet Bahaddin Yasar on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/NewsItem.h"

@interface NewsItemCell : UITableViewCell

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabelView;
@property (nonatomic, strong) NewsItem *newsItem;

@end
