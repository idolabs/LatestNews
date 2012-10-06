//
//  ArticleListViewController.h
//  HorizontalTables
//
//  Created by Mehmet Bahaddin Yasar on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainTableViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


- (IBAction)refreshButtonAction:(id)sender;

- (void) reloadData;

@end
