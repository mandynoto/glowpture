//
//  BorderView.swift
//  Glowpture
//
//  Created by Mandy Noto on 6/21/23.
//

import Cocoa

class BorderView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        NSColor.red.set()
        NSBezierPath.defaultLineWidth = 5
        NSBezierPath.stroke(bounds)
    }
}
