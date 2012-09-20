//
//  ArticleListViewController.m
//  HorizontalTables
//
//  Created by Mehmet Bahaddin Yasar on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainTableViewController.h"
#import "../View/MainTableCell.h"
#import "../AppConstants.h"
#import "NewsItem.h"
#import "AppDelegate.h"
#import "../../Libraries/AFNetworking/AFXMLRequestOperation.h"
#import "../../Libraries/AFNetworking/AFHTTPRequestOperation.h"
#import "../../Libraries/AFNetworking/AFGDataXMLRequestOperation.h"
#import "../../Libraries/AFNetworking/AFNetworkActivityIndicatorManager.h"
#import <QuartzCore/CAGradientLayer.h>
#import <dispatch/dispatch.h>

@interface MainTableViewController()

@property (strong, nonatomic) UIBarButtonItem *loadingViewButton;

@end

@implementation MainTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // let AFNetworking manage the status bar Network Activity Indicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.sharedContext setObject:self forKey:[SHARED_CONTEXT_KEY__VIEW_CONTROLLERS_PREFIX stringByAppendingString: NSStringFromClass([MainTableViewController class])]];
     
    // set up a refresh button placeholder view which is shown while there is network activity
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingViewButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    self.loadingViewButton.style = UIBarButtonItemStyleBordered;
    [activityView startAnimating];
    
    // create an info button at the bottom right corner of the screen
    self.infoButton = [UIButton buttonWithType: UIButtonTypeInfoDark];
    [self.infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:self.infoButton];
    CGSize frameSize = self.navigationController.view.frame.size;
    [self.infoButton setFrame:CGRectMake(frameSize.width-(self.infoButton.frame.size.width+5),
                                         frameSize.height-(self.infoButton.frame.size.height+5),
                                         self.infoButton.frame.size.width,
                                         self.infoButton.frame.size.height)];
    
    // define struts for right and bottom margins
    self.infoButton.autoresizingMask = ( UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    // highligt the info button for 1 sec
    [self infoButtonHighlighting:@"on"];
    
    NSMutableDictionary* rssSourcesData = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"rss_sources" ofType:@"plist"]];
    NSArray* sortedRssSourcesKeys = [rssSourcesData.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    [[AppDelegate getSharedContextInstance] setObject:rssSourcesData forKey:SHARED_CONTEXT_KEY_ALL_NEWS_DATA];
    [[AppDelegate getSharedContextInstance] setObject:sortedRssSourcesKeys forKey:SHARED_CONTEXT_KEY__SORTED_RSS_SOURCES_KEYS];

    [self loadData];
}

-(void)infoButtonPressed:(UIButton*)sender {
    [self performSegueWithIdentifier:@"infoCurlSegue" sender:sender];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear: animated];
}
// simulate refresh button tap when device is shaked
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event {
    if(motion==UIEventSubtypeMotionShake) {
        [self loadData];
    }
}

-(void)loadData {

    if([AppDelegate isInternetConnectionAvailable]) {
        
        [self.navigationItem setRightBarButtonItem:self.loadingViewButton];
        [self.navigationController.navigationBar setNeedsDisplay];
        [self performSelector:@selector(updateRefreshButtonActivityIndicator) withObject:nil afterDelay:1.0f];
       
        NSMutableDictionary* rssSourcesData = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"rss_sources" ofType:@"plist"]];
        
        [[AppDelegate getSharedContextInstance] setObject:rssSourcesData forKey:SHARED_CONTEXT_KEY_ALL_NEWS_DATA];
        [self.tableView reloadData];
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            @autoreleasepool {
                [self sendAFRequest];
            }
        });
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self allNewsData].allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* newsItemSourceKey = [[self sortedRssSourcesKeys] objectAtIndex:section];
    if( [[[[self allNewsData] objectForKey:newsItemSourceKey] objectForKey:@"data"] count]>0) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableCell *cell = [[MainTableCell alloc] initWithFrame: tableView.frame];

    NSString* newsItemSourceKey = [[self sortedRssSourcesKeys] objectAtIndex:indexPath.section];
    cell.newsItemsForSingleSource = [[[self allNewsData] objectForKey:newsItemSourceKey] objectForKey:@"data"];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* newsItemSourceKey = [[self sortedRssSourcesKeys] objectAtIndex:section];
    return [[[self allNewsData] objectForKey:newsItemSourceKey] objectForKey:@"name"];
}

