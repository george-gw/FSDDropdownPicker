//
//  DropDownTableView.h
//  Umwho
//
//  Created by Felix Dumit on 12/24/14.
//  Copyright (c) 2014 Umwho. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "FSDPickerItemProtocol.h"

@protocol FSDDropdownPickerDelegate;

@interface FSDDropdownPicker : UIBarButtonItem

/**
 *  The delegate
 */
@property (weak, nonatomic) id <FSDDropdownPickerDelegate> delegate;

/**
 *  The navigation bar on which the item will be placed
 */
@property (strong, nonatomic) UINavigationBar * navigationBar;

/**
 *  If the picker is currently dropped down or not
 */
@property (assign, nonatomic, readonly) BOOL isDropped;

/**
 *  The current selected option from the dropdown picker
 */
@property (strong, nonatomic) id <FSDPickerItemProtocol> selectedOption;

/**
 *  The height of each option in the dropdown picker
 */
@property (assign, nonatomic) CGFloat rowHeight;

/**
 *  The font of each option in the dropdown picker
 */
@property (assign, nonatomic) UIFont * rowFont;

/**
 *  The text color of each option in the dropdown picker
 */
@property (copy, nonatomic) UIColor * rowTextColor UI_APPEARANCE_SELECTOR;

/**
 *  The dropdown picker's backgroundColor
 */
@property (copy, nonatomic) UIColor * backgroundColor UI_APPEARANCE_SELECTOR;
/**
 *  Whether to show images when the picker drops down or not
 */
@property (assign, nonatomic) BOOL displaysImageInList;

/**
 *  Whether to show the selected option when an option is picked from the drop down
 */
@property (assign, nonatomic) BOOL showSelectedOption;

/**
 *  The list separator style for the picker items
 */
@property (assign, nonatomic) UITableViewCellSeparatorStyle listSeparator;

/**
 *  The array of options id<FSDPickerItemProtocol> to be selected
 */
@property (strong, nonatomic, readonly) NSArray *options;

/**
 *  Initialize a FSDDropdownpicker instance given a list of items to display
 *
 *  @param options array containing id<FSDPickerItemProtocol> items to be displayed
 *
 *  @return FSDDropdownPicker instance
 */
- (instancetype)initWithOptions:(NSArray *)options;

/**
 *  Initialize a FSDDropdownpicker instance given a list of items to display
 *
 *  @param options array containing id<FSDPickerItemProtocol> items to be displayed
 *  @param mainItem the item that will be added to the navigation bar
 *
 *  @return FSDDropdownPicker instance
 */
- (instancetype)initWithOptions:(NSArray *)options andMainItem:(id<FSDPickerItemProtocol>)mainItem;

/**
 *  Shows the dropdown list
 *
 *  @param animated
 */
- (void)showDropdownAnimated:(BOOL)animated;

/**
 *  Hides the dropdown list
 *
 *  @param animated
 */
- (void)hideDropdownAnimated:(BOOL)animated;


/**
 *  Togges the dropdown show/hide
 */
- (void)toggleDropdown;

@end


@protocol FSDDropdownPickerDelegate <NSObject>

/**
 *  Called when the user selects an option from the dropdown
 *
 *  @param dropdownPicker the picker that received the event
 *  @param option         the selected option
 *
 *  @return whether the dropdown should dismiss or not
 */
- (BOOL)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didSelectOption:(id <FSDPickerItemProtocol> )option;
@optional

/**
 *  Called when the dropdown picker shows or dismisses
 *
 *  @param dropdownPicker the dropdown picker
 *  @param drop           YES if picker was shown, NO if it was hidden
 */
- (void)dropdownPicker:(FSDDropdownPicker *)dropdownPicker didDropDown:(BOOL)drop;

@end
