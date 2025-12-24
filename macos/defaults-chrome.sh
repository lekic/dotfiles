# Disable swipe navigation
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# Disable swipe navigation with mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
