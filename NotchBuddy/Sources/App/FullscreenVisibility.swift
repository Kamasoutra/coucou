import AppKit

enum FullscreenVisibility {
    @MainActor static func shouldHide(on screen: NSScreen?) -> Bool {
        guard NSApp.currentSystemPresentationOptions.contains(.fullScreen),
              let screen,
              let number = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber,
              let app = NSWorkspace.shared.frontmostApplication,
              let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]]
        else { return false }
        let bounds = windows.compactMap { window -> CGRect? in
            guard (window[kCGWindowOwnerPID as String] as? NSNumber)?.int32Value == app.processIdentifier,
                  (window[kCGWindowLayer as String] as? NSNumber)?.intValue == 0,
                  (window[kCGWindowAlpha as String] as? NSNumber)?.doubleValue != 0,
                  let rectangle = window[kCGWindowBounds as String] as? [String: Any]
            else { return nil }
            return CGRect(dictionaryRepresentation: rectangle as CFDictionary)
        }
        return shouldHide(isFullscreen: true, screen: CGDisplayBounds(number.uint32Value), windows: bounds)
    }

    /// Both rectangles use global Quartz coordinates. The native fullscreen flag
    /// prevents a maximized ordinary window from being mistaken for fullscreen.
    static func shouldHide(isFullscreen: Bool, screen: CGRect, windows: [CGRect]) -> Bool {
        guard isFullscreen && !screen.isEmpty else { return false }
        return windows.contains { window in
            abs(window.minX - screen.minX) <= 2 && abs(window.minY - screen.minY) <= 2
                && abs(window.width - screen.width) <= 2 && abs(window.height - screen.height) <= 2
        }
    }
}
