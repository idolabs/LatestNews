#import <UIKit/UIKit.h>

@interface MainTableCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *newsItemsTableView;
@property (nonatomic, strong) NSArray *newsItemsForSingleSource;
@property (strong, nonatomic) UIView *bouncingView;


@end