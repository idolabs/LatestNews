//
//  NewsItem.m
//  Latest News
//
//  Created by Inanc Sevinc on 9/1/12.
//  Copyright (c) 2012 idolabs. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

-(NSString *)description {
    return [NSString stringWithFormat:@"News Item: { title: %@, contentUrl: %@, imageUrl: %@ }",
            self.title, self.contentUrl, self.imageUrl];
}

- (id)initWithTitle:(NSString*)title andContentUrl:(NSString*)contentUrl andImageUrl:(NSString*)imageUrl
{
    self = [super init];
    if(self) {
        _title = title;
        _contentUrl = contentUrl;
        _imageUrl = imageUrl;
    }
    return (self);
}

@end
