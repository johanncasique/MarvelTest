# Marvel app

### 

This is a small test with Marvel's api, it's was build with MVVM-C Architecture.

The app has two displays, one for main list with all the Marvel's characters paginating each 20 items, the second screen has minimal detail, name, image and description but in certain cases the description is nil.

I have separate all the network layer in a local framework, but it can be exported trough swift packaged manager. The data framework has repository pattern and handle all endpoints, baseURL, calls to network and all the logic to build the hash needed to establish connection with the api.

Not using storyboard or XIB at the app, all the screens are made by code, is more easy to maintain and friendly with big teams working in an single screen at the same time.

I have used the Coordinator patter to handle all the navigation.

I have used the system colors and fonts to handle the dark/light mode

Included Unit Test for Characters Data model

TODO:

build all the visual components in a separate framework using Atomic Design

Include snapshot test for the UI

Include SwiftLint

Use a service to automate Build and test

Install Fastlane

Incluide test at the data framework

Handle API's errors
