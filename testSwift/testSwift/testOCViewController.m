//
//  testOCViewController.m
//  testSwift
//
//  Created by csh on 16/8/4.
//  Copyright © 2016年 csh. All rights reserved.
//

#import "testOCViewController.h"
#import <POP/POP.h>


@interface testOCViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (nonatomic) UIButton *tview;

@end

@implementation testOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    // Do any additional setup after loading the view.
}

- (void)addView
{
    self.tview = [[UIButton alloc]initWithFrame:CGRectMake(50, 250, 100, 100)];
    self.tview.backgroundColor = [UIColor redColor];
    [self.tview addTarget:self action:@selector(testBtnAc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tview];
    
}
- (IBAction)testAction:(id)sender {
    for (int i = 0; i < 10000; i++) {
        NSLog(@"@%d",i);
        
    }
    [self test];

   
    
}
- (void)testBtnAc {
    for (int i = 0; i < 10000; i++) {
        NSLog(@"@%d",i);
        
    }
    
    [self shakeButton];
}
- (void)shakeButton
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @10000;
    positionAnimation.springBounciness = 20;
    //[positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
    // self.button.userInteractionEnabled = YES;
    //}];
    [self.tview.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    NSLog(@"a");
}

- (void)test{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @10000;
    positionAnimation.springBounciness = 20;
    //[positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
    // self.button.userInteractionEnabled = YES;
    //}];
    [self.testBtn.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    NSLog(@"a");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
