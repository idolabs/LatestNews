//
//  ArticleDetailViewController.h
//  News Reader
//
//  Created by Mehmet Bahaddin Yasar on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsItemWebViewController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate>

-(void) openURL:(NSString*)theURL;

@property (strong, nonatomic) IBOutlet UIWebView *newsItemWebView;

@end
