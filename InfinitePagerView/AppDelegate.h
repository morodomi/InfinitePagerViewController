//
//  AppDelegate.h
//  InfinitePagerView
//
//  Created by Masahiro Morodomi on 12/04/25.
//  Copyright (c) 2012 shonanshachu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagerViewController.h"

@class PagerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PagerViewController *pagerViewController;

@end
