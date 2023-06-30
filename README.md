
![logo](https://github.com/mbfakourii/waiter/assets/20955005/332d38a3-13e6-4e2e-a7ab-127b4f99756f)

# Waiter
<a href="https://pub.dev/packages/waiter"><img src="https://img.shields.io/pub/v/waiter.svg" alt="Pub"></a></br>
A flutter package to show loading error and progress bar

## Features
* Show loading
* Show error
* Show progress
* Support sheets
* Support dialogs
* Support Material 1,2,3

## Example App
<img src="https://raw.githubusercontent.com/mbfakourii/full_picker/master/example/screenshots/example.gif" width="300" height="550" />

## Usage
Quick simple usage example:

```dart
FullPicker(
  context: context,
  prefixName: "test",
  file: true,
  image: true,
  video: true,
  videoCamera: true,
  imageCamera: true,
  voiceRecorder: true,
  videoCompressor: false,
  imageCropper: false,
  multiFile: true,
  url: true,
  onError: (int value) {
    print(" ----  onError ----=$value");
  },
  onSelected: (value) {
    print(" ----  onSelected ----");
  },
);
```

## Multi Language
There is a possibility of customization for different languages in this package</br>

```dart
Language language = Language.copy(
    camera: S.current.camera,
    selectFile: S.current.selectFile,
    file: S.current.file,
    voiceRecorder: S.current.voiceRecorder,
    url: S.current.url,
    enterURL: S.current.enterURL,
    cancel: S.current.cancel,
    ok: S.current.ok,
    gallery: S.current.gallery,
    cropper: S.current.cropper,
    onCompressing: S.current.onCompressing,
    tapForPhotoHoldForVideo: S.current.tapForPhotoHoldForVideo,
    cameraNotFound: S.current.cameraNotFound,
    noVoiceRecorded: S.current.noVoiceRecorded,
    denyAccessPermission: S.current.denyAccessPermission);
    
FullPicker(
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
