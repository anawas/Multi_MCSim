//
//  AsyncPost.m
//
//  Created by Ferhat Yildiz on 7/9/11.
//

#import "AsyncPost.h"

@implementation AsyncPost

- (id)init {
    self = [super init];
    
    if(self){
        httpResponse = [[NSMutableData alloc] init];
    }
    
    return self;
}

// Sends an asynchronous HTTP POST request
- (void)sendRequest:(NSString*)url payLoad:(NSString*)body sender:(NSObject*) sender {
    
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:url];
    
    NSMutableString* requestBody = [[NSMutableString alloc] init];
    [requestBody appendString:body];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithString:requestURL]]];
    
    NSString* requestBodyString = [NSString stringWithString:requestBody];
    NSData *requestData = [NSData dataWithBytes: [requestBodyString UTF8String] length: [requestBodyString length]];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    NSLog(@"request = %@", request);
    
    NSURLResponse *theRespose;
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:sender];
    
    if (!theConnection) {
        NSLog(@"ERROR -- COULD NOT OPEN A CONNECTION");
    }
}
- (NSData *)sendSynchronousRequest:(NSString*)url payLoad:(NSString*)body sender:(NSObject*) sender {
    NSMutableString* requestURL = [[NSMutableString alloc] init];
    [requestURL appendString:url];
    
    NSMutableString* requestBody = [[NSMutableString alloc] init];
    [requestBody appendString:body];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithString:requestURL]]];
    
    NSString* requestBodyString = [NSString stringWithString:requestBody];
    NSData *requestData = [NSData dataWithBytes: [requestBodyString UTF8String] length: [requestBodyString length]];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData];
    NSLog(@"request = %@", request);
    
    NSURLResponse *theRespose;
    NSData *responseData = [[NSURLConnection sendSynchronousRequest:request returningResponse:&theRespose error:nil] copy];
    
    return responseData;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [httpResponse setLength:0];
}

// Called when data has been received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [httpResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* responseString = [[[NSString alloc] initWithData:httpResponse encoding:NSUTF8StringEncoding] copy];
    
    // Do something with the response
    
    connection = nil;
    httpResponse = nil;
}

@end