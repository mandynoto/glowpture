//
//  HighlightWindow.swift
//  Glowpture
//
//  Created by Mandy Noto on 6/21/23.
//

import Cocoa

class HighlightWindow: NSWindow {
    init(contentRect: NSRect) {
        super.init(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false)
        self.backgroundColor = NSColor.clear
        self.isOpaque = false
        self.level = .floating
        self.ignoresMouseEvents = true
    }

    override var canBecomeKey: Bool {
        return false
    }

    override var canBecomeMain: Bool {
        return false
    }
}
