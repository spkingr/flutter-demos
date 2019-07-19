# Flutter Projects With Dart
My everyday Flutter practice demos with Dart.

***
## 26. MVC in Flutter(Test)

*Date: 2018-8-18*

![project_flutter_mvc](https://github.com/spkingr/flutter-demos/raw/master/project_flutter_mvc/project_flutter_mvc.gif)

Tips:

* Try the *MVC* framework in Flutter with Dart(Bad practice, I think.)
* Use the `ClipRect` and `Transform` to build a simple 3D-like animation widget, and with `Offstage`, `RichText` ect
* Test custom gestures in Flutter

***
## 25. Simple Flutter Game (Failure)

*Date: 2018-7-21*

The BUGS in the project not fixed till now...

Tips:

* Use `Flame` library in Flutter for game development
* With `Sprite`, `Animation`, `Texture`, and `Collision` in `Box2D` components
* Other stuffs: keep screen on, music play, device orientation and ect

**PS:** The game is failed for some reasons, include my development knowledge and the mature of the game framework, even thought, you can have a try!

***
## 24. Flutter Test

*Date: 2018-7-12*

![project_flutter_test](https://github.com/spkingr/flutter-demos/raw/master/project_flutter_test/project_flutter_test.gif)

Tips:

* Basic unit test in Flutter: `group`, `test` and `expect`
* Mock object test in Flutter with `mockito` library: `Mock`, `verify`, `when` and matchers
* Flutter Widget test with `flutter_test` package: `testWidgets`, `pumpWidget` and `find`
* Try the simplest `Flutter Driver` test and output result in Flutter

**PS:** Use driver test must follow this command in Terminal, no shortcut in IDEA:

```bash
# open simulator before running the test
flutter drive --target=./test_driver/integration_widget.dart
# not this file: integration_widget_test.dart
```

***
## 23. Reactive Text Search And Image Picker

*Date: 2018-7-9*

![project_reactive_flutter](https://github.com/spkingr/flutter-demos/raw/master/project_reactive_flutter/project_reactive_flutter.gif)

Tips:

* Search text in Database with `filters` and `distinct` use `RxDart` library
* Select images with `ImagePicker` library and decode image with `Image` library
* Edit mode in text filed in forms
* I tried **Flutter Widget Test** in my project, it is sweet! :)

**PS:** The `Image` library works incorrectly and cannot compress my images, why?

***
## 22. App With Persistent Data 2

*Date: 2018-6-27*

![project_login_with_database](https://github.com/spkingr/flutter-demos/raw/master/project_login_with_database/project_login_with_database.gif)

Tips:

* Navigate to another page, and get the result value while the page pops, use `Future` and **fluro**
* Change the data class to more *helper* one, with the help of `Map` in Flutter
* Use `crypto` package to encrypt password to secure strings and save to database

**PS:** When I compile my app, an error encountered as below:

```bash
compiler message: lib/pages/page_home.dart:71:59: Error: A value of type '#lib1::User' can't be assigned to a variable of type '#lib2::User'.
compiler message: Try changing the type of the left hand side, or casting the right hand side to '#lib2::User'.
Finished with error: FormatException: Bad UTF-8 encoding 0x3f (at offset 306)
```

And at last I figured it out, in my `imports`:

```dart
//before:
import 'package:project_login_with_database/widgets/widget_login.dart';
import 'package:project_login_with_database/widgets/widget_register.dart';
import '../navigation.dart';
import '../widgets/widget_loader.dart';
//...

//after:
import '../widgets/widget_login.dart';
import '../widgets/widget_register.dart';
import '../navigation.dart';
import '../widgets/widget_loader.dart';
//...
```

***
## 21. Persistent Data Store

*Date: 2018-6-17*

![project_database_file](https://github.com/spkingr/flutter-demos/raw/master/project_database_file/project_database_file.gif)

Tips:

* Use Shared Preferences with `shared_preferences` package, SQLite database with `sqflite`, and files with `path_provider`
* Simple `factory` constructor in dart class, CURD operations with database, read and save data with shared preferences
* Try the **Terminal** with `adb shell` commands: `su root`, `sqlite3` ect

**PS:** use this command for root permissions in Flutter terminal: `su root`

***
## 20. Sliver Widgets

*Date: 2018-6-7*

![project_sliver_scroll_view](https://github.com/spkingr/flutter-demos/raw/master/project_sliver_scroll_view/project_sliver_scroll_view.gif)

Tips:

* Sliver widgets and parts in `CustomScrollView`: `BouncingScrollPhysics`, `SliverAppBar`, `SliverList` and `SliverGrid`
* Use `ScrollController` in scroll view to control the appearance of app bar
* Actions in app bar, use popup menus, and displays colors with shader

***
## 19. Firebase Basic (Without Test)

*Date: 2018-6-2*

Tips:

* Basic **Firebase** platform in Flutter, fetch data and save data via transition with `cloud_firestore` dependency
* `ValueKey` to identify list tiles, and build widget with `StreamBuilder`

**PS:** this app cannot work correctly in China for the blocking-network of Google service.

***
## 18. Backdrop

*Date: 2018-5-31*

![project_backdrop](https://github.com/spkingr/flutter-demos/raw/master/project_backdrop/project_backdrop.gif)

Tips:

* Use `AnimatedIcon` in `IconButton` with animation controller to build animated icon
* Build animated widget with `FadeTransition`, `PositionedTransition` and `ReverseAnimation`

**Still don't understand the value of top, bottom in `RelativeRect.fromLTRB`, while work with `RelativeRectTween`, though it behaviors all right.**

***
## 17. Rich Text Controls

*Date: 2018-5-25*

![project_text_with_backdrop](https://github.com/spkingr/flutter-demos/raw/master/project_text_with_backdrop/project_text_with_backdrop.gif)

Tips:

* Try a lot of new widgets: `OutlineButton`, `SafeArea`, `SingleChildScrollView`, `AnimatedIcon`, `PositionedTransition`, `IconButton`
* Build rich text controls with `Form`, `TextFormField`, and `InputDecoration` with `UnderlineInputBorder`, `OutlineInputBorder`
* Make simple **Backdrop** widget with `Stack` and animations, build tabs with custom `ShapeDecoration` indicators

Resource: [Flutter gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery)

***
## 16. Reveal Button

*Date: 2018-5-21*

![project_reveal_transition](https://github.com/spkingr/flutter-demos/raw/master/project_reveal_transition/project_reveal_transition.gif)

Tips:

* Create a reveal transition widget with `CustomPainter`, `CustomPaint`, get screen size with `MediaQuery`
* Override `deactivate` method to reset the state of widget
* Use **fluro** package to navigate pages in Flutter

Resource: [fluro](https://github.com/theyakka/fluro)

***
## 15. Stop Watch

*Date: 2018-5-17*

![project_stop_watch](https://github.com/spkingr/flutter-demos/raw/master/project_stop_watch/project_stop_watch.gif)

Tips:

* Build a stop watch in Dart with `StopWatch`, start, stop, and record
* Use `Timer` to trigger rendering in Flutter

***
## 14. Tabs in Tabs

*Date: 2018-5-11*

![project_inner_tabs](https://github.com/spkingr/flutter-demos/raw/master/project_inner_tabs/project_inner_tabs.gif)

Tips:

* Build tab bar views in another **Main Tab Bar** with separated `TabController`
* Add change listener to tab controller to switch tab content

***
## 13. Simple Drawer

*Date: 2018-5-10*

![project_drawer](https://github.com/spkingr/flutter-demos/raw/master/project_drawer/project_drawer.gif)

Tips:

* Use `Drawer` and `UserAccountsDrawerHeader`, `ListTile` to make material component drawer
* Exit app with simple dialog and the function `exit(0)` from library `dart:io`
* Now the code is fully switched to Dart 2.0

***
## 12. Animated Progress Button

*Date: 2018-5-8*

![project_loading_button](https://github.com/spkingr/flutter-demos/raw/master/project_loading_button/project_loading_button.gif)

Tips:

* Use `PhysicalModel` and other base components to make new widget
* Set width of widget to `double.infinity` and get the real measurement with context
* Make animated progress indicator with `CircularProgressIndicator` and `AlwaysStoppedAnimation<Color>`

Resource: [Flutter Progress Button Animation](http://myhexaville.com/2018/05/07/flutter-progress-button/)

***
## 11. Custom Painter

*Date: 2018-5-2*

![project_painter](https://github.com/spkingr/flutter-demos/raw/master/project_painter/project_painter.gif)

Tips:

* Use `Canvas` in custom painter in Flutter
* Use `Offset`, `Paint` and other graphics method to draw the component
* Animations in drawing canvas with `AnimationController`

***
## 10. Charts In Flutter

*Date: 2018-4-26*

![project_chart](https://github.com/spkingr/flutter-demos/raw/master/project_chart/project_chart.gif)

Tips:

* Import library, set the name to avoid the conflict for the same class name
* Use charts library in Flutter to build bar and pie chart

Resource: [charts gallery and code](https://google.github.io/charts/flutter/gallery.html)

***
## 9. The Carousel

*Date: 2018-4-25*

![project_carousel](https://github.com/spkingr/flutter-demos/raw/master/project_carousel/project_carousel.gif)

Tips:

* The `Expanded` in `Column` is used to restrain the width of the child
* Use image assets in Flutter, which are specified in the *pubspec.yaml* file

***
## 8. Simple Navigator

*Date: 2018-4-24*

![project_simple_navigator](https://github.com/spkingr/flutter-demos/raw/master/project_simple_navigator/project_simple_navigator.gif)

Tips:

* Navigator from home page to other pages with `Navigator` and `MaterialPageRoute`
* Show dialog and get the response value of dialog in Flutter with `SimpleDialog` and `SimpleDialogOption`
* Notice: You cannot directly change the state of controls in dialog, so I create a new class extends `StatefulWidget` as the dialog state widget

Resource: [Flutter - Radio Animation is not showing up on showDialog](https://stackoverflow.com/questions/46690765/flutter-radio-animation-is-not-showing-up-on-showdialog?rq=1)
[Document that showDialog creates now context and that setState on the calling widget therefore won't affect the dialog](https://github.com/flutter/flutter/issues/15194)

***
## 7. Friendly Chat

*Date: 2018-3-24*

![project_friendly_chat](https://github.com/spkingr/flutter-demos/raw/master/project_friendly_chat/project_friendly_chat.gif)

Tips:

* Use `Flexible` and `Expanded`, `SizeTransition` to build the layout and animations
* Use `TextField` and `TextEditingController` to deal with text inputs
* Divider, array list, default parameter in Flutter with Dart

Resource: [https://codelabs.developers.google.com/codelabs/flutter/](https://codelabs.developers.google.com/codelabs/flutter/)

***
## 6. Basic Animation

*Date: 2018-3-19*

![project_animation](https://github.com/spkingr/flutter-demos/raw/master/project_animation/project_animation.gif)

Tips:

* Use `AnimationController` and `CurvedAnimation`, `Tween` to start animations in Flutter
* Manually do animation with `addListener` and auto animate widgets with `addStatusListener`
* The widget `Opacity` used to control the appearance of child widget

***
## 5. List View With NetworkImage

*Date: 2018-3-16*

![project_network_list](https://github.com/spkingr/flutter-demos/raw/master/project_network_list/project_network_list.gif)

Tips:

* Use `ListView.builder` to build list view item with specified index
* Set `NetworkImage` as `backgroundImage` of `CircleAvatar` to display circular images
* Load data from network, and parse response content to json data

***
## 4. Simple List View

*Date: 2018-3-15*

![project_simple_list](https://github.com/spkingr/flutter-demos/raw/master/project_simple_list/project_simple_list.gif)

Tips:

* Import `dart:math` library to use `Random` function
* Basic `ListView` with the list of `ListTile` as children, and set controller: `ScrollController`
* Create `StatefulWidget` to response widget actions, and use `GlobalKey` to show/hide `SnackBar` 

***
## 3. Simple TabBar View

*Date: 2018-3-12*

![project_tabbar_view](https://github.com/spkingr/flutter-demos/raw/master/project_tabbar_view/project_tabbar_view.gif)

Tips:

* Use `DefaultTabController` as root with `TabBar` in the bottom of `AppBar` and `TabBarView` to build tabbed view
* Map the data list to get the widget list for the children of container
* Simple class in Dart with `final` properties

***
## 2. Basic Widgets In Flutter

*Date: 2018-3-9*

![project_basic_layout](https://github.com/spkingr/flutter-demos/raw/master/project_basic_layout/project_basic_layout.gif)

Tips:

* Many buttons, use Icons, styles, `Flutter Logo`, and so on
* Some layouts, menus, drop down items, and test the simple gesture detectors
* Text field, trigger the simple dialog, alert dialog and so on

***
## 1. Hello World Flutter

*Date: 2018-3-8*

![project_hello_world](https://github.com/spkingr/flutter-demos/raw/master/project_hello_world/project_hello_world.gif)

Tips:

* Basic material app themed with `ThemeData` use built-in `MaterialApp` widget 
* Use `Center` and `Padding`, `Column` to build layout
* Add `MaterialButton` control, set `onPressed` to change the state of widgets