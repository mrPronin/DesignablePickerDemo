//
//  RespondingButton.swift
//  DesignablePickerDemo
//
//  Created by Oleksandr Pronin on 25.09.17.
//  Copyright © 2017 adviqo AG. All rights reserved.
//

//Showing the iOS keyboard without a text input
//http://stephengroom.co.uk/uikit/showing-ios-keyboard-without-text-input/

import UIKit

protocol FirstResponderControlDelegate: class
{
    func firstResponderControl(_ control: FirstResponderControl, didReceiveText text: String)
    func firstResponderControlDidDeleteBackwards(_ control: FirstResponderControl)
    func firstResponderControlHasText(_ control: FirstResponderControl) -> Bool
}

class FirstResponderControl: UIControl, UIKeyInput
{
     weak var delegate: FirstResponderControlDelegate?
    
    override var canBecomeFirstResponder: Bool {
//        print("[\(type(of: self)) \(#function)]")
        return true
    }
    
    func insertText(_ text: String)
    {
        self.delegate?.firstResponderControl(self, didReceiveText: text)
    }
    
    func deleteBackward()
    {
        self.delegate?.firstResponderControlDidDeleteBackwards(self)
    }
    
    var hasText: Bool {
        return self.delegate?.firstResponderControlHasText(self) ?? false
    }
}
