//
//  WebVC.h
//  Thunder
//
//  Created by 鞠汶成 on 2018/11/24.
//  Copyright © 2018 Lance Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebVC : UIViewController

- (instancetype)initWithUrlString:(NSString *)urlString;

- (void)changeUrl:(NSString *)url;

@property (nonatomic, assign) BOOL titleTapBackGesture;
@property (nonatomic, assign) BOOL disableRefreshHeader;
@end
