# Uncomment the lines below you want to change by removing the # in the beginning

# A list of devices you want to take the screenshots from
devices([
  "iPhone 6",
  "iPhone 6 Plus",
  "iPhone 5s",
  "iPhone X"
  # "iPhone 4s"
])

languages([
  "en-US",
  #"zh-Hans",
  # "zh-Hant"
])

# The name of the scheme which contains the UI Tests
scheme "TYPinLock-Example"

# Where should the resulting screenshots be stored?
output_directory "./screenshots"

clear_previous_screenshots true # remove the '#' to clear all previously generated screenshots before creating new ones

xcargs "-only-testing:TYPinLock_UITests"

# Choose which project/workspace to use
# project "./Project.xcodeproj"
 workspace "./Example/TYPinLock.xcworkspace"

# Arguments to pass to the app on launch. See https://github.com/fastlane/fastlane/tree/master/snapshot#launch-arguments
# launch_arguments(["-favColor red"])

# For more information about all available options run
# fastlane snapshot --help

