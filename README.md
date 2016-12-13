# Venue iOS
iOS application for the Venue platform

For the web side of this platform, see: https://github.com/rcos/venue.

This application is still under development and is currently in a stable alpha state.

The Venue platform is an open source platform for event check-in without the need for human management for checkin or validation.  We use geolocation and images to enforce user attendance.  The Venue platform currently consists of the web front end for instructor management tools and user check-in.  The iOS application is meant for students to browse their available courses and events as assigned through school systems (future integration).  They can select an event either from a list of all available events, or through each classes's available events.

The motivation for Venue is to open students up to events outside of their field of study.  Many events around college campus’s can be valuable for students to attend and instructors would like to credit students who attend these events. However, there is often no human means of validating that a student actually attended the event (e.g. the instructor is not present at the event and attendance is not taken). The goal of Venue is to build a web-based platform for instructors to assign their students to events and have the students credited for attending these events if they take photos of themselves at the event (preferably with geotagging) or validate via their GPS coordinates. The application should also provide instructors with an easy-to-use interface to mark locations as the event location, view student attendance and view and verify photos at the event. Students will should be provided mobile application/interface that allows them to validate their attendance at events.


## Getting Started

First, clone the repository.

```
git clone git@github.com:rcos/venue-ios.git
cd venue-ios/
```

Next, make sure you have [CocoaPods](https://cocoapods.org) installed.

```
sudo gem install cocoapods
```

If you have installed CocoaPods, make sure its repo is up to date.

```
pod repo update
```

Install the required pods.

```
pod install
```

Open up the Xcode workspace.

```
open Venue.xcworkspace
```

Build and Run (⌘R)!

If you’re having Code Signing issues, select the “Venue” project in the Project navigator.
For “Team”, select your Personal Team and update the Bundle Identifier accordingly (e.g., “com.myname.Venu”).
Ensure you don’t commit these local changes to the project to the upstream repository.
Build & Run again!

