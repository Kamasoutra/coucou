import AppKit
@main enum FullscreenVisibilityTests {
    static func main() {
        let central = CGRect(x: 0, y: 0, width: 2560, height: 1080)
        let right = CGRect(x: 2560, y: 0, width: 1920, height: 1080)
        let left = CGRect(x: -1080, y: -413, width: 1080, height: 1920)
        precondition(FullscreenVisibility.shouldHide(isFullscreen: true, screen: central, windows: [central]))
        precondition(!FullscreenVisibility.shouldHide(isFullscreen: false, screen: central, windows: [central]))
        precondition(!FullscreenVisibility.shouldHide(isFullscreen: true, screen: central, windows: [right]))
        precondition(FullscreenVisibility.shouldHide(isFullscreen: true, screen: right, windows: [right]))
        precondition(FullscreenVisibility.shouldHide(isFullscreen: true, screen: left, windows: [left]))
        precondition(!FullscreenVisibility.shouldHide(isFullscreen: true, screen: central, windows: [CGRect(x: 0, y: 24, width: 2560, height: 1056)]))
        precondition(!FullscreenVisibility.shouldHide(isFullscreen: true, screen: central, windows: []))
        precondition(!FullscreenVisibility.shouldHide(isFullscreen: true, screen: .zero, windows: [.zero]))
        precondition(FullscreenVisibility.shouldHide(isFullscreen: true, screen: central, windows: [central.offsetBy(dx: 1, dy: 1)]))
        precondition(!FullscreenVisibility.shouldHide(isFullscreen: true, screen: central, windows: [CGRect(x: 100, y: 100, width: 500, height: 300)]))
        print("Fullscreen visibility: 10 native-state, geometry and multi-display cases passed")
    }
}
