//
//  DropDownTableView.m
//  Umwho
//
//  Created by Felix Dumit on 12/24/14.
//  Copyright (c) 2014 Umwho. All rights reserved.
//


#import "FSDDropdownPicker.h"

@interface FSDDropdownPicker () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id<FSDPickerItemProtocol> mainItem;

@property (assign, nonatomic) CGRect originalFrame;
@property (assign, nonatomic) CGRect tableFrame;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIVisualEffectView *bluredEffectView;
@property (strong, nonatomic) UIView *tapOutView;

@end

@implementation FSDDropdownPicker


- (instancetype)initWithOptions:(NSArray *)options {
    if (self = [super initWithImage:[[options firstObject] image] style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)]) {

        self.options = options;
        _isDropped = NO;
        self.selectedOption = [options firstObject];
        
        self.displaysImageInList = NO;

        self.showSelectedOption = YES;

        self.tapOutView = nil;
        
        self.rowHeight = 44.0f;

        self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.850];
        
        self.listSeparator = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (instancetype)initWithOptions:(NSArray *)options andMainItem:(id<FSDPickerItemProtocol>)mainItem {
    self.mainItem = mainItem;

    if (self = [super initWithImage:mainItem.image style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)]) {
        self.options = options;
        _isDropped = NO;

        self.showSelectedOption = NO;

        self.selectedOption = [options firstObject];

        self.displaysImageInList = NO;

        self.tapOutView = nil;

        self.rowHeight = 44.0f;

        self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.850];

        self.listSeparator = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)dealloc {
    if(_tableView) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect navFrame = self.navigationBar.frame;
        self.tableFrame = CGRectMake(CGRectGetMinX(navFrame), CGRectGetMaxY(navFrame), CGRectGetWidth(navFrame), self.options.count * self.rowHeight);
        
        _tableView = [[UITableView alloc] initWithFrame:self.tableFrame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = YES;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = self.listSeparator;
        _tableView.rowHeight = self.rowHeight;
        _tableView.backgroundColor = self.backgroundColor;

        if(!_isDropped)
            [self hideDropdownAnimated:NO];

        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds];
        self.tableView.layer.masksToBounds = NO;
        self.tableView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.tableView.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
        self.tableView.layer.cornerRadius = 2.0f;
        self.tableView.layer.shadowOpacity = 0.3f;
        self.tableView.layer.shadowPath = shadowPath.CGPath;
    }
    if (!_tableView.superview) {
        [self.navigationBar.superview insertSubview:_tableView belowSubview:self.navigationBar];
    }
    return _tableView;
}

- (void)buttonTapped:(id)sender {
    [self toggleDropdown];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    _tableView.rowHeight = rowHeight;
    CGRect tableFrame = self.tableFrame;
    tableFrame.size.height = self.options.count * rowHeight;
    self.tableFrame = tableFrame;
    [_tableView reloadData];
}

- (void)setDisplaysImageInList:(BOOL)displaysImageInList {
    _displaysImageInList = displaysImageInList;
}

- (void)setListSeparator:(UITableViewCellSeparatorStyle)listSeparator {
    _listSeparator = listSeparator;
    _tableView.separatorStyle = listSeparator;
}

- (void)toggleDropdown {
    if (!_isDropped) {
        [self showDropdownAnimated:YES];
    }
    else {
        [self hideDropdownAnimated:YES];
    }
}

- (void)showDropdownAnimated:(BOOL)animated {
    [self.delegate dropdownPicker:self didDropDown:YES];
    
    self.tableView.hidden = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.frame = self.tableFrame;
                         }
         
                         completion: ^(BOOL finished) {
                             _isDropped = YES;
                         }];
    }
    else {
        self.tableView.frame = self.tableFrame;
        //        self.frame = self.originalFrame;
    }
    [self.tableView.superview insertSubview:self.tapOutView belowSubview:self.tableView];
}

- (void)hideDropdownAnimated:(BOOL)animated {
    [self.delegate dropdownPicker:self didDropDown:NO];
    
    CGRect frame = self.tableFrame;
    frame.origin.y -= CGRectGetHeight(self.tableView.bounds) + 5;
    
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:10
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             self.tableView.frame = frame;
                         }
         
                         completion: ^(BOOL finished) {
                             self.tableView.hidden = YES;
                             _isDropped = NO;
                         }];
    }
    else {
        self.tableView.frame = frame;
        self.tableView.hidden = YES;
    }
    [self.tapOutView removeFromSuperview];
    self.tapOutView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"dropCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = self.rowFont ? self.rowFont : [UIFont systemFontOfSize:self.rowHeight / 2.3];
        cell.textLabel.textColor = self.rowTextColor ? self.rowTextColor : [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    id <FSDPickerItemProtocol> item = [self.options objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [item name];
    if (self.displaysImageInList) {
        cell.imageView.image = [item image];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    else {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedOption = [self.options objectAtIndex:indexPath.row];
}

- (void)setSelectedOption:(id <FSDPickerItemProtocol> )selectedOption {
    _selectedOption = selectedOption;
    if(self.showSelectedOption)
        [self setImage:[_selectedOption image]];
    
    if (self.delegate && [self.delegate dropdownPicker:self didSelectOption:_selectedOption]) {
        [self hideDropdownAnimated:YES];
    }
}

#pragma mark - Tapoutview
- (UIView *)tapOutView {
    if (!_tapOutView && self.tableView.window) {
        _tapOutView = [[UIView alloc] initWithFrame:self.tableView.window.rootViewController.view.frame];
        _tapOutView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOutTapped:)];
        [_tapOutView addGestureRecognizer:tap];
    }
    return _tapOutView;
}

- (void)tapOutTapped:(id)sender {
    [self hideDropdownAnimated:YES];
}

@end
