//
//  TaskViewController.m
//  TaskViewController
//
//  Created by Rafa on 02/11/17.
//  Copyright © 2017 RAFONCIO. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController ()
@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskNameLabel.text = _taskName;
}

@end
