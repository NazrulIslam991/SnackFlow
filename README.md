# SnackFlow


| Pub.dev | License | Platform |
| :---: | :---: | :---: |
| [![pub package](https://img.shields.io/pub/v/snackflow.svg)](https://pub.dev/packages/snackflow) | [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) | [![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev) |



## Features

The SnackFlow Flutter package is a customizable overlay notification system that lets developers show modern, glassmorphic-style snack messages anywhere on the screen. It provides four default methods—show, success, failed, and error—so users can quickly display messages by type, e.g., SnackFlow.success(context, "Profile updated!"). Each method is fully customizable with parameters like title, backgroundColor, textColor, icon, leading widget, duration, borderRadius, position, verticalPosition, action buttons, and a close button.

Features include glassmorphic design with blur, adaptive text color, multiple positions, vertical alignment, optional avatars/icons, action buttons, smooth slide animations, haptic feedback, and auto-dismissal. SnackFlow saves time, improves UX, and is perfect for notifications, alerts, warnings, and confirmations.

Key Methods:

    SnackFlow.show(...) – Neutral message
    
    SnackFlow.success(...) – Green success
    
    SnackFlow.failed(...) – Orange warning
    
    SnackFlow.error(...) – Red error

It allows interactive, stylish, and fully customizable notifications effortlessly.




## Demo


<p align="center">
  <img src="https://github.com/user-attachments/assets/7618c273-495a-45d7-a4b1-68ad58b65370" alt="GIF Preview" width="250", height="500" />
</p>




### Installation

1. pubspec.yaml

```yaml
dependencies:
  snackflow: <latest_version>
```

2. run `flutter pub get` in your terminal.


### Prerequisites

* Flutter SDK: `>=3.0.0`
* Dart SDK: `>=2.18.0`


## Import
```dart
import 'package:snackflow/snackflow.dart';
```



## Quick Usage 
1. Basic show()

```dart
SnackFlow.show(
  context,
  "Data loaded successfully.",
);
```

2. Basic success()

```dart
SnackFlow.success(
  context,
  "Payment completed. Thank you!",
);


```

3. Basic error()

```dart
SnackFlow.error(
  context,
  "Server connection lost. Please try again.",
);

```

4. Basic failed()

```dart
SnackFlow.failed(
  context,
  "Input verification failed due to an error.",
);


```


5. Top Position ( using show() method)

```dart
SnackFlow.show(
  context,
  "This notification is visible at the top of the screen.",
  position: SnackPosition.top,
);


```

6. Center Position ( using show() method)


```dart
SnackFlow.show(
  context,
  "This notification will be shown in the exact center.",
  position: SnackPosition.center,
);


```


7. Left Position, Top aligned ( using show() method)


```dart
SnackFlow.show(
  context,
  "Left side, aligned to the top.",
  position: SnackPosition.left,
  verticalPosition: VerticalPosition.top,
);


```

8 Right Position, Middle aligned ( using success() method)


```dart
SnackFlow.success(
  context,
  "Right side, aligned to the middle vertically.",
  position: SnackPosition.right,
  verticalPosition: VerticalPosition.middle,
);


```

9 Action Button Example ( using show() method)


```dart
SnackFlow.show(
  context,
  "Do you want to update your profile now?",
  actionLabel: "Update",
  onAction: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Action button clicked!')),
    );
  },
);


```

10 Leading Widget & Title ( using show() method)


```dart
SnackFlow.show(
  context,
  "You have received a new message.",
  leading: const CircleAvatar(
    backgroundColor: Colors.redAccent,
    child: Icon(Icons.mail, color: Colors.white, size: 20),
  ),
  title: "New Message!",
);


```

11 Custom Colors ( using failed() method)


```dart
SnackFlow.failed(
  context,
  "White background and dark blue text.",
  backgroundColor: Colors.white,
  textColor: Colors.blueGrey.shade900,
  duration: const Duration(seconds: 7),
  title: "Custom Look",
);


```

12 On Dismiss Callback ( using error() method)


```dart
SnackFlow.error(
  context,
  "Something will happen when this notification is closed.",
  title: "Timer On",
  duration: const Duration(seconds: 3),
  onDismiss: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification dismissed.')),
    );
  },
);


```


## Properties Reference

| Property / Method    | Type             | Default / Description                                    |
| -------------------- | ---------------- | -------------------------------------------------------- |
| **message**          | String           | Text to display in the snack                             |
| **backgroundColor**  | Color?           | Badge background color                                   |
| **textColor**        | Color?           | Text & icon color; default white                         |
| **icon**             | IconData?        | Optional leading icon                                    |
| **leading**          | Widget?          | Optional custom leading widget                           |
| **duration**         | Duration         | Auto-dismiss time; default 3s                            |
| **borderRadius**     | double           | Rounded corners; default 10                              |
| **position**         | SnackPosition    | top/bottom/center/left/right; default `bottom`           |
| **verticalPosition** | VerticalPosition | For left/right: top/middle/bottom; default bottom        |
| **actionLabel**      | String?          | Optional action button text (e.g., "UNDO")               |
| **onAction**         | VoidCallback?    | Callback when action pressed                             |
| **showClose**        | bool             | Show close “X”; default false                            |
| **onDismiss**        | VoidCallback?    | Callback when snack is hidden                            |
| **show()**           | Method           | Neutral/default notification; customizable colors & icon |
| **success()**        | Method           | Success notification; green & check icon                 |
| **failed()**         | Method           | Warning/failed notification; orange & warning icon       |
| **error()**          | Method           | Error notification; red & error icon                     |






### License
    This package is released under the MIT License — free for commercial and personal use.

## Additional Information 


1. Reporting Issues

    If you encounter any bugs or have feature requests, please feel free to **file an issue** on the 
[GitHub repository]( https://github.com/NazrulIslam991/SnackFlow).


2. Version History
   
  For a complete history of changes, bug fixes, and updates, please refer to the `CHANGELOG.md` file included in this repository.


### Contributing
  Contributions are always welcome! You can **fork the repository**, make your improvements, and submit a **pull request**. Let’s make this package better together. 
  

