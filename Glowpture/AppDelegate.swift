import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    static func getActiveWindow() -> CGRect? {
        // Get a list of all windows.
        let windowListInfo = (CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[String: Any]]) ?? []
            
        for windowInfo in windowListInfo {
            let windowName = windowInfo[kCGWindowName as String] as? String
            let windowNumber = windowInfo[kCGWindowNumber as String] as? Int
            var bounds = CGRect(dictionaryRepresentation: windowInfo[kCGWindowBounds as String] as! CFDictionary)
            
            // Convert from Core Graphics' coordinate system to macOS's coordinate system.
            if let bound = bounds {
                let screenHeight = NSScreen.main?.frame.height ?? 0
                bounds = CGRect(x: bound.minX, y: screenHeight - bound.minY - bound.height, width: bound.width, height: bound.height)
            }
            
            // If the window is not minimized, it's the window we want.
            if windowInfo[kCGWindowLayer as String] as? Int == 0 && windowName != nil {
                return bounds
            }
        }
        
        return nil
    }
    
    var highlightWindow: HighlightWindow?
    var mouseEventMonitor: Any?
    var appEventMonitor: Any?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.activate(ignoringOtherApps: true)

        // Create a timer that updates the highlight every 0.1 seconds.
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateHighlight()
        }

        // Monitor mouse events to update the highlight when the user moves or resizes a window.
        mouseEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged, .rightMouseDragged]) { _ in
            self.updateHighlight()
        }

        // Monitor application activation and deactivation events to update the highlight when the user switches applications.
        let center = NSWorkspace.shared.notificationCenter
        appEventMonitor = center.addObserver(forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: nil) { _ in
            self.updateHighlight()
        }
        appEventMonitor = center.addObserver(forName: NSWorkspace.didDeactivateApplicationNotification, object: nil, queue: nil) { _ in
            self.updateHighlight()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationWillResignActive(_ aNotification: Notification) {
        // Hide the highlight when our application loses focus.
        highlightWindow = nil
    }

    func updateHighlight() {
        if let bounds = AppDelegate.getActiveWindow() {
            print("Active window detected with bounds: \(bounds)")
            if highlightWindow == nil {
                highlightWindow = HighlightWindow(contentRect: bounds)
                highlightWindow?.contentView = BorderView()  // This references BorderView.swift
            } else {
                highlightWindow?.setFrame(bounds, display: true)
            }
            highlightWindow?.orderFrontRegardless()
        } else {
            print("No active window detected")
            highlightWindow = nil
        }
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
