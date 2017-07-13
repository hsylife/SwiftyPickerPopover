# SwiftyPickerPopover
A more convenient way to display a popover with a built-in picker, on iPhone/iPad of iOS9+.

[![Version](https://img.shields.io/cocoapods/v/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover) 
[![License](https://img.shields.io/cocoapods/l/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)

## Features
- By simple code, you can display a popover that contains a built-in picker, on iPhone or iPad.
- Swift 4, iOS9+. UIPopoverController free. 
- Callback
- Swift 4 version is available [here](https://github.com/hsylife/SwiftyPickerPopover/tree/swift4).
## Screenshots
<img src="README_resources/SwiftyPickerPopover_movie.gif" width="362">

## Required
- Swift 4, Xcode 9.
- iOS 9+
- CocoaPods 1.1.0.rc.2+ or Carthage 0.12.0+

## License
MIT.

## Usage
For installing it with CocoaPods, specify it in your 'Podfile'.
Replace ‘YourProjectTargetName’ with your own target name:
```ruby
platform :ios, '9.0'
use_frameworks!
target ‘YourProjectTargetName’ do
pod 'SwiftyPickerPopover' :git => 'https://github.com/hsylife/SwiftyPickerPopover', :branch => 'swift4'
end
```
Run 'pod install'.

Instead, for installing it with Carthage, add it to your Cartfile:
```
github "hsylife/SwiftyPickerPopover" "swift4"
```
Run 'carthage update --platform iOS'.

On Xcode, import the module:
```swift
import SwiftyPickerPopover
```
### Basic
To display a popover with an UIDatePicker, the code looks like this:
```swift
DatePickerPopover(title: "DatePicker")
            .appear(originView: sender, baseViewController: self)
```

To specify more arguments:
```swift
DatePickerPopover(title: "DatePicker")
            .setDateMode(.date)
            .setSelectedDate(Date())
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")})
            .setCancelButton(action: { popover, selectedDate in print("cancel")})
            .appear(originView: sender, baseViewController: self)
```

To display a popover with an UIPickerView that allows users to choose a String type choice:
```swift
StringPickerPopover(title: "StringPicker", choices: ["value 1","value 2","value 3"])
        .setSelectedRow(0)
        .setDoneButton(action: { (popover, selectedRow, selectedString) in
            print("done row \(selectedRow) \(selectedString)")
        })
        .setCancelButton(action: { (popover, selectedRow, selectedString) in print("cancel")}
        )
        .appear(originView: button, baseViewController: self)
```

To display a popover with an UIPickerView of multiple columns:
```swift
ColumnStringPickerPopover(title: "Columns Strings",
                                  choices: [["Breakfast", "Lunch", "Dinner"],["Tacos", "Sushi", "Steak", "Waffles", "Burgers"]],
                                  selectedRows: [0,0], columnPercents: [0.5, 0.5])
        .setDoneButton(action: { popover, selectedRows, selectedStrings in print("selected rows \(selectedRows) strings \(selectedStrings)")})
        .setCancelButton(action: { popover, selectedRows, selectedStrings in print("cancel")})
        .setFontSize(14)
        .appear(originView: sender, baseViewController: self)
)
```

To display a popover with an UIDatePicker of countDownTimer style:
```swift
 CountdownPickerPopover(title: "CountdownPicker")
            .setSelectedTimeInterval(TimeInterval())
            .setDoneButton(action: { popover, timeInterval in print("timeInterval \(timeInterval)")} )
            .setCancelButton(action: { popover, timeInterval in print("cancel")})
            .setClearButton(action: { popover, timeInterval in print("Clear")
                popover.setSelectedTimeInterval(TimeInterval()).reload()
            })
            .appear(originView: sender, baseViewController: self)
```

### Advanced
To display a popover with an UIPickerView that allows users to choose a String type choice with image like UITableViewCell. After adding image files to your target's Assets.xcassets:
```swift
StringPickerPopover(title: "StringPicker", choices: ["value 1","value2",""])
        .setImageNames(["Icon1",nil,"Icon3"])
        .appear(originView: button, baseViewController: self)
```
<img src="README_resources/StringWithImage.jpeg" width="362">

To display a DatePickerPopover has a clear button, which rewinds itself by tapping the button, and.which disappers automatically after a certain number of seconds:
```swift
let p = DatePickerPopover(title: "Clearable DatePicker")
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")} )
            .setCancelButton(action: { _,_ in print("cancel")})
            .setClearButton(action: { popover, selectedDate in
                print("clear")
                //Rewind
                popover.setSelectedDate(Date()).reload()
            })
            
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0)
```

To display a DatePickerPopover of .time style with a time interval of 5 mins and the arrow only to .down direction permitted:
```swift
DatePickerPopover(title: "DatePicker .time 5minInt.")
            .setDateMode(.time)
            .setMinuteInterval(5)
            .setPermittedArrowDirections(.down)
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")} )
            .setCancelButton(action: { _,_ in print("cancel")})
            .appear(originView: sender, baseViewController: self)
)
```

To display a StringPickerPopover which can prepare a choice string for display on picker separately from a source string:
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
        
let p = StringPickerPopover(title: "StringPicker", choices: ["value 1","value 2","value 3"])
            .setDisplayStringFor(displayStringFor)
            .setDoneButton(action: {
                popover, selectedRow, selectedString in
                print("done row \(selectedRow) \(selectedString)")
            })
            .setCancelButton(action: { _,_,_ in
                print("cancel")
            })
            
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
```

A StringPickerPopover appears from the collectionView's cell:
```swift
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let theCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let p = StringPickerPopover(title: "CollectionView", choices: ["value 1","value 2","value 3"])
                        .setSelectedRow(1)
                        .setDoneButton(title:"👌", action: { (popover, selectedRow, selectedString) in print("done row \(selectedRow) \(selectedString)") })
                        .setCancelButton(title:"🗑", action: { (popover, selectedRow, selectedString) in print("cancel")} )
        
        p.appear(originView: theCell, baseViewWhenOriginViewHasNoSuperview collectionView, baseViewController: self)
        
    }
```

If originView has no superView, then then you need to set baseViewWhenOriginViewHasNoSuperview as above to specify sourceView for the position for the arrow. If it has the superview, then SwiftyPickerPopover automatically use it for the sourceView.

## Customize
### How do I customize or localize a popover's storyboard?
When you prepare your customized Storyboard, it will be applied automatically.

1. Find the original file of the popover's Storyboard, which you want to change. For example, 'CountdownPickerPopover.storyboard'.
2. Add it to your project on Xcode for including it into mainBundle. At this time, please check 'Copy items if needed'. Do not change the file name.
3. Next, change the module specified by default. Open the Storyboard file on Xcode and uncheck 'Inherit From Target' in InterfaceBuilder > Identity inspector > Custom Class. Specify 'SwiftyPickerPopover' for 'Module'.
4. Finally, customize your storyboard file.

## Contributors
- Ken Torimaru [GitHub](https://github.com/ktorimaru) for CountdownPickerPopover and ColumnStringPickerPopover.
- BalestraPatrick [GitHub](https://github.com/BalestraPatrick) for correcting README.md.
- andersonlucasg3 [GitHub](https://github.com/andersonlucasg3) for adding possibility to override the storyboards with custom localizations in the app project.

## Author
- Yuta Hoshino [Twitter](https://twitter.com/hsylife) [Facebook](https://www.facebook.com/yuta.hoshino)
