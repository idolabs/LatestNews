//
//  ArticleDetailViewController.m
//  News Reader
//
//  Created by Mehmet Bahaddin Yasar on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsItemWebViewController.h"
#import "AppDelegate.h"
#import "../AppConstants.h"
#import "../Model/NewsItem.h"

@interface NewsItemWebViewController ()

@end

@implementation NewsItemWebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
      
//    for (int i = 1; i <= 3; ++i) {
//        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToBack)];
//        swipe.numberOfTouchesRequired = i;
//        swipe.direction = UISwipeGestureRecognizerDirectionRight;
//        swipe.delaysTouchesBegan = YES;
//        [self.view addGestureRecognizer:swipe];
//    }

    NSString *urlAddress = [[(NewsItem*)[[AppDelegate getInstance].sharedContext objectForKey:SHARED_CONTEXT_KEY_SELECTED_NEWS_ITEM] contentUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    _newsItemWebView.delegate = self;
    [self openURL:urlAddress];
}

-(void)swipeToBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) openURL:(NSString*)theURL{
  
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:theURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:120.0];
    
    //Load the request in the UIWebView.
    [self.newsItemWebView loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.newsItemWebView = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.newsItemWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    [self.newsItemWebView removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	// report the error inside the webview
	NSLog(@"error web view");
}

-(void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    NSLog(@"webviewcontroller received memory warning");
}

@end