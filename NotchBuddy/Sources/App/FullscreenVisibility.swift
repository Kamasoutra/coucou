import AppKit

enum FullscreenVisibility {
    @MainActor static func shouldHide(on screen: NSScreen?) -> Bool {
        guard let screen,
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
        return shouldHide(screen: CGDisplayBounds(number.uint32Value), windows: bounds)
    }

    /// Both rectangles use global Quartz coordinates. A normally maximized
    /// window occupies the visible frame, leaving room for the menu bar or Dock.
    /// Screen-filling borderless windows also qualify; this does not identify Spaces.
    static func shouldHide(screen: CGRect, windows: [CGRect]) -> Bool {
        guard !screen.isEmpty else { return false }
        return windows.contains { window in
            abs(window.minX - screen.minX) <= 2 && abs(window.minY - screen.minY) <= 2
                && abs(window.width - screen.width) <= 2 && abs(window.height - screen.height) <= 2
        }
    }
}
