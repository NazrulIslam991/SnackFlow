# SnackFlow

---

| Pub.dev | License | Platform |
| :---: | :---: | :---: |
| [![pub package](https://img.shields.io/pub/v/snackflow.svg)](https://pub.dev/packages/snackflow) | [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) | [![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev) |

---

## Features

A modern and fully customizable Flutter snack notification system that uses overlays to display beautiful, smooth alerts on any screen. It supports multiple screen positions, stylish slide animations, and optional action or undo buttons. You can show left, right, or center floating snack badges, add gentle haptic feedback, and even attach your own custom leading widgets. The system is also theme-aware, automatically adapting to both light and dark modes for a polished and consistent user experience.


---

## Demo


<p align="center">
  <img src="https://github.com/user-attachments/assets/7618c273-495a-45d7-a4b1-68ad58b65370" alt="GIF Preview" width="250", height="500" />
</p>







### Installation
---
1. pubspec.yaml

```yaml
dependencies:
  snackflow: <latest_version>
```
---

2. run `flutter pub get` in your terminal.


### Prerequisites
---
* Flutter SDK: `>=3.0.0`
* Dart SDK: `>=2.18.0`


## Import
---
```dart
import 'package:snackflow/snackflow.dart';
```



## Quick Usage 
---
1. Basic show()

```dart
SnackFlow.show(
  context,
  "This is a default info message.",
);
```

2. Basic success()

```dart
SnackFlow.success(
  context,
  "Profile updated successfully!",
   duration: const Duration(seconds: 4),
);

```


3. Basic failed()

```dart
SnackFlow.failed(
   context,
   "Warning: Something went wrong.",
);

```

4. Basic error()

```dart
SnackFlow.error(context, "Network disconnected!");

```

5. Top Position with Action Button (UNDO) and Close Button

```dart
SnackFlow.show(
  context,
  "Saved! You can undo.",
   position: SnackPosition.top, //  Set position to Top
  actionLabel: "UNDO", // Add action button
  onAction: () {
     HapticFeedback.lightImpact();
     // Action logic goes here
    },
    showClose: true, // Show the 'X' button
 );

```

6. Left Position, vertically aligned to the Bottom


```dart
SnackFlow.success(
   context,
  "New mail received!",
   position: SnackPosition.left, //  Set position to Left
   verticalPosition: VerticalPosition .bottom, //  Vertically Bottom alignment
  duration: const Duration(seconds: 4),
);

```


7. Right Position, vertically aligned to the Middle


```dart
SnackFlow.error(
   context,
  "Access Denied!",
  position: SnackPosition.right, //  Set position to Right
  verticalPosition: VerticalPosition  .middle, //  Vertically Middle alignment
);

```

8 Custom: Center Position


```dart
SnackFlow.failed(
   context,
   "Upload failed!",
   position: SnackPosition.center, // Set position to Center
 );

```


## Properties Reference
---

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


---



### License
---
    This package is released under the MIT License — free for commercial and personal use.
---

## Additional Information 


Reporting Issues
---
    If you encounter any bugs or have feature requests, please feel free to **file an issue** on the 
[GitHub repository]( https://github.com/NazrulIslam991/SnackFlow).

---

Version History
---
  For a complete history of changes, bug fixes, and updates, please refer to the `CHANGELOG.md` file included in this repository.

---

### Contributing
  Contributions are always welcome! You can **fork the repository**, make your improvements, and submit a **pull request**. Let’s make this package better together. 
  

