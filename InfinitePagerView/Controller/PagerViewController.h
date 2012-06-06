//
//  PagerViewController.h
//  InfinitePagerView
//
//  Created by 政洋 諸富 on 12/04/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document1ViewController.h"
#import "Document2ViewController.h"
#import "Document3ViewController.h"
#import "Document4ViewController.h"

@interface PagerViewController : UIViewController <UIScrollViewDelegate> {
    
    NSMutableArray *viewControllers;
	int prevIndex;
	int currIndex;
	int nextIndex;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property (nonatomic, retain) Document1ViewController *controller1;
@property (nonatomic, retain) Document2ViewController *controller2;
@property (nonatomic, retain) Document3ViewController *controller3;
@property (nonatomic, retain) Document4ViewController *controller4;

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

@end
