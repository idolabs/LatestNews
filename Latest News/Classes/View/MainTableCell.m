//
//  HorizontalTableCell.m
//  HorizontalTables
//
//  Created by Mehmet Bahaddin Yasar on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainTableCell.h"
#import "NewsItemCell.h"
#import "../AppConstants.h"
#import "NewsItem.h"
#import "../../Libraries/SDWebImage/SDWebImage/UIImageView+WebCache.h"
#import "MainTableViewController.h"
#import "AppDelegate.h"


@implementation MainTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _newsItemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [self.newsItemsForSingleSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NewsItemCell *cell = (NewsItemCell *)[tableView dequeueReusableCellWithIdentifier:STORYBOARD_KEY__ID__NEWS_ITEM_TABLE_CELL];
    
    if (cell == nil) 
    {
        cell = [[NewsItemCell alloc] initWithFrame:CGRectMake(0, 0, MAIN_TABLE_CELL__NEWS_ITEM_CELL_WIDTH, MAIN_TABLE_CELL__NEWS_ITEM_CELL_HEIGHT)];
    }
    
	NewsItem *currentNewsItem = [self.newsItemsForSingleSource objectAtIndex:indexPath.row];
    NSString* imageURL = currentNewsItem.imageUrl;

    if ( [imageURL length] > 0 ) {
        [cell.thumbnailImageView setImageWithURL: [NSURL  URLWithString: [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ];
    }
    else {
        // placeholder if no image available
        cell.thumbnailImageView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.9];
    }

    cell.titleLabelView.text = currentNewsItem.title;
    cell.newsItem = currentNewsItem;
    
    return cell;
}

- (NSString *) reuseIdentifier 
{
    return STORYBOARD_KEY__ID__MAIN_TABLE_CELL;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        _newsItemsTableView = [[UITableView alloc] initWithFrame:frame];
        _newsItemsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _newsItemsTableView.showsVerticalScrollIndicator = NO;
        _newsItemsTableView.showsHorizontalScrollIndicator = NO;

        _newsItemsTableView.transform = CGAffineTransformMakeRotation(MAIN_TABLE_CELL__NEWS_ITEMS_TABLE_ROTATION);
        
        
        [_newsItemsTableView setFrame:CGRectMake(0,
                                                      0, 
                                                      frame.size.width,
                                                      MAIN_TABLE_CELL__NEWS_ITEM_CELL_HEIGHT)];
        
       // self.horizontalTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);

        _newsItemsTableView.rowHeight = MAIN_TABLE_CELL__NEWS_ITEM_CELL_WIDTH;
        _newsItemsTableView.backgroundColor = MAIN_TABLE_CELL__NEWS_ITEMS_TABLE_BACKGROUND_COLOR;
        
        _newsItemsTableView.dataSource = self;
        _newsItemsTableView.delegate = self;
        [self addSubview:_newsItemsTableView];
    }
    
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([AppDelegate isInternetConnectionAvailable]) {
    
        NewsItemCell *cell = (NewsItemCell *)[tableView cellForRowAtIndexPath:indexPath];
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.sharedContext setObject:cell.newsItem forKey:SHARED_CONTEXT_KEY_SELECTED_NEWS_ITEM];
        MainTableViewController* articleListViewController = (MainTableViewController*)[appDelegate.sharedContext objectForKey: [SHARED_CONTEXT_KEY__VIEW_CONTROLLERS_PREFIX stringByAppendingString: NSStringFromClass([MainTableViewController class])]];
        [articleListViewController performSegueWithIdentifier:STORYBOARD_KEY__SEGUE__NEWS_ITEM_WEB_VIEW sender:self];
    }
}

@end