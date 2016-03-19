//
//  MEBaseVC.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MEBaseVC.h"

@interface MEBaseVC ()

@end

@implementation MEBaseVC

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self localConfigure];
}

#pragma mark - Private

- (void)localConfigure {
    [self configureController];
}

#pragma mark - Public

+ (NSString *)storyboardName {
    return @"";
}

+ (NSString *)identifier {
    return @"";
}

+ (UIView *)loadViewByNibName:(NSString *)nibName {
    NSArray *viewNib = [[NSBundle mainBundle] loadNibNamed:nibName
                                                     owner:self
                                                   options:nil];
    return (UIView *)[viewNib firstObject];
}

- (void)configureController {
    // Abstract method.
}

- (UIViewController *)loadControllerFromStoryboard:(NSString *)storyboardName {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    return vc;
}

- (UIViewController *)loadControllerFromStoryboard:(NSString *)storyboardName byIdentifier:(NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    return vc;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
