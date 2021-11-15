#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Mimestream.app"
dockutil --no-restart --add "/System/Applications/Messages.app/"
dockutil --no-restart --add "/Applications/Discord Canary.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/System/Applications/Utilities/Terminal.app"

dockutil --no-restart --add "/Applications" --view grid --display folder --sort name
dockutil --no-restart --add "~/Downloads" --view grid --display folder --sort name

killall Dock
