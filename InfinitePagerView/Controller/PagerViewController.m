//
//  PagerViewController.m
//  InfinitePagerView
//
//  Created by 政洋 諸富 on 12/04/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PagerViewController.h"

@interface PagerViewController ()

@property (assign) BOOL pageControlUsed;
-(void)loadScrollViewController:(int)index withPage:(int)page;

@end

@implementation PagerViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;
@synthesize controller1, controller2, controller3, controller4;
@synthesize prevIndex, currIndex, nextIndex;

@synthesize pageControlUsed;

- (void)dealloc {
    [scrollView release];
    [pageControl release];
    [viewControllers release];
    [controller1 release];
    [controller2 release];
    [controller3 release];
    [controller4 release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // UIScrollViewの設定
    [scrollView setPagingEnabled:YES];
    [scrollView setScrollEnabled:YES];
    [scrollView setBounces:NO];
    [scrollView setBouncesZoom:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setDelegate:self];

    // UIViewControllerインスタンスの生成
    controller1 = [[Document1ViewController alloc] initWithNibName:@"Document1ViewController" bundle:nil];
    controller2 = [[Document2ViewController alloc] initWithNibName:@"Document2ViewController" bundle:nil];
    controller3 = [[Document3ViewController alloc] initWithNibName:@"Document3ViewController" bundle:nil];
    controller4 = [[Document4ViewController alloc] initWithNibName:@"Document4ViewController" bundle:nil];

    // UIViewControllerを保存しておく配列の初期化
    viewControllers = [[NSMutableArray alloc] initWithObjects:controller1, controller2, controller3, controller4, nil];
    
    // 各Indexの設定
    prevIndex = 0;
    currIndex = 1;
    nextIndex = 2;

    // ScrollViewにViewを読み込む
    [self loadScrollViewController:prevIndex withPage:prevIndex];
    [self loadScrollViewController:currIndex withPage:currIndex];
    [self loadScrollViewController:nextIndex withPage:nextIndex];
    
    // UIPageControlの設定
    pageControl.currentPage = currIndex;
    [pageControl setNumberOfPages:[viewControllers count]];
    [pageControl setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"PagerViewController.viewWillAppear");
    [super viewWillAppear:animated];
    
    
    // UIViewControllerの表示
    UIViewController *viewController = [viewControllers objectAtIndex:pageControl.currentPage];
    if(viewController.view.subviews != nil) {
        [viewController viewWillAppear:animated];
    }
    
    // UIScrollViewのサイズを決定(左右に1枚ずつなので、320 * 3
    [scrollView setContentSize:CGSizeMake(960, scrollView.frame.size.height)];
    // 初期状態をINDEX:1に設定
    [scrollView scrollRectToVisible:CGRectMake(currIndex * 320, 0, 320, 416) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    UIViewController *controller = [viewControllers objectAtIndex:pageControl.currentPage];
    if (controller.view.superview != nil) {
		[controller viewDidAppear:animated];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	UIViewController *controller = [viewControllers objectAtIndex:pageControl.currentPage];
	if (controller.view.superview != nil) {
		[controller viewWillDisappear:animated];
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	UIViewController *controller = [viewControllers objectAtIndex:pageControl.currentPage];
	if (controller.view.superview != nil) {
		[controller viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadScrollViewController:(int)index withPage:(int)page {
    if(page < 0 || page >= [viewControllers count]) {
        return;
    }

    // Viewの移動補助
    NSLog(@"loadScrollView:%d withPage:%d", index, page);
    UIViewController *controller = [viewControllers objectAtIndex:index];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    controller.view.frame = frame;
    if(controller.view.superview == nil) {
        [scrollView addSubview:controller.view];
    }
    // ViewをFrontへ出さないと隠れる
    [controller.view.superview bringSubviewToFront:controller.view];
}
#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if(pageControlUsed) {
        return;
    }
    
    // ページ遷移後は表示
    if(pageControl.currentPage != currIndex) {
        UIViewController *oldViewController = [self.viewControllers objectAtIndex:pageControl.currentPage];
        UIViewController *newViewController = [self.viewControllers objectAtIndex:currIndex];
        [oldViewController viewWillDisappear:YES];
        [newViewController viewWillAppear:YES];
        [pageControl setCurrentPage: currIndex];
        [oldViewController viewDidDisappear:YES];
        [newViewController viewDidAppear:YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)sender {
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    pageControlUsed = NO;
    // 右へ移動
    if(self.scrollView.contentOffset.x > self.scrollView.frame.size.width) {
        NSLog(@"View Moved To Right");
        // 一番左を読み込む
        [self loadScrollViewController:currIndex withPage:0];
        // 真ん中を読み込む
        currIndex = (currIndex >= [self.viewControllers count] - 1) ? 0 : currIndex + 1;
        [self loadScrollViewController:currIndex withPage:1];
        // 一番右を読み込む
        nextIndex = (currIndex >= [self.viewControllers count] - 1) ? 0 : currIndex + 1;
        [self loadScrollViewController:nextIndex withPage:2];
        
    }
    // 左へ移動
    if(self.scrollView.contentOffset.x < self.scrollView.frame.size.width) {
        NSLog(@"View Moved To Left");
        // 一番右を読み込む
        [self loadScrollViewController:currIndex withPage:2];
        // 真ん中を読み込む
        currIndex = (currIndex == 0) ? [self.viewControllers count] - 1 : currIndex - 1;
        [self loadScrollViewController:currIndex withPage:1];
        // 一番左を読み込む
        prevIndex = (currIndex == 0) ? [self.viewControllers count] - 1 : currIndex - 1;
        [self loadScrollViewController:prevIndex withPage:0];
    }
    
    // 3ページのみの場合、常に中心にリセット
    [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,416) animated:NO];
}

@end
