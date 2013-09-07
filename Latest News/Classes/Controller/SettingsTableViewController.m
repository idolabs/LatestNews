//
//  SettingsTableViewController.m
//  Latest News
//
//  Created by Mehmet Bahaddin Yasar on 10/6/12.
//  Copyright (c) 2012 idolabs. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "../AppConstants.h"
#import "AppDelegate.h"
#import "MainTableViewController.h"

@interface SettingsTableViewController ()

@property (strong,nonatomic) NSString* dirtyFlagForCategories;

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(200.0, 320.0);
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
//    NSLog(@"popover opened");
    NSArray* categories = (NSArray*)[[AppDelegate getSharedContextInstance] objectForKey:SHARED_CONTEXT_KEY__CATEGORIES];
    self.dirtyFlagForCategories = @"";
    for (NSDictionary* dict in categories) {
        _dirtyFlagForCategories = [_dirtyFlagForCategories stringByAppendingString:[dict objectForKey:@"category_selected"] ];
    }
//    NSLog(@"dirtyFlag: %@",_dirtyFlagForCategories);
}

- (void)viewDidDisappear:(BOOL)animated {
//    NSLog(@"popover closed");
    NSArray* categories = (NSArray*)[[AppDelegate getSharedContextInstance] objectForKey:SHARED_CONTEXT_KEY__CATEGORIES];
    NSString* dirtyFlagToCompare = @"";
    for (NSDictionary* dict in categories) {
        dirtyFlagToCompare = [dirtyFlagToCompare stringByAppendingString:[dict objectForKey:@"category_selected"] ];
    }
    if( ! [_dirtyFlagForCategories isEqualToString:dirtyFlagToCompare] ){
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        MainTableViewController* mainTableViewController = (MainTableViewController*)[appDelegate.sharedContext objectForKey: [SHARED_CONTEXT_KEY__VIEW_CONTROLLERS_PREFIX stringByAppendingString: NSStringFromClass([MainTableViewController class])]];
        [mainTableViewController reloadData];
//        NSLog(@"reload called");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)[[AppDelegate getSharedContextInstance] objectForKey:SHARED_CONTEXT_KEY__CATEGORIES]).count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray* categoryDataArray = (NSArray*)[[AppDelegate getSharedContextInstance] objectForKey:SHARED_CONTEXT_KEY__CATEGORIES];

    cell.textLabel.text = [[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"category_label"];
    
    BOOL selected = [[[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"category_selected"] isEqualToString:@"YES"];
    
    if(selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor blackColor];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSArray* categoryDataArray = (NSArray*)[[AppDelegate getSharedContextInstance] objectForKey:SHARED_CONTEXT_KEY__CATEGORIES];
    
//    NSLog(@"selected %@", [[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"category_selected"] );
    BOOL selected = [[[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"category_selected"] isEqualToString:@"YES"];
    NSString* selectedValue = selected ? @"NO" : @"YES";

    [[categoryDataArray objectAtIndex:indexPath.row] setValue:selectedValue forKey:@"category_selected"];
//     NSLog(@"selected2 %@", [[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"category_selected"] );
    [self.tableView reloadData];
}

@end
