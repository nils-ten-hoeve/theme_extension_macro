import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:theme_extension_macro/macro/theme_extension_macro.dart';

main() => runApp(const MyApp());

ColorScheme myColorScheme(Brightness brightness) =>
    ColorScheme.fromSeed(seedColor: Colors.blue, brightness: brightness);

ThemeData myTheme(ColorScheme colorScheme) {
  var baseTheme = ThemeData(colorScheme: colorScheme);
  var extensions = [MyComponentTheme.ofBaseTheme(baseTheme)];
  return baseTheme.copyWith(extensions: extensions);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) => MaterialApp(
        theme: myTheme(myColorScheme(Brightness.light)),
        darkTheme: myTheme(myColorScheme(Brightness.dark)),
        home: const Scaffold(
          body: Column(
            children: [
              MyComponent(),
              MyComponent(
                  style: MyComponentStyle(
                      surface: Colors.green, borderRadius: 20)),
            ],
          ),
        ),
      );
}

class MyComponent extends StatelessWidget {
  final MyComponentStyle style;

  const MyComponent({super.key, this.style = const MyComponentStyle()});

  @override
  Widget build(BuildContext context) {
    var theme = MyComponentTheme.of(context, style);
    return SizedBox(
      width: 50,
      height: 50,
      child: Container(
          decoration: BoxDecoration(
        color: theme.surface,
        border: theme.border,
        borderRadius: BorderRadius.all(Radius.circular(theme.borderRadius)),
      )),
    );
  }
}

///augmented by macro
class MyComponentStyle {
  final Color? surface;
  final Border? border;
  final double? borderRadius;

  const MyComponentStyle({
    this.surface,
    this.border,
    this.borderRadius,
  });
}

@ThemeExtensionMacro()
class MyComponentTheme extends ThemeExtension<MyComponentTheme> {
  final Color surface;
  final Border border;
  final double borderRadius;

  MyComponentTheme.ofBaseTheme(ThemeData baseTheme)
      : this(
          surface: baseTheme.colorScheme.error,
          border: Border.all(color: baseTheme.colorScheme.onSurface),
          borderRadius: 10,
        );

// augmented by macro
  @override
  MyComponentTheme lerp(
      covariant ThemeExtension<MyComponentTheme>? other, double t) {
    if (other is! MyComponentTheme) {
      return this;
    }
    return MyComponentTheme(
      surface: Color.lerp(surface, other.surface, t)!,
      border: Border.lerp(border, other.border, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
    );
  }

// augmented by macro
  MyComponentTheme copyWithStyle(MyComponentStyle? style) => MyComponentTheme(
        surface: style?.surface ?? surface,
        border: style?.border ?? border,
        borderRadius: style?.borderRadius ?? borderRadius,
      );

// augmented by macro
  static MyComponentTheme of(BuildContext context, [MyComponentStyle? style]) =>
      Theme.of(context).extension<MyComponentTheme>()!.copyWithStyle(style);
}
