# SwiftyPickerPopover
Popover with Picker by Swift 3 for iPhone/iPad, iOS9+.

[![Version](https://img.shields.io/cocoapods/v/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover) 
[![License](https://img.shields.io/cocoapods/l/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover) 
[![Platform](https://img.shields.io/cocoapods/p/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)

## Features
- Popover with Picker which can be chosen from several types, appears on iPhone or iPad.
- Swift 3, iOS9+. UIPopoverController free. 
- Callback

## Screenshots
<img src="README_resources/SwiftyPickerPopover_movie.gif" width="362">

## Required
- Swift 3, Xcode 8. (If you want to use it on Swift 2.3, please check up SwiftyPickerPopover 1.3)
- iOS 9+
- CocoaPods 1.1.0.rc.2+ or Carthage 0.12.0+

## License
MIT.

## Usage
For Installing it on Swift 3 with CocoaPods, specify it in your 'Podfile'.
```ruby
platform :ios, '9.0'
use_frameworks!
pod 'SwiftyPickerPopover'
```
If you want to use it on Swift 2.3, specify it.
```ruby
pod 'SwiftyPickerPopover ~> '1.3.0'
```
Run 'pod install'.

For Installing with Carthage, add it to your Cartfile.
```
github "hsylife/SwiftyPickerPopover"
```
Run 'carthage update --platform iOS'.

On Xcode, import the module.
```swift
import SwiftyPickerPopover
```
### Basic
To display a popover with UIDatePicker, the code looks like this:

```swift
DatePickerPopover(title: "DatePicker")
            .setDateMode(.date)
            .setSelectedDate(Date())
            .setDoneAction({ popover, selectedDate in print("selectedDate \(selectedDate)")})
            .setCancelAction({ popover in print("cancel")})
            .appear(originView: sender, baseViewController: self)
```

To display a popover with UIPickerView that allows users to choose a String type choice:
```swift
StringPickerPopover(title: "StringPicker", choices: ["value 1","value 2","value 3"])
        .setSelectedRow(0)
        .setDoneAction({ (popover, selectedRow, selectedString) in
            print("done row \(selectedRow) \(selectedString)")
        })
        .setCancelAction( { popover in print("cancel")}
        )
        .appear(originView: button, baseViewController: self)
```

ColumnStringPickerPopover which has variable multiple components, appers.
```swift
ColumnStringPickerPopover.appearFrom(
 originView: button,
 baseViewController: self, title: "Columns Strings",
 choices: [["Breakfast", "Lunch", "Dinner"], ["Tacos", "Sushi", "Steak", "Waffles", "Burgers"]],
 initialRow: [0,0],
 columnPercent: [0.5, 0.5],
 fontSize: 12.0,
 doneAction: { selectedRows, selectedStrings in print("selected rows \(selectedRows) strings \(selectedStrings)")}, 
 cancelAction: {print("cancel")}
)
```

CountdownPickerPopover which returns interval time, appears.
```swift
CountdownPickerPopover.appearFrom(
 originView: sender,
 baseViewController: self,
 title: "CountdownPicker",
 dateMode: .countDownTimer,
 initialInterval: TimeInterval(),
 doneAction: { timeInterval in print("timeInterval \(timeInterval)")},
 cancelAction: {print("cancel")}
)
```

### Advanced
DatePickerPopover with clearAction 
```swift
DatePickerPopover.appearFrom(originView: button,
  baseViewController: self,
  title: "Clearable DatePicker",
  dateMode: .date,
  initialDate: NSDate(),
  doneAction: { selectedDate in print("selectedDate \(selectedDate)")},
  cancelAction: {print("cancel")},
  clearAction: { print("clear")}
)
```

DatePickerPopover for .time with 5 minute interval is permitted .down arrow.
```swift
DatePickerPopover.appearFrom(originView: button,
  baseViewController: self,
  title: "DatePicker .time 5minInt.",
  dateMode: .time,
  initialDate: NSDate(),
  minuteInterval: 5,
  permittedArrowDirections: .down,
  doneAction: { selectedDate in print("selectedDate \(selectedDate)")},
  cancelAction: {print("cancel")},
  clearAction: { print("clear")}
)
```
'initialDate' and 'permittedArrowDirections' are omissible.
'permittedArrowDirections' is not only for DatePickerPopover. Every PickerPopover derived from AbstractPickerPoover, has 'permittedArrowDirections' argument.

StringPickerPopover with displayStringFor
```swift
let displayStringFor:((String?)->String?)? = { string in
   if let s = string {
      switch(s){
      case "value 1":
        return "😊"
      case "value 2":
         return "😏"
      case "value 3":
         return "😓"
      default:
         return s
      }
    }
  return nil
  }
        
StringPickerPopover.appearFrom(
  originView: button,
  baseViewController: self,
  title: "StringPicker",
  choices: ["value 1","value 2","value 3"],
  displayStringFor: displayStringFor,
  initialRow:0,
  doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")},
  cancelAction: { print("cancel")}
)
```

StringPickerPopover appears from CollectionView's cell.
```swift
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 let theCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
 StringPickerPopover.appearFrom(
   originView: theCell,
   baseView: collectionView,
   baseViewController: self,
   title: "CollectionView",
   choices: ["value 1","value 2","value 3"],
   initialRow:0,
   doneAction: { selectedRow, selectedString in print("done row \(selectedRow) \(selectedString)")},
   cancelAction: { print("cancel")})
}
```


## Contributors
Ken Torimaru  [GitHub](https://github.com/ktorimaru) for CountdownPickerPopover and ColumnStringPickerPopover.

BalestraPatrick [GitHub](https://github.com/BalestraPatrick)
## Author
Yuta Hoshino [Twitter](https://twitter.com/hsylife) [Facebook](https://www.facebook.com/yuta.hoshino)
