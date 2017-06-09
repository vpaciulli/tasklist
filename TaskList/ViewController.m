//
//  ViewController.m
//  ViewController
//
//  Created by Rafa on 02/11/17.
//  Copyright © 2017 RAFONCIO. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "TaskViewController.h"
#import <CoreData/CoreData.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITableView *taskTableView;
@property(strong,nonatomic) NSMutableArray *taskArray;
@property(strong,nonatomic) NSArray *arr;

@end

@implementation ViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest *fetchData = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
  self.arr = [context executeFetchRequest:fetchData error:nil];
  self.taskArray = [[NSMutableArray alloc] initWithArray:[self.arr valueForKey:@"taskname"]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.taskArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
  cell.textLabel.text = [self.taskArray objectAtIndex:indexPath.row];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self performSegueWithIdentifier:@"taskShow" sender:nil];
}

#pragma mark - NavigationController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if (![segue.identifier isEqualToString:@"taskShow"]) return;
  TaskViewController* destinationController = (TaskViewController*)[segue destinationViewController];
  NSIndexPath *path = [self.taskTableView indexPathForSelectedRow];
  destinationController.taskName = [self.taskArray objectAtIndex:path.row];
}

#pragma mark - AddButtonAction
- (IBAction)addTaskButtonClick:(id)sender {
  NSString *inputStr = [[NSMutableString alloc] initWithFormat:@"%@",self.inputTextField.text];
  inputStr = [inputStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  if ([inputStr  isEqual: @""]) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"OPS" message:@"Digite o nome da sua Tarefa" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
  } else {
    [self saveToCoreData:inputStr];
    [self.taskArray insertObject:self.inputTextField.text atIndex:self.taskArray.count];
    [self.taskTableView reloadData];
    self.inputTextField.text = nil;
    [self.inputTextField resignFirstResponder];
  }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  [self removeFromCoreData:indexPath.row];
  [self.taskArray removeObjectAtIndex:indexPath.row];
  [self.taskTableView reloadData];
}

#pragma mark - CoreData;
- (void) saveToCoreData:(NSString *)taskName{
  NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSManagedObject *row = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
  [row setValue:taskName forKey:@"taskname"];
  [context save:nil];
}

-(void) removeFromCoreData:(NSInteger) index{
  NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSManagedObject *row = [self.arr objectAtIndex:index];
  [context deleteObject:row];
  [context save:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  [self.inputTextField resignFirstResponder];
}

@end
