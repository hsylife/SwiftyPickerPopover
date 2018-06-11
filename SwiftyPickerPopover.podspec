Pod::Spec.new do |s|

  s.name         = "SwiftyPickerPopover"
  s.version      = "6.6.1"
  s.summary      = "A more convenient way to display a popover with a built-in picker, on iPhone/iPad of iOS9+."
  s.homepage     = "https://github.com/hsylife/SwiftyPickerPopover"
  s.license      = "MIT"
  s.author             = { "Yuta Hoshino" => "ythshn@gmail.com" }
  s.platform     = :ios, "9.0"
  # s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/hsylife/SwiftyPickerPopover.git", :tag => s.version }
  s.source_files  = "SwiftyPickerPopover/*.swift"
  s.resources = ["SwiftyPickerPopover/**/*.{storyboard,strings}","SwiftyPickerPopover/*.{storyboard,strings}"]

  s.requires_arc = true

end
