//
//  DesignablePicker.swift
//  DesignablePickerDemo
//
//  Created by Oleksandr Pronin on 25.09.17.
//  Copyright © 2017 adviqo AG. All rights reserved.
//

import UIKit

@IBDesignable class DesignablePicker: UIView
{
    //MARK: Public API
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            self.layer.borderColor = color.cgColor
            self.titleLabel.textColor = color
            setNeedsLayout()
        }
    }
    
    @IBInspectable var background: UIColor? {
        get {
            return self.view.backgroundColor
        }
        set(newColor) {
            self.view.backgroundColor = newColor
            setNeedsLayout()
        }
    }

    @IBInspectable var textColor: UIColor? {
        set(newColor) {
            self.textLabel.textColor = newColor
            setNeedsLayout()
        }
        get {
            return self.textLabel.textColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            setNeedsLayout()
        }
    }
    
    @IBInspectable var title: String? {
        set(newTitle) {
            self.titleLabel.text = newTitle
        }
        get {
            return self.titleLabel.text
        }
    }

    public var text:String? {
        set(newText) {
//            self.textLabel.text = newText
            self.setup(text: text, forTextLabel: self.textLabel, titleLabel: self.titleLabel, animated: false)
//            setNeedsLayout()
        }
        get {
            return self.textLabel.text
        }
    }
    
    public func set(text perhapsText:String?, animated:Bool = false)
    {
        self.setup(text: perhapsText, forTextLabel: self.textLabel, titleLabel: self.titleLabel, animated: animated)
    }

    public var font = UIFont.systemFont(ofSize: 18) {
        didSet {
            self.titleFontScale = titleFont.pointSize / font.pointSize
        }
    }
    public var titleFont = UIFont.systemFont(ofSize: 10) {
        didSet {
            self.titleFontScale = titleFont.pointSize / font.pointSize
        }
    }

    override init(frame: CGRect)
    {
//        print("[\(type(of: self)) \(#function)]")
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        self.xibSetup()
        
        self.setupViewsOnLoad()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
//        print("[\(type(of: self)) \(#function)]")
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        self.xibSetup()
        
        self.setupViewsOnLoad()
    }
    
    // MARK: - Private
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var textLabel: UILabel!
    @IBOutlet fileprivate weak var responderView: FirstResponderControl!
    
    fileprivate var view: UIView!
    fileprivate var initialFrame:CGRect?
    fileprivate var titleFontScale:CGFloat = 1
    fileprivate let textLeadingSpace:CGFloat = 8
    fileprivate let titleAnimationDuration:TimeInterval = 0.3
    
    fileprivate func setup(text perhapsText:String?, forTextLabel textLabel:UILabel, titleLabel:UILabel, animated:Bool, selected forceSelected:Bool = false)
    {
        guard let titleSuperView = titleLabel.superview else {
            return
        }
        
        var selected = true
        
        if perhapsText == nil {
            selected = false
        }
        if
            let newValue = perhapsText,
            newValue.isEmpty
        {
            selected = false
        }
        
        let beforeAnimationClosure:() -> ()
        let animationClosure:() -> ()
        let afterAnimationClosure:() -> ()
        
        if selected {
            beforeAnimationClosure = {
                textLabel.text = perhapsText
                titleSuperView.layoutIfNeeded()
                if self.initialFrame == nil {
                    self.initialFrame = titleLabel.frame;
                }
                textLabel.isHidden = false
                textLabel.alpha = 0
            }
            animationClosure = {
                titleLabel.transform = CGAffineTransform(scaleX: self.titleFontScale, y: self.titleFontScale)
                titleLabel.frame.origin.x = self.textLeadingSpace
                titleLabel.frame.origin.y = self.textLeadingSpace
                textLabel.alpha = 1
                textLabel.frame.origin.y = self.textLeadingSpace + titleLabel.frame.size.height
            }
            afterAnimationClosure = {
            }
        } else {
            beforeAnimationClosure = {
                
            }
            animationClosure = {
                titleLabel.transform = .identity
                if let initialFrame = self.initialFrame {
                    titleLabel.frame = initialFrame
                    self.initialFrame = nil
                }
                textLabel.alpha = 0
            }
            afterAnimationClosure = {
                textLabel.isHidden = true
            }
        }
        if animated {
            beforeAnimationClosure()
            UIView.animate(withDuration: self.titleAnimationDuration, animations: {
                animationClosure()
            }, completion: { _ in
                afterAnimationClosure()
            })
            return
        }
        beforeAnimationClosure()
        DispatchQueue.main.async {
            animationClosure()
            afterAnimationClosure()
        }
    }
    
    fileprivate func xibSetup()
    {
        let className = String.className(type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: className, bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(self.view)
        
        let views:[String:UIView] = ["contentView" : self.view]
        let metrics = ["offset" : 0]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat:"H:|-offset-[contentView]-offset-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat:"V:|-offset-[contentView]-offset-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
        
        // use bounds not frame or it'll be offset
//        self.view.frame = bounds
        
        // Make the view stretch with containing view
//        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
    }
    
    fileprivate func setupViewsOnLoad()
    {
        // Default falues
        self.color = UIColor.lightGray
        self.background = UIColor.white
        self.font = UIFont.systemFont(ofSize: 18)
        self.titleFont = UIFont.systemFont(ofSize: 10)
        self.titleLabel.font = self.font
        self.textLabel.font = self.font
        self.titleFontScale = self.titleFont.pointSize / self.font.pointSize
        self.initialFrame = nil
        self.responderView.addTarget(self.responderView, action: #selector(becomeFirstResponder), for: .touchUpInside)
        self.responderView.delegate = self
    }
}

extension DesignablePicker: FirstResponderControlDelegate
{
    func firstResponderControlHasText(_ control: FirstResponderControl) -> Bool
    {
//        print("[\(type(of: self)) \(#function)]")
        guard let text = self.textLabel.text else {
            return false
        }
        if text.isEmpty {
            return false
        }
        return true
    }
    
    func firstResponderControlDidDeleteBackwards(_ control: FirstResponderControl)
    {
//        print("[\(type(of: self)) \(#function)]")
    }
    
    func firstResponderControl(_ control: FirstResponderControl, didReceiveText text: String)
    {
//        print("[\(type(of: self)) \(#function)] text: \(text)")
    }
}
