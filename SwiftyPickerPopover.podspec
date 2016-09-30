Pod::Spec.new do |s|

  s.name         = "SwiftyPickerPopover"
  s.version      = "2.0.0"
  s.summary      = "Popover with Picker/DatePicker by Swift 3 for iPhone/iPad, iOS9+."
  s.homepage     = "https://github.com/hsylife/SwiftyPickerPopover"
  s.license      = "MIT"
  s.author             = { "Yuta Hoshino" => "ythshn@gmail.com" }
  s.platform     = :ios, "9.0"
  # s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/hsylife/SwiftyPickerPopover.git", :tag => s.version }
  s.source_files  = "SwiftyPickerPopover/*.swift"
  s.resources = "SwiftyPickerPopover/**/*.storyboard","SwiftyPickerPopover/**/*.strings"

  s.requires_arc = true
end
