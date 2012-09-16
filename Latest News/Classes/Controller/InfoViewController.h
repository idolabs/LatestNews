//
//  InfoViewController.h
//  Latest News
//
//  Created by Inanc Sevinc on 9/3/12.
//  Copyright (c) 2012 idolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *sourcesTable;

@end
