// AFGDataXMLRequestOperation.m
//
// Copyright (c) 2012 Simon Gätzer simon@graetzer.org
// Copyright (c) 2011 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFGDataXMLRequestOperation.h"

static dispatch_queue_t af_gdataxml_request_operation_processing_queue;
static dispatch_queue_t gdataxml_request_operation_processing_queue() {
    if (af_gdataxml_request_operation_processing_queue == NULL) {
        af_gdataxml_request_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.gdataxml-request.processing", 0);
    }
    
    return af_gdataxml_request_operation_processing_queue;
}

@interface AFGDataXMLRequestOperation ()
@property (readwrite, nonatomic, strong) GDataXMLDocument *responseXMLDocument;
@property (readwrite, nonatomic, strong) NSError *error;

+ (NSSet *)defaultAcceptableContentTypes;
+ (NSSet *)defaultAcceptablePathExtensions;
@end

@implementation AFGDataXMLRequestOperation
@synthesize responseXMLDocument = _responseXMLDocument;
@synthesize error = _XMLError;

+ (AFGDataXMLRequestOperation *)XMLDocumentRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                               success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, GDataXMLDocument *XMLDocument))success
                                                               failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, GDataXMLDocument *XMLDocument))failure
{
    AFGDataXMLRequestOperation *operation = [[self alloc] initWithRequest:urlRequest];
    __weak typeof(operation) boperation = operation;
    operation.completionBlock = ^ {
        if ([boperation isCancelled]) {
            return;
        }
        
        if (operation.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    failure(operation.request, operation.response, operation.error, [(AFGDataXMLRequestOperation *)boperation responseXMLDocument]);
                });
            }
        } else {
            dispatch_async(gdataxml_request_operation_processing_queue(), ^(void) {
                GDataXMLDocument *XMLDocument = operation.responseXMLDocument;
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        success(operation.request, operation.response, XMLDocument);
                    });
                }
            });
        }
    };
    
    return operation;
}

+ (NSSet *)defaultAcceptableContentTypes {
    return [NSSet setWithObjects:@"application/xml", @"text/xml", @"text/html", @"application/xhtml+xml", nil];
}

+ (NSSet *)defaultAcceptablePathExtensions {
    return [NSSet setWithObjects:@"xml", @"html", nil];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest {
    self = [super initWithRequest:urlRequest];
    if (!self) {
        return nil;
    }
    
    //    self.hasAcceptableContentType = [[self class] defaultAcceptableContentTypes];
    
    return self;
}


- (GDataXMLDocument *)responseXMLDocument {
    if (!_responseXMLDocument && [self isFinished]) {
        NSError *error = nil;
        self.responseXMLDocument = [[GDataXMLDocument alloc] initWithData:self.responseData options:0 error:&error];
        //For parsing malformed XML input:
        //self.responseXMLDocument = [[GDataXMLDocument alloc] initWithHTMLData:self.responseData options:0 error:&error];
        self.error = error;
    }
    
    return _responseXMLDocument;
}

- (NSError *)error {
    if (_XMLError) {
        return _XMLError;
    } else {
        return [super error];
    }
}

#pragma mark - NSOperation

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[self defaultAcceptableContentTypes] containsObject:[request valueForHTTPHeaderField:@"Accept"]] || [[self defaultAcceptablePathExtensions] containsObject:[[request URL] pathExtension]];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    __weak typeof(self) bself = self;
    self.completionBlock = ^ {
        if ([bself isCancelled]) {
            return;
        }
        
        if (self.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    failure(bself, bself.error);
                });
            }
        } else {
            if (success) {
                success(bself, bself.responseXMLDocument);
            }
        }
    };
}

@end
