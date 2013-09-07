//
//  InfoViewController.m
//  Latest News
//
//  Created by Inanc Sevinc on 9/3/12.
//  Copyright (c) 2012 idolabs. All rights reserved.
//

#import "InfoViewController.h"
#import <QuartzCore/CAGradientLayer.h>

@interface InfoViewController ()

@end

@implementation InfoViewController {
    NSArray *sourcesList;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sourcesTable.dataSource = self;
        _sourcesTable.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UISwipeGestureRecognizer* uiSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action: @selector(closeModalView)];
    uiSwipeGestureRecognizer.numberOfTouchesRequired = 1;
    uiSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    self.sourcesTable.rowHeight = 20;
    self.sourcesTable.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.sourcesTable.layer.borderWidth = 1.0;
    self.sourcesTable.layer.borderColor = [UIColor darkGrayColor].CGColor;

    [self.view addGestureRecognizer:uiSwipeGestureRecognizer];
    sourcesList = @[@"http://www.sozcu.com.tr",
                    @"http://www.posta.com.tr",
                    @"http://www.aa.com.tr",
                    @"http://www.iha.com.tr",
                    @"http://www.hurriyet.com.tr",
                    @"http://www.ntvmsnbc.com",
                    @"http://www.stargazete.com",
                    @"http://www.haberturk.com",
                    @"http://www.cnnturk.com",
                    @"http://www.zaman.com.tr",
                    @"http://www.trthaber.com",
                    @"http://www.gazetevatan.com",
                    @"http://www.sporx.com",
                    @"http://www.mackolik.com",
                    @"http://www.magaxin.com"];
}

- (void)viewDidUnload
{
    [self setSourcesTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) closeModalView{
    [self dismissModalViewControllerAnimated: YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sourcesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
       
    cell.textLabel.text = [sourcesList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Kaynaklar";
}


-(void)didReceiveMemoryWarning {
    //    [super didReceiveMemoryWarning]; causes table sections to overlap
    NSLog(@"infoviewcontroller received memory warning");
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, tableView.bounds.size.width, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = sectionTitle;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headerView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.7] CGColor], (id)[[[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.8] CGColor], nil];
    [headerView.layer insertSublayer:gradient atIndex:0];
    
    headerView.backgroundColor =  [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0];
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 20;
}


@end