- (void)awakeFromNib
{
    self.tableView.rowHeight = MAIN_TABLE_CELL__NEWS_ITEM_CELL_HEIGHT;
}

-(void)infoButtonHighlighting:(NSString*)mode{
    if([mode isEqualToString:@"on"]){
        [self.infoButton setHighlighted:YES];
        [self performSelector:@selector(infoButtonHighlighting:) withObject:@"off" afterDelay:1];
    }
    else{
        [self.infoButton setHighlighted:NO];
    }
}

-(void) updateRefreshButtonActivityIndicator {
    if( [UIApplication sharedApplication].networkActivityIndicatorVisible ) {
        [self performSelector:@selector(updateRefreshButtonActivityIndicator) withObject:nil afterDelay:1];
    }
    else{
        [self.navigationItem setRightBarButtonItem:self.refreshButton];
    }
}

-(void) setFilteredRssSourcesData {
    
    NSMutableDictionary* rssSourcesData = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"rss_sources" ofType:@"plist"]];
    [[AppDelegate getSharedContextInstance] setObject:rssSourcesData forKey:SHARED_CONTEXT_KEY_ALL_NEWS_DATA];

}

- (void) sendAFRequest
{
    NSMutableDictionary* rssSourcesData = [[AppDelegate getSharedContextInstance] objectForKey:SHARED_CONTEXT_KEY_ALL_NEWS_DATA];
    [AFGDataXMLRequestOperation addAcceptableContentTypes: [NSSet setWithObjects:@"application/rss+xml", nil]];
    
    for (NSString* theKey in [rssSourcesData allKeys]) {
        
        NSURL *url = [NSURL URLWithString:[[rssSourcesData objectForKey:theKey] objectForKey:@"url"] ];
        NSURLRequest *initialRequest = [NSURLRequest requestWithURL:url];
        
        AFGDataXMLRequestOperation *oper = [AFGDataXMLRequestOperation XMLDocumentRequestOperationWithRequest:initialRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, GDataXMLDocument *XMLDocument) {
            @autoreleasepool {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    @autoreleasepool {
                        [self parseDataInBackground:XMLDocument forKey:theKey];
                    }
                });
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, GDataXMLDocument *XMLDocument) {
            @autoreleasepool {
                NSLog(@"failure handler: %@",theKey);
            }
        }];
        
        [oper start];
    }
}

