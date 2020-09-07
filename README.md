 # SwiftyPickerPopover
A more convenient way to display a popover with a built-in picker, on iPhone/iPad of iOS9+.

[![Version](https://img.shields.io/cocoapods/v/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover) 
[![License](https://img.shields.io/cocoapods/l/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyPickerPopover.svg?style=flat)](http://cocoadocs.org/docsets/SwiftyPickerPopover)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)

## Features
- By simple code, you can display a popover that contains a built-in picker, on iPhone or iPad.
- Swift 5, iOS9+. UIPopoverController free. 
- Callback

## Screenshots
<img src="README_resources/SwiftyPickerPopover_movie.gif" width="308">

## Basic

```swift
DatePickerPopover(title: "DatePicker")
            .setDoneButton(action: { _, selectedDate in print(selectedDate)})
            .appear(originView: sender, baseViewController: self)
```

## Required
- Swift 5, Xcode 11.
- iOS 9+
- CocoaPods 1.1.0.rc.2+ or Carthage 0.12.0+

## License
MIT

## Install
### CocoaPods
Specify it in your 'Podfile', after replacing ‘YourProjectTargetName’ with your own target name:
```ruby
platform :ios, '9.0'
use_frameworks!
target ‘YourProjectTargetName’ do
pod 'SwiftyPickerPopover'
end
```
Run 'pod install'.

### Carthage
- Add it to your Cartfile:
```
github "hsylife/SwiftyPickerPopover"
```
- Run `carthage update --platform iOS`
- Add 'SwiftyPickerPopover.framework' to 'Linked Frameworks and Library' on your project.
- Add `/usr/local/bin/carthage copy-frameworks` to 'New Run Script Phase'.
- Add `$(SRCROOT)/Carthage/Build/iOS/SwiftyPickerPopover.framework` to 'Input Files'.

### import
On your .swift file, import the module:
```swift
import SwiftyPickerPopover
```
### Popover types
SwiftyPickerPopover offers you the following popovers:
- **StringPickerPopover**: has an UIPickerView that allows user to choose a SwiftyModelPicker type choice.
- **ColumnStringPickerPopover**: has an UIPickerView of multiple columns with SwiftyModelPicker type choice.
- **DatePickerPopover**: has an UIDatePicker that allows user to choose a Date type choice.
- **CountdownPickerPopover**: has an UIDatePicker specializing in countDownTimer style.

### APIs and examples
#### Common
All popovers have the following APIs.

* setPermittedArrowDirections()
* setArrowColor()
* setSize(width:,height:)
* setCornerRadius()
* setValueChange(action:)
* setOutsideTapDismissing(allowed:)
* setDimmedBackgroundView(enabled:)

* appear(originView:, baseViewWhenOriginViewHasNoSuperview:, baseViewController:, completion:)
* appear(barButtonItem:, baseViewWhenOriginViewHasNoSuperview:, baseViewController:, completion:)
* disappear()
* disappearAutomatically(after seconds:, completion:)
* reload()

#### StringPickerPopover
* init(title:, choices:)

* setFont()
* setFontSize()
* setFontColor()
* setImageNames()
* setImages()
* setSelectedRow()
* setRowHeight()
* setDisplayStringFor()
* setDoneButton(title:, font:, color:, action:)
* setCancelButton(title:, font:,  color:, action:)
* setClearButton(title:, font:,  color:, action:)

##### You can use StringPickerPopover like this:
```swift
//Setup SwiftyModelPicker data
let choices = [SwiftyModelPicker(id: 1, title: "value 1"),SwiftyModelPicker(id: 2, title: "value 2"),SwiftyModelPicker(id: 3, title: "value 3")]

StringPickerPopover(title: "StringPicker", choices: choices)
        .setSelectedRow(0)
        .setValueChange(action: { _, _, selectedObject in
            print("current string: \(selectedObject.title) & id: \(selectedObject.id)")
        })
        .setDoneButton(action: {
            popover, selectedRow, selectedObject in
            print("done row \(selectedRow) string \(selectedObject.title) & id \(selectedObject.id)")
        })
        .setCancelButton(action: { (_, _, _) in print("cancel")}
        )
        .appear(originView: button, baseViewController: self)
```

##### StringPickerPopover can have images. 

<img src="README_resources/StringWithImage.jpeg" width="362">

After adding image files to your target's Assets.xcassets:
```swift
//Setup SwiftyModelPicker data with images
let choices = [SwiftyModelPicker(id: 1, title: "value 1", imageName: "Icon1"),SwiftyModelPicker(id: 2, title: "value 2"),SwiftyModelPicker(id: 3, title: "", imageName: "Icon3")]

StringPickerPopover(title: "StringPicker", choices: choices)
        .appear(originView: button, baseViewController: self)
```

##### It can separate the screen values from the raw values:
```swift
let displayStringFor:((SwiftyModelPicker?)->SwiftyModelPicker?)? = { object in
    if let s = object {
        switch(s.title){
        case "value 1":
            return SwiftyModelPicker(id: 1, title: "😊")
        case "value 2":
            return SwiftyModelPicker(id: 2, title: "😏")
        case "value 3":
            return SwiftyModelPicker(id: 3, title: "😓")
        default:
            return s
        }
    }
    return nil
}
        
//Setup SwiftyModelPicker data
let choices = [SwiftyModelPicker(id: 1, title: "value 1"),SwiftyModelPicker(id: 2, title: "value 2"),SwiftyModelPicker(id: 3, title: "value 3")]        
        
let p = StringPickerPopover(title: "StringPicker", choices: choices)
            .setDisplayStringFor(displayStringFor)
            .setDoneButton(action: {
                popover, selectedRow, selectedObject in
                print("done row \(selectedRow) string \(selectedObject.title) & id \(selectedObject.id)")
            })
            .setCancelButton(action: { _, _, _ in
                print("cancel")
            })
            
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
```

##### To specify the size:
```swift

//Setup SwiftyModelPicker data
let choices = [SwiftyModelPicker(id: 1, title: "value 1"),SwiftyModelPicker(id: 2, title: "value 2"),SwiftyModelPicker(id: 3, title: "value 3")] 

StringPickerPopover(title: "Narrow StringPicker", choices: choices)
            .setSize(width: 250.0)
            .appear(originView: sender, baseViewController: self)
```
The default width and height of popover are both 300.0.
By using setSize(width:, height:), you can override it or them.
When you set nil to the parameter or don't specify it, the default will be used.

##### It appears from the collectionView's cell:
```swift
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let theCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //Setup SwiftyModelPicker data
        let choices = [SwiftyModelPicker(id: 1, title: "value 1"),SwiftyModelPicker(id: 2, title: "value 2"),SwiftyModelPicker(id: 3, title: "value 3")] 
        
        let p = StringPickerPopover(title: "CollectionView", choices: choices)
                        .setSelectedRow(1)
                        .setDoneButton(title:"👌", action: { (popover, selectedRow, selectedObject) in print("done row \(selectedRow) string \(selectedObject.title) & id \(selectedObject.id)") })
                        .setCancelButton(title:"🗑", action: { (_, _, _) in print("cancel")} )
        
        p.appear(originView: theCell, baseViewWhenOriginViewHasNoSuperview collectionView, baseViewController: self)
        
    }
```

If originView has no superView, then then you need to set baseViewWhenOriginViewHasNoSuperview as above to specify sourceView for the position for the arrow.
If it has the superview, then SwiftyPickerPopover automatically use it for the sourceView.

##### It appears from an UIBarButtonItem:
```swift
let item: UIBarButtonItem = sender
let originView = item.value(forKey: "view") as! UIView
p.appear(originView: originView, baseViewController: self)
```

#### ColumnStringPickerPopover
* init(title:, choices:, selectedRows:, columnPercents:)

* setFonts()
* setFontSizes()
* setFontColors()
* setSelectedRows()
* setDisplayStringFor()
* setDoneButton(title:, font:, color:, action:)
* setCancelButton(title:, font:, color:, action:)
* setClearButton(title:, font:,  color:, action:)

##### ColumnStringPickerPopover can have multiple String values:
```swift

//Setup SwiftyModelPicker data
let column1 = [SwiftyModelPicker(id: 1, title: "Breakfast"),SwiftyModelPicker(id: 2, title: "Lunch"),SwiftyModelPicker(id: 3, title: "Dinner")]
let column2 = [SwiftyModelPicker(id: 11, title: "Tacos"),SwiftyModelPicker(id: 12, title: "Sushi"),SwiftyModelPicker(id: 13, title: "Steak"),SwiftyModelPicker(id: 14, title: "Waffles", object: nil),SwiftyModelPicker(id: 15, title: "Burgers")]

//ColumnStringPickerPopover appears.
ColumnStringPickerPopover(title: "Columns Strings",
                          choices: [column1, column2],
                          selectedRows: [0,0], columnPercents: [0.5, 0.5])
.setDoneButton(action: { popover, selectedRows, selectedObjects in
    print("selected rows \(String(describing: selectedRows.first)) id \(selectedObjects.first?.id ?? 0) strings \(selectedObjects.first?.title ?? "")")
    print("selected rows \(String(describing: selectedRows.last)) id \(selectedObjects.last?.id ?? 0) strings \(selectedObjects.last?.title ?? "")")
})
.setCancelButton(action: { _,_,_ in print("cancel")})
.setValueChange(action: { _, _, selectedObjects in
    print("current strings: \(selectedObjects.first?.title ?? "")")
    print("current strings: \(selectedObjects.last?.title ?? "")")
})
.setFonts([UIFont.boldSystemFont(ofSize: 14), nil])
.setFontColors([nil, .red])
.setFontSizes([20, nil]) // override
.setSelectedRows([0,2])
.appear(originView: sender, baseViewController: self)

```

#### DatePickerPopover
* init(title:)

* setSelectedDate()
* setDateMode()
* setMinimumDate()
* setMaximumDate()
* setMinuteInterval()
* setLocale()
* setDoneButton(title:, font:, color:, action:)
* setCancelButton(title:, font:, color:, action:)
* setClearButton(title:, font:, color:, action:)

##### DatePickerPopover can be used like this:
```swift
DatePickerPopover(title: "DatePicker")
            .setDateMode(.date)
            .setSelectedDate(Date())
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")})
            .setCancelButton(action: { _, _ in print("cancel")})
            .appear(originView: sender, baseViewController: self)
```

##### The clear button rewinds the picker. And it disappers automatically after a specified seconds:
```swift
let p = DatePickerPopover(title: "Clearable DatePicker")
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")} )
            .setCancelButton(action: { _, _ in print("cancel")})
            .setClearButton(action: { popover, selectedDate in
                print("clear")
                //Rewind
                popover.setSelectedDate(Date()).reload()
            })
            
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0)
```

##### The time interval is 5 mins. The arrow is permitted only to .down direction.:
```swift
DatePickerPopover(title: "DatePicker .time 5minInt.")
            .setDateMode(.time)
            .setMinuteInterval(5)
            .setPermittedArrowDirections(.down)
            .setDoneButton(action: { popover, selectedDate in print("selectedDate \(selectedDate)")} )
            .setCancelButton(action: { _, _ in print("cancel")})
            .appear(originView: sender, baseViewController: self)
)
```

#### CountdownPickerPopover
* init(title:)

* setSelectedTimeInterval
* setDoneButton(title:, font:, color:, action:)
* setCancelButton(title:, font:, color:, action:)
* setClearButton(title:, font:, color:, action:)

##### CountdownPickerPopover can be used like this:
```swift
 CountdownPickerPopover(title: "CountdownPicker")
            .setSelectedTimeInterval(TimeInterval())
            .setDoneButton(action: { popover, timeInterval in print("timeInterval \(timeInterval)")} )
            .setCancelButton(action: { _, _ in print("cancel")})
            .setClearButton(action: { popover, timeInterval in print("Clear")
                popover.setSelectedTimeInterval(TimeInterval()).reload()
            })
            .appear(originView: sender, baseViewController: self)
```

## Customize
### How do I customize a popover's storyboard?
When you prepare your customized Storyboard, it will be applied automatically.

1. Find the original file of the popover's Storyboard, which you want to change. For example, 'CountdownPickerPopover.storyboard'.
2. Add it to your project on Xcode for including it into mainBundle. At this time, please check 'Copy items if needed'. Do not change the file name.
3. Next, change the module specified by default. Open the Storyboard file on Xcode and uncheck 'Inherit From Target' in InterfaceBuilder > Identity inspector > Custom Class. Specify 'SwiftyPickerPopover' for 'Module'.
4. Finally, customize your storyboard file.

## Contributors
- Ken Torimaru [GitHub](https://github.com/ktorimaru) for CountdownPickerPopover and ColumnStringPickerPopover.
- BalestraPatrick [GitHub](https://github.com/BalestraPatrick) for README.md typo.
- andersonlucasg3 [GitHub](https://github.com/andersonlucasg3) for adding possibility to override the storyboards with custom localizations in the app project.
- lswith [GitHub](https://github.com/lswith) for fixing circular reference issue of Cartfile.
- coybit [GitHub](https://github.com/coybit) for adding setImages() to StringPickerPopover.
- Mihael Isaev [GitHub](https://github.com/MihaelIsaev) for adding appear() from barButtonItem.
- iosMaher [GitHub](https://github.com/iosMaher) for idea of setFont() and setFontColor().
- gbuela [GitHub](https://github.com/gbuela) for setValueChange(action:) API for all popover types.
- ikbalyasar [GitHub](https://github.com/ikbalyasar) for demo code for showing selected value on StringPickerPopover.
- weakfl [GitHub](https://github.com/weakfl) for update to Swift 4.2
- Tobisaninfo[GitHub](https://github.com/Tobisaninfo( for cartage support with Xcode 10.2
- Alexwing[GitHub](https://github.com/Alexwings) for update to Swift 5.0 

## Author
- Yuta Hoshino [Twitter](https://twitter.com/hsylife) [Facebook](https://www.facebook.com/yuta.hoshino)
