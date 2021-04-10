//
//  ResizeImageExtension.swift
//  CloudClip
//
//  Created by Shravan Prasanth on 4/6/21.
//

import Foundation
import Cocoa

extension NSImage {
func resizeImage(width: CGFloat, _ height: CGFloat, owidth:CGFloat,oheight:CGFloat) -> NSImage {
let theWidthScaleFactor = width / owidth
let theHeightScaleFactor = height / oheight
let theScaleFactor = min(theWidthScaleFactor, theHeightScaleFactor)
let theWidth = width * theScaleFactor
let theHeight = height * theScaleFactor
let img = NSImage(size: CGSize(width:theWidth, height:theHeight))
          
img.lockFocus()
    let ctx = NSGraphicsContext.current
            ctx?.imageInterpolation = .high
            self.draw(in: NSMakeRect(0, 0, width, height), from: NSMakeRect(0, 0, size.width, size.height), operation: .copy, fraction: 1)
            img.unlockFocus()
          
            return img
        }
    }


