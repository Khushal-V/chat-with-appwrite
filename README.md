# My Chat App

This is My Chat app

---

## Getting Setup

1. Make sure your flutter version is set to 3.7.1. You can find more information on how to downgrade here: [link](https://fluttercorner.com/how-to-downgrade-flutter-sdk/).

2. Make sure you have an emulator installed, either Android througb AVD manager or iOS through XCODE.

Please Note, you may need to increase the amount of internal storage on the Android emulator. You can find information about this online.

3. run:

```sh
flutter doctor
```

If you are missing any libraries or extra files, it will tell you here.

4. You should have everything setup to run the app. If you have an issue with pods, make sure you have cocoapods installed and

```sh
cd ios
pod install
```

if there are still errors, try:

```sh
pod repo update
sudo gem uninstall ffi && sudo gem install ffi -- --enable-libffi-alloc
```

---

## Setup .env
Before going to run app you should setup the enviornment file.
1. Create .env file on project level
2. Add below variables to in it.
    - projectId
    - databaseId
    - userCollection
    - messagesCollection
    - chatCollection
    - bucketCollection
    - profileBucketCollection

## Getting Started 🚀

This project contains:

- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Production
$ flutter run --target lib/main.dart
```

_\*My Chat Flutter works on iOS, Android._

## Useful Commands

List all unused files:

```sh
flutter pub run dart_code_metrics:metrics check-unused-files lib
```

If you are missing any libraries or extra files, it will tell you here.

```sh
flutter doctor
```

Download APK: [My Chat](https://drive.google.com/file/d/1JMQwlaFtOHtIO77ZBV1nH4xP2sH1myLg/view?usp=sharing).

Screen-Shots
![Login Page](https://github.com/Khushal-V/chat-with-appwrite/assets/125572633/18ebd9fd-2d97-454e-bbb7-b0b72ffb62ce)

![Registration Page](https://github.com/Khushal-V/chat-with-appwrite/assets/125572633/ea0e9111-5a2b-434d-a38a-60ee095dfb26)

![Main/Home Page](https://github.com/Khushal-V/chat-with-appwrite/assets/125572633/0ce1b471-20e4-4cf0-b0fa-4bedeeb099d3)

![Select User Page](https://github.com/Khushal-V/chat-with-appwrite/assets/125572633/30b473c8-5e3d-41a8-a985-fbbf15420eba)

![Chat Page](https://github.com/Khushal-V/chat-with-appwrite/assets/125572633/9fa613a9-2af1-4d23-92c3-9c327ee6fc73)

![Profile Page](https://github.com/Khushal-V/chat-with-appwrite/assets/125572633/4628acdf-50bd-456c-ac92-96b4a2573a1d)





