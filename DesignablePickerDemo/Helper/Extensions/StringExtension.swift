//
//  StringExtension.swift
//  DesignablePickerDemo
//
//  Created by Oleksandr Pronin on 22.08.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: from)
        return String(self[index...])
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
}

/*
 Handling empty optional strings in Swift
 https://medium.com/ios-os-x-development/handling-empty-optional-strings-in-swift-ba77ef627d74
 */
extension Optional where Wrapped == String
{
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}
