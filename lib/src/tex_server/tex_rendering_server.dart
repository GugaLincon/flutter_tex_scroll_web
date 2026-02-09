/// A conditional export for the TeX rendering server.
///
/// This file exports `tex_rendering_server_mobile.dart` by default and
/// `tex_rendering_server_web.dart` when `dart.library.html` is available (i.e., on the web).
/// This allows for platform-specific implementations of the [TeXRenderingServer].
library;

export 'tex_rendering_server_mobile.dart'
    if (dart.library.html) 'tex_rendering_server_web.dart'
    show TeXRenderingServer;
