//
//  AppDelegate.h
//  InfinitePagerView
//
//  Created by 政洋 諸富 on 12/04/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagerViewController.h"

@class PagerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PagerViewController *pagerViewController;

@end
