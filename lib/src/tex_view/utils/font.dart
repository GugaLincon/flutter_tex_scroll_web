/// Represents a custom font to be used within a [TeXView].
///
/// This class is used to declare a font family and its source URL, which is
/// then used by the rendering engine to load and apply the font.
class TeXViewFont {
  /// The name of the font family, which will be used in CSS `font-family`.
  final String fontFamily;

  /// The path or URL to the font file (e.g., 'fonts/MyCustomFont.ttf').
  ///
  /// This should be a path accessible from your `assets`.
  final String src;

  /// Creates a definition for a custom font.
  const TeXViewFont({required this.fontFamily, required this.src});

  /// Converts this object into a JSON format suitable for the rendering engine.
  Map<String, String> toJson() => {
        'font_family': fontFamily,
        'src': src,
      };
}
