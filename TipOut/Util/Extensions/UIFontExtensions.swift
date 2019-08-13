//
//  UIFontExtensions.swift
//  TipOut
//
//  Created by Shayne Torres on 8/11/19.
//  Copyright © 2019 shayneptorres. All rights reserved.
//

import UIKit

fileprivate var appBaseFont = "Avenir"
fileprivate var appBaseBoldFont = "Avenir-Black"

enum AppFont {
    case small
    case medium
    case large
    case xLarge
    case header
    
    static func normal(font: AppFont) -> UIFont? {
        return font.font
    }
    
    static func bold(font: AppFont) -> UIFont? {
        return font.bold
    }
    
    var font: UIFont? {
        switch self {
        case .small:
            return UIFont(name: appBaseFont, size: 14)
        case .medium:
            return UIFont(name: appBaseFont, size: 18)
        case .large:
            return UIFont(name: appBaseFont, size: 24)
        case .xLarge:
            return UIFont(name: appBaseFont, size: 36)
        case .header:
            return UIFont(name: appBaseFont, size: 42)
        }
    }
    
    var bold: UIFont? {
        switch self {
        case .small:
            return UIFont(name: appBaseBoldFont, size: 12)
        case .medium:
            return UIFont(name: appBaseBoldFont, size: 18)
        case .large:
            return UIFont(name: appBaseBoldFont, size: 24)
        case .xLarge:
            return UIFont(name: appBaseBoldFont, size: 36)
        case .header:
            return UIFont(name: appBaseBoldFont, size: 42)
        }
    }
}

extension UIFont {
//    static func appFont(type: AppFont) -> UIFont? {
//        return type.font
//    }
}
