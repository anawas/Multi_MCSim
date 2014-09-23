//
//  AsyncPost.h
//
//  Created by Ferhat Yildiz on 7/9/11.
//

#import <Foundation/Foundation.h>

@interface AsyncPost : NSObject {
    NSMutableData* httpResponse;
}

- (void)sendRequest:(NSString*)url payLoad:(NSString*)body sender:(NSObject*) sender;
@end