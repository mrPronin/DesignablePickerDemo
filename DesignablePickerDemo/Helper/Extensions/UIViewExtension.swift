//
//  UIViewExtension.swift
//  AdviqoTextFieldTest
//
//  Created by Oleksandr Pronin on 22.08.17.
//  Copyright © 2017 Oleksandr Pronin. All rights reserved.
//

import UIKit

extension UIView
{
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}
