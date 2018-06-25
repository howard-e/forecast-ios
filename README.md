# Forecast
A simple iOS app for weather forecasting.

## Overview

Forecast is a simple iOS app for weather forecasting. It should show the actual weather for your current location. In the forecast tab, it should show the forecast for the next 5 days (in 3 hour intervals) at your current location.

### What's Done (as per instructions for project)

- [x] Making use of Auto Layout to make the layout responsive for all screen sizes. Full iPhone support.
- [x] Use of CocoaPods and Swift (Zero use of Objective-C). 
- [x] Use of Open Weather Map API (http://openweathermap.org/api).
- [x] Use of Geolocation for determining the current position of the device. 
- [x] Use of UIActivityViewController to share today's weather information.
- [x] Using the Firebase SDK (Firestore) to store data retrieved from Open Weather Map for later processing for each specific user (using vendor identifier's UUID).
- [x] Use of all graphic assets.
- [x] Use of fonts where applicable.
- [x] Handling of error states (such as being offline, data not loading, errors, etc).
- [x] Refreshing of Today Tab. `[ADDITIONAL FEATURE]`
- [x] Refreshing of Forecast Tab. `[ADDITIONAL FEATURE]`
- [x] Onboarding page to introduce user to application and request their permission to use their location. `[ADDITIONAL FEATURE]`
- [ ] Reading stored information from Firebase SDK (Firestore) as a fallback. `[ADDITIONAL FEATURE]`
- [ ] Making Forecast items clickable to see full information on that forecast item. `[ADDITIONAL FEATURE]`

## How To Run Project

- **NB: [CocoaPods](https://cocoapods.org) is used to manage the project's dependencies.**
1. `git clone` the repository or download the zip file.
2. Navigate to project in your terminal.
3. Ensure [CocoaPods](https://cocoapods.org) is on your machine.
4. `pod repo update`.
5. `pod install`.
6. Open Forecast.xcworkspace in Xcode or `open Forecast.xcworkspace/`.
7. Build and run the project on a Simulator or a physical device.

### Environment Tested Under

- OS: macOS High Sierra 10.14 Beta (18A314h)
- XCODE: 9.4.1 / 10.0 beta 2
- SWIFTLANG: 4.1
- COCOAPODS: 1.5.3