import AppKit
@main enum FullscreenVisibilityTests {
    static func main() {
        let central = CGRect(x: 0, y: 0, width: 2560, height: 1080)
        let right = CGRect(x: 2560, y: 0, width: 1920, height: 1080)
        let left = CGRect(x: -1080, y: -413, width: 1080, height: 1920)
        precondition(FullscreenVisibility.shouldHide(screen: central, windows: [central]))
        precondition(!FullscreenVisibility.shouldHide(screen: central, windows: [CGRect(x: 0, y: 0, width: 2560, height: 1020)]))
        precondition(!FullscreenVisibility.shouldHide(screen: central, windows: [right]))
        precondition(FullscreenVisibility.shouldHide(screen: right, windows: [right]))
        precondition(FullscreenVisibility.shouldHide(screen: left, windows: [left]))
        precondition(!FullscreenVisibility.shouldHide(screen: central, windows: [CGRect(x: 0, y: 24, width: 2560, height: 1056)]))
        precondition(!FullscreenVisibility.shouldHide(screen: central, windows: []))
        precondition(!FullscreenVisibility.shouldHide(screen: .zero, windows: [.zero]))
        precondition(FullscreenVisibility.shouldHide(screen: central, windows: [central.offsetBy(dx: 1, dy: 1)]))
        precondition(!FullscreenVisibility.shouldHide(screen: central, windows: [CGRect(x: 100, y: 100, width: 500, height: 300)]))
        let ordinary = CGRect(x: 100, y: 100, width: 500, height: 300)
        precondition(!FullscreenVisibility.shouldHide(screen: central, windows: [ordinary, central]))
        precondition(FullscreenVisibility.shouldHide(screen: central, windows: [right, central]))
        precondition(FullscreenVisibility.shouldHide(screen: central, windows: [central, ordinary]))
        precondition(!FullscreenVisibility.shouldHide(screen: central, windows: [central.offsetBy(dx: 3, dy: 0)]))
        print("Fullscreen visibility: 14 coverage, window-order and multi-display cases passed")
    }
}
