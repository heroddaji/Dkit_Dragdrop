# Dkit_Dragdrop

[![CI Status](http://img.shields.io/travis/daitran/Dkit_Dragdrop.svg?style=flat)](https://travis-ci.org/daitran/Dkit_Dragdrop)
[![Version](https://img.shields.io/cocoapods/v/Dkit_Dragdrop.svg?style=flat)](http://cocoapods.org/pods/Dkit_Dragdrop)
[![License](https://img.shields.io/cocoapods/l/Dkit_Dragdrop.svg?style=flat)](http://cocoapods.org/pods/Dkit_Dragdrop)
[![Platform](https://img.shields.io/cocoapods/p/Dkit_Dragdrop.svg?style=flat)](http://cocoapods.org/pods/Dkit_Dragdrop)

## Overview

a simple subclass of UIImageview, written Swift for enabling drag and drop with animation.

## Usage
let's say you want to drag an apple(DKDraggableView) to cart(UIImageView), and perform some actions when you drop on cart.

you set the drop target with 
```
apple.enableDragging = true
apple.setDropTarget(cart)

```
And get notified on drop by implement the method onDropedToTarget() of DKDraggableViewDelegate protocol

```Swift
class DraggableViewController: UIViewController, DKDraggableViewDelegate {

@IBOutlet weak var apple:DKDraggableView!
@IBOutlet weak var cart: UIImageView!

override func viewDidLoad() {
    super.viewDidLoad()

    apple.delegate = self
    apple.enableDragging = true
    apple.setDropTarget(cart)
}

func onDropedToTarget(sender: DKDraggableView, target:UIView) {
        NSLog("Drop to target \(target.tag)")
    }
}

```

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0

## Installation

Dkit_Dragdrop is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Dkit_Dragdrop"
```

## Author

daitran, tranhoangdainguyen@gmail.com

## License

Dkit_Dragdrop is available under the MIT license. See the LICENSE file for more info.
