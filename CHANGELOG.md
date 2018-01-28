6.0.0 Release notes (2018-01-28)
=============================================================
### API Breaking Changes

* Change ColumnStringPickerPopover setFontSize() to setFontSizes().

### Enhancements

* Added setFont(), setFontColor() and setFontSize() to StringPickerPopover.
* Added setFonts(), setFontColors() and setFontSizes() to ColumnStringPickerPopover

### Bugfixes

*Fixed minor bugs.

5.3.0 Release notes (2017-08-04)
=============================================================

### API Breaking Changes

* None

### Enhancements

* Supports for adding UIImage to string directly

### Bugfixes

* None

5.2.3 Release notes (2017-08-03)
=============================================================

### API Breaking Changes

* None

### Enhancements

* None

### Bugfixes

* Remove cartfile to avoid circular reference when installing it via carthage

5.2.2 Release notes (2017-07-30)
=============================================================

### API Breaking Changes

* None

### Enhancements

* None

### Bugfixes

* Fix that cancelButton is set to nil on iOS 11

5.2.1 Release notes (2017-07-28)
=============================================================

### API Breaking Changes

* None

### Enhancements

* Add Podfile and Cartfile

### Bugfixes

* The demo target bundle identifier has been changed to "ge-nie-inc.SwiftyPickerPopoverDemo"

5.2.0 Release notes (2017-07-26)
=============================================================

### API Breaking Changes

* None

### Enhancements
* Add setLocale() to DatePickerPopover
* Improve comments and polish code

### Bugfixes

* None


5.1.2 Release notes (2017-07-23)
=============================================================

### API Breaking Changes

* None

### Enhancements
* Improve the layout of SampleViewController

### Bugfixes

* None


5.1.1 Release notes (2017-07-22)
=============================================================

### API Breaking Changes

* None.

### Enhancements
* None

### Bugfixes

* Fix circular reference.
* Fix that popover size cannot be set correctly when tapping clear button.
* Fix that another popover will unintentionally disapper after the specified time when executing disappearAutomatically().


5.1.0 Release notes (2017-07-14)
=============================================================

### API Breaking Changes

* None.

### Enhancements
* Add setSize() to resize popover.

### Bugfixes

* None.


5.0.0 Release notes (2017-07-13)
=============================================================

### API Breaking Changes

* Rename baseView: to baseViewWhenOriginViewHasNoSuperview: of AbstractPopover's appear(), configureNavigationController() and configureNavigationController().

### Enhancements
* When the originView has its superview, you no longer need to set baseView:, which has been renamed to baseViewWhenOriginViewHasNoSuperview:.

### Bugfixes

* None.


4.2.0 Release notes (2017-07-12)
=============================================================

### API Breaking Changes

* None.

### Enhancements
* Add color: to setDoneButton(), setCancelButton() and setClearButton().


### Bugfixes

* None.


4.1.1 Release notes (2017-07-11)
=============================================================

### API Breaking Changes

* None.

### Enhancements
* Polish code of StringPickerPopover's attributedTitleForRow.

### Bugfixes

* None.


4.1.0 Release notes (2017-07-09)
=============================================================

### API Breaking Changes

* None.

### Enhancements
* Add setRowHeight() to StringPickerPopover.
* Add setImageNames() to StringPickerPopover to dispay image like UITableViewCell.

### Bugfixes

* None.


4.0.1 Release notes (2017-05-17)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* None.

### Bugfixes

* Fix that .date style DataPicker crashes on iOS 9.x.


4.0.0 Release notes (2017-04-24)
=============================================================

### API Breaking Changes

* Change setXxxAction() to setXxxButton().

### Enhancements

* Add setArrowColor().

### Bugfixes

* None.

3.0.4 Release notes (2017-04-21)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* None.

### Bugfixes

* fix that setSelectedRow() does not work.

3.0.3 Release notes (2017-04-19)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* add Japanese localization to Demo.

### Bugfixes

* fix "Could not find a storyboard named 'StringPickerPopover' in bundle NSBundle".
