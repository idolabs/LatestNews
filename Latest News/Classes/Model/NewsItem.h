//
//  NewsItem.h
//  Latest News
//
//  Created by Inanc Sevinc on 9/1/12.
//  Copyright (c) 2012 idolabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *contentUrl;
@property (strong, nonatomic) NSString *imageUrl;

- (id)initWithTitle:(NSString*)title andContentUrl:(NSString*)contentUrl andImageUrl:(NSString*)imageUrl;

@end
