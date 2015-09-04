//
//  UINavigationItem+FSDPicker.h
//  FSDDropdownPicker
//
//  Created by Felix Dumit on 3/7/15.
//  Copyright (c) 2015 Felix Dumit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSDDropdownPicker.h"
#import "FSDPickerItemProtocol.h"

@interface UINavigationItem (FSDPicker)

/**
 *  Adds a dropdown picker to the navigation item
 *
 *  @param options the array of options to be displayed
 *
 *  @return FSDDropdown picker instance
 */
- (FSDDropdownPicker *)addDropdownPickerWithOptions:(NSArray *)options;

/**
 *  Adds a dropdown picker to the navigation item
 *
 *  @param options  the array of options to be displayed
 *  @param mainItem the item that will be added to the navigation bar
 *
 *  @return FSDDropdown picker instance
 */
- (FSDDropdownPicker *)addDropdownPickerWithOptions:(NSArray *)options andMainItem:(id<FSDPickerItemProtocol>)mainItem;

@end
