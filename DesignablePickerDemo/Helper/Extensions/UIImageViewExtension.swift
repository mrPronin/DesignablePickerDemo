//
//  UIImageViewExtension.swift
//  DesignablePickerDemo
//
//  Created by Aleksandr Pronin on 2/1/17.
//  Copyright © 2017 Aleksandr Pronin. All rights reserved.
//

import UIKit

extension UIImageView {
    var imageColor: UIColor? {
        get {
            return self.tintColor
        }
        set {
            let origImage = self.image
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            self.image = tintedImage
            self.tintColor = newValue
        }
    }
}
