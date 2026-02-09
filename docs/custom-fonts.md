To use custom fonts for `TeXView`, create a create a file named `flutter_tex.css` in the root of your project's `assets` directory, this style file should define your custom fonts. Your project structure should look like this:

```text
your_flutter_app/
├── assets/
│   ├── fonts/
│   └── flutter_tex.css
├── lib/
...
```

and make sure to add this into `pubspec.yaml` like:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/flutter_tex.css
```

An example `flutter_tex.css` file defining a custom font:

```css
@font-face {
    font-family: 'army';
    src: url("fonts/Army.ttf");
}
```
Then you can use this custom font in your `TeXViewStyle` like this:

```dart
TeXViewStyle(
  fontStyle: TeXViewFontStyle(
      fontFamily: 'army'),
)
```