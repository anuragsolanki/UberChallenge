# FlickrImage Search
> This project has been coded using Xcode 10.1 (10B61) and Swift 4.2.1

[![Swift Version](https://img.shields.io/badge/swift-4.2-orange.svg)](https://swift.org)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)]()

- This app uses the Flickr image search API and shows the results in a 3-column scrollable view
- User can enter queries, such as "kittens" to view resulting images
- Supports endless scrolling, automatically requesting and displaying more images when the user scrolls to the bottom of the view.

![](screenshot.png)

## Features

- [x] Main view has a search bar in which you can enter any text to view result of Flickr image search API for that text.

## Requirements

- iOS 10.0+
- Xcode 10

## What could be done better:

1) Adding a loader/spinner to display during the time when results are being fetched from api.  
2) Purging data from memory ie; when user scrolls down and down from page 1 to n then the result array keeps on increasing. We could just keep result of current page (+ previous and next page) and purge all others. Fetch them on demand (of user's scrolling)
3) Image caching mechanism could be improved.