-(void) parseDataInBackground:(GDataXMLDocument*)XMLDocument forKey:(NSString*)theKey {

    static NSRegularExpression *imageUrlRegex = nil;
    if(!imageUrlRegex) {
        imageUrlRegex = [NSRegularExpression regularExpressionWithPattern:@"(http\\S+\\.(png|jpg|jpeg|gif)+)"
                                                                  options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    if(!XMLDocument)
        return;
    NSArray* items = [XMLDocument nodesForXPath:@"/rss/channel/item" error:nil];
    if(!items)
        return;
    
    NSString* rssChannelLink = [[[XMLDocument nodesForXPath:@"/rss/channel/link" error:nil] objectAtIndex:0] stringValue];
    XMLDocument = nil;
    NSMutableArray* newsItems = [[NSMutableArray alloc]init];
    NSMutableDictionary *linksDictionary = [[NSMutableDictionary alloc] init];
    for (GDataXMLNode* item in items) {
        @autoreleasepool { // to lower memory peaks, causes objects to be released in each loop iteration
            
            NSString* link  = [self parseNode:item forXPath:@"link/text()"  andNamespaces:nil];
            NSString* title = [self parseNode:item forXPath:@"title/text()" andNamespaces:nil];
            
            // eliminate duplicate items
            if([linksDictionary objectForKey:link] || !(link.length>0) || !(title.length>0))
                continue;

            [linksDictionary setObject:link forKey:link];

            NSString* imageUrl = nil;
            
            imageUrl = [self parseNode:item forXPath:@"media:thumbnail/@url" andNamespaces:@{ @"media": @"http://search.yahoo.com/mrss/"}];

            if(!(imageUrl.length>0)){
                [self parseNode:item forXPath:@"media:content/@url" andNamespaces:@{ @"media": @"http://search.yahoo.com/mrss/"}];
                
                if(!(imageUrl.length>0)){
                    
                    imageUrl = [self parseNode:item forXPath:@"img/text()" andNamespaces:nil];
                    
                    if(imageUrl.length>0){
                         // if the imageUrl is a relative link then concatenate it with the rss.link
                        if([imageUrl hasPrefix:@"http"] == NO){
                            imageUrl = [rssChannelLink stringByAppendingString:imageUrl];
                        }
                    }
                    else {
                        imageUrl = [self parseNode:item forXPath:@"enclosure/@url" andNamespaces:nil];
                    
                        if(!(imageUrl.length>0)){ // search description text for image urls
                            
                            NSString *description = [self parseNode:item forXPath:@"description/text()" andNamespaces:nil];
                            
                            if(description.length>0){
                                NSRange range = [[imageUrlRegex firstMatchInString:description options:0 range:NSMakeRange(0, [description length])] range];
                                imageUrl = [description substringWithRange:range];
                                description = nil;
                            }
                        }
                    }
                }
            }
            
            if(!(imageUrl.length>0))
                continue;

            [newsItems addObject:[[NewsItem alloc] initWithTitle:title andContentUrl:link andImageUrl:imageUrl]];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            [[[self allNewsData] objectForKey:theKey] setObject:newsItems forKey:@"data"];
            //reload only relevant section
            int sectionIndex = [[self sortedRssSourcesKeys] indexOfObject:theKey];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndex, 1)];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
        }
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, tableView.bounds.size.width, MAIN_TABLE_VIEW__HEADER_SECTION_HEIGHT);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = sectionTitle;

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, MAIN_TABLE_VIEW__HEADER_SECTION_HEIGHT)];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headerView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.7] CGColor], (id)[[[UIColor alloc] initWithRed:0.1 green:0.1 blue:0.1 alpha:0.8] CGColor], nil];
    [headerView.layer insertSublayer:gradient atIndex:0];
    
    headerView.backgroundColor =  [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0];
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ( [self tableView:tableView numberOfRowsInSection:section] > 0) {
        return MAIN_TABLE_VIEW__HEADER_SECTION_HEIGHT;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ( [self tableView:tableView numberOfRowsInSection:section] > 0) {
        return 5.0;
    } else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* footerView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 5)];
    footerView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    return footerView;
}

#pragma mark Private methods
-(NSMutableDictionary*) allNewsData {
    return (NSMutableDictionary*)[[AppDelegate getSharedContextInstance] objectForKey:SHARED_CONTEXT_KEY_ALL_NEWS_DATA];
}
-(NSArray*) sortedRssSourcesKeys {
    return ((NSArray*)[[AppDelegate getSharedContextInstance] objectForKey:SHARED_CONTEXT_KEY__SORTED_RSS_SOURCES_KEYS]);
}
-(NSString*)parseNode:(GDataXMLNode*)node forXPath:(NSString*)xpath andNamespaces:(NSDictionary*)namespaces {
    NSString* retVal = nil;
    
    NSArray* nodeArray = [node nodesForXPath:xpath namespaces:namespaces error:nil];
    
    if(nodeArray.count>0){
        NSString* rawValue = [[nodeArray objectAtIndex:0] stringValue];
    
        if(rawValue.length>0)
            retVal = [rawValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    }
    
    return retVal;
}


- (IBAction)refreshButtonAction:(id)sender {
    [self loadData];
}

-(void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning]; causes table sections to overlap
    NSLog(@"maintableviewcontroller received memory warning");
}
@end