![logo](https://github.com/mbfakourii/waiter/assets/20955005/332d38a3-13e6-4e2e-a7ab-127b4f99756f)

# Waiter
[![pub package](https://img.shields.io/pub/v/waiter.svg)](https://pub.dev/packages/waiter)</br>
A flutter package to show loading error and progress bar

## Features
* Show loading
* Show error
* Show progress
* Manage retries
* Support sheets
* Support dialogs
* Support Material 1,2,3

## Example App
<img src="https://raw.githubusercontent.com/mbfakourii/waiter/master/example/screenshots/example.gif" width="300" height="550" />

## Usage
Quick simple usage example:

```dart
WaiterController waiterController = WaiterController();

...

Waiter(
    callback: waiterController,
    onTry: (value) {
      print("onTry");
    },
    firstLoadShowLoading: false,
    child: Scaffold(
      ...
    ),
);

...
    
waiterController.showLoading();
```

### Progress
If you need progress, you can use the following code

```dart
WaiterController waiterController = WaiterController();

ValueNotifier<double> progress = ValueNotifier<double>(0);
ValueNotifier<int> currentNumberProgress = ValueNotifier<int>(0);
ValueNotifier<int> totalNumberProgress = ValueNotifier<int>(0);

...

Waiter(
  callback: waiterController,
  onTry: (value) {
    print("onTry");
  },
  firstLoadShowLoading: true,
  progress: progress,
  currentNumberProgress: currentNumberProgress,
  totalNumberProgress: totalNumberProgress,
  onCancelProgress: (value) {
    print("onCancelProgress");
  },
  onCloseProgress: () {
    print("onCloseProgress");
  },
  child: Scaffold(
    ...
  ),
);

...
waiterController.showProgress("progressTag1");

totalNumberProgress.value = 1;
currentNumberProgress.value = 1;
progress.value = 50.0;
```

## Multi Language
There is a possibility of customization for different languages in this package</br>

```dart
Language language = Language.copy(
    confirm: S.current.confirm,
    pleaseWait: S.current.pleaseWait,
    cancel: S.current.cancel,
    tryAgain: S.current.tryAgain);
    
Waiter(
  ...
  language: language,
  ...
);   
```

```S``` For intl Package

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).
