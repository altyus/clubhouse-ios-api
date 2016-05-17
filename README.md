# clubhouse-ios-api

[![CI Status](http://img.shields.io/travis/altyus/clubhouse-ios-api.svg?style=flat)](https://travis-ci.org/altyus/clubhouse-ios-api)
[![Version](https://img.shields.io/cocoapods/v/clubhouse-ios-api.svg?style=flat)](http://cocoapods.org/pods/clubhouse-ios-api)
[![License](https://img.shields.io/cocoapods/l/clubhouse-ios-api.svg?style=flat)](http://cocoapods.org/pods/clubhouse-ios-api)
[![Platform](https://img.shields.io/cocoapods/p/clubhouse-ios-api.svg?style=flat)](http://cocoapods.org/pods/clubhouse-ios-api)

## Features

* Deserializes Clubhouse objects into distinct Swift Structs
* Uses Swift Enums to safely handle and constrain optional params
* Built on top of Alamofire and SwiftyJSON
* Maps all documented Clubhouse.io API calls

## Documentation

[Clubhouse API Documentation](https://clubhouse.io/api/)

## Getting Started

1. Register for a Clubhouse API Token (Login to Clubhouse, Settings -> API Tokens)
2. In your AppDelegate:
```Swift
import clubhouse_ios_api

func application(application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool      
{
    ClubhouseAPI.configure("{ENTER-TOKEN-HERE}")
    return true
}

```

## Installation

clubhouse-ios-api is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "clubhouse-ios-api"
```

## License

clubhouse-ios-api is available under the MIT license. See the LICENSE file for more info.
