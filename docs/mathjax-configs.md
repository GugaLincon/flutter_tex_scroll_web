To apply a custom MathJax configuration, create a file named `flutter_tex.js` in the root of your project's `assets` directory, your project structure should look like this:

```text
your_flutter_app/
├── assets/
│   └── flutter_tex.js
├── lib/
...
```
and make sure to add this into `pubspec.yaml` like:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/flutter_tex.js
```

An example `flutter_tex.js` file:

```js
window.MathJax = {
    tex: {
        inlineMath: [['$', '$'], ['\\(', '\\)']],
        displayMath: [['$$', '$$'], ['\\[', '\\]']],
    },
    svg: {
        fontCache: 'global'
    }
};
```

For more info please refer to the [MathJax Docs](https://docs.mathjax.org/en/latest/basic/mathjax.html)