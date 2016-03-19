//
//  MESearchUsersVC.m
//  InstClient
//
//  Created by Maximychev Evgeny on 19.03.16.
//  Copyright © 2016 Maximychev Evgeny. All rights reserved.
//

#import "MESearchUsersVC.h"
#import "MESearchUsersView.h"
#import "MEUserCell.h"
#import "MEInstService.h"
#import "MEUser.h"

@interface MESearchUsersVC () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet MESearchUsersView *contentView;
@property (weak, nonatomic) UIWebView *webView;
@property (nonatomic) NSArray<MEUser *> *usersData;
@end

@implementation MESearchUsersVC

#pragma mark - Configure

- (void)configureController {
    [self prepareWebView];
    [self setDataSourceAndDelegate];
}

#pragma mark - Private

- (void)setDataSourceAndDelegate {
    self.contentView.tableView.dataSource = self;
    self.contentView.tableView.delegate = self;
    self.contentView.searchBar.delegate = self;
}

- (void)prepareWebView {
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    self.webView = webView;
    webView.delegate = self;
    [webView loadRequest:[Inst_service getAutorizationRequestForInstagram]];
}

- (void)reloadTableViewData {
    [self.contentView.tableView reloadData];
}

- (void)searchUsersBySerachString:(NSString *)searchString {
    __weak typeof(self)weakSealf = self;
    [Inst_service getUsersBySearchString:@""
                               onSuccess:^(NSArray *users) {
                                   weakSealf.usersData = users;
                                   [weakSealf reloadTableViewData];
                               }
                               onFailure:^(NSError *error) {
                                   [weakSealf showAlertWithTitle:@"Error"
                                                         message:error.localizedDescription];
                               }];
}

#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *token = [Inst_service getTokenFromURL:[[request URL] description]];
    if (token) {
        [self.webView removeFromSuperview];
    }
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.usersData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [MEUserCell cellIdentifier];
    MEUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                                       forIndexPath:indexPath];
    [cell setModel:self.usersData[indexPath.row]];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%lu users", (unsigned long)[self.usersData count]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchUsersBySerachString:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = searchBar.text;
    [self searchUsersBySerachString:searchString];
}

@end
