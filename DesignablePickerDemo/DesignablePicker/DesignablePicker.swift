//
//  DesignablePicker.swift
//  DesignablePickerDemo
//
//  Created by Oleksandr Pronin on 25.09.17.
//  Copyright © 2017 adviqo AG. All rights reserved.
//
/*
 Create an IBDesignable UIView subclass with code from an XIB file in Xcode 6
 http://supereasyapps.com/blog/2014/12/15/create-an-ibdesignable-uiview-subclass-with-code-from-an-xib-file-in-xcode-6
 
 Tutorial: Building Your Own Custom IBDesignable View: A UITextView With Placeholder
 https://digitalleaves.com/blog/2015/02/tutorial-building-your-own-custom-ibdesignable-view-a-uitextview-with-placeholder/
 
 iOS SDK: Creating a Custom Text Input View
 https://code.tutsplus.com/tutorials/ios-sdk-creating-a-custom-text-input-view--mobile-15661
*/

import UIKit

@objc protocol PickerInputDelegate: class, NSObjectProtocol
{
    func pickerInputDidCancel(_ picker: DesignablePicker)
    func pickerInput(_ picker: DesignablePicker, doneWithValue value: String, andIndex index:Int)
    @objc optional func pickerInput(_ picker: DesignablePicker, changedWithValue value: String, andIndex index:Int)
    @objc optional func pickerInput(_ picker: DesignablePicker, viewForRow row: Int, reusing view: UIView?) -> UIView
    @objc optional func pickerInput(_ picker: DesignablePicker, titleForRow row: Int) -> String
    @objc optional func pickerInputRowHeight(_ picker: DesignablePicker) -> CGFloat
}

@IBDesignable class DesignablePicker: UIView
{
    //MARK: Public
    
    public weak var delegate: PickerInputDelegate?
    public var data: [String]? {
        get {
            return self.pickerInputViewController.data
        }
        set {
            self.pickerInputViewController.data = newValue
        }
    }

    public var text:String? {
        set(newText) {
            self.setup(text: text, forTextLabel: self.textLabel, titleLabel: self.titleLabel, animated: false)
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
    
    public var pickerFont: UIFont? {
        get {
            return self.pickerInputViewController.font
        }
        set {
            self.pickerInputViewController.font = newValue
        }
    }

    public var pickerColor: UIColor? {
        get {
            return self.pickerInputViewController.tintColor
        }
        set {
            self.pickerInputViewController.tintColor = newValue
        }
    }
    
    public var toolbarBackgroundColor: UIColor? {
        get {
            return self.pickerInputViewController.toolbar.backgroundColor
        }
        set {
            self.pickerInputViewController.toolbar.backgroundColor = newValue
        }
    }
    
    public var activeStateColor: UIColor?
    
    public var cancelButton: UIBarButtonItem! {
        get {
            return self.pickerInputViewController.cancelButton
        }
    }
    
    public var doneButton: UIBarButtonItem! {
        get {
            return self.pickerInputViewController.doneButton
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            self.layer.borderColor = color.cgColor
            self.titleLabel.textColor = color
            self.pickerArrowImageView.imageColor = color
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
    @IBOutlet fileprivate weak var pickerArrowImageView: UIImageView!
    
    fileprivate var view: UIView!
    fileprivate var initialFrame:CGRect?
    fileprivate var titleFontScale:CGFloat = 1
    fileprivate let textLeadingSpace:CGFloat = 8
    fileprivate let titleAnimationDuration:TimeInterval = 0.3
    fileprivate let pickerInputViewController = PickerInputViewController(nibName: nil, bundle: nil)

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
        
        // use bounds not frame or it'll be offset
        //        self.view.frame = bounds
        
        // Make the view stretch with containing view
        //        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)

        addSubview(self.view)
        
        let views:[String:UIView] = ["contentView" : self.view]
        let metrics = ["offset" : 0]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat:"H:|-offset-[contentView]-offset-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat:"V:|-offset-[contentView]-offset-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: metrics, views: views))
        
    }
    
    fileprivate func setupNotifications()
    {
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil/*self.responderView*/, queue: nil)
        { notification in
            guard let activeStateColor = self.activeStateColor else {
                return
            }
            let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: {
                self.layer.borderColor = activeStateColor.cgColor
                self.titleLabel.textColor = activeStateColor
                self.pickerArrowImageView.imageColor = activeStateColor
            })
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil/*self.responderView*/, queue: nil)
        { notification in
            guard self.activeStateColor != nil else {
                return
            }
            let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
            UIView.animate(withDuration: TimeInterval(truncating: duration), animations: {
                self.layer.borderColor = self.color.cgColor
                self.titleLabel.textColor = self.color
                self.pickerArrowImageView.imageColor = self.color
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /*
    @objc func datePickerDidChangeValue(sender: UIDatePicker) {
        print("[\(type(of: self)) \(#function)] date: \(sender.date.description)")
    }
    */
    
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
        self.responderView.inputView = self.pickerInputViewController.view
        self.responderView.inputAccessoryView = self.pickerInputViewController.toolbar
        
        self.pickerFont = UIFont.systemFont(ofSize: 14)
        self.pickerInputViewController.delegate = self
        self.setupNotifications()
        
//        self.responderView.addTarget(self.responderView, action: #selector(becomeFirstResponder), for: .touchUpInside)
//        self.responderView.delegate = self
        
//        let datePicker = UIDatePicker(frame: .zero)
//        datePicker.addTarget(self, action: #selector(datePickerDidChangeValue(sender:)), for: .valueChanged)
//        self.responderView.inputView = datePicker
    }
}

extension DesignablePicker: PickerInputViewControllerDelegate
{
    func pickerInputViewControllerDidCancel(_ controller: PickerInputViewController)
    {
//        print("[\(type(of: self)) \(#function)]")
        self.responderView.resignFirstResponder()
        self.delegate?.pickerInputDidCancel(self)
    }
    
    func pickerInput(_ controller: PickerInputViewController, doneWithValue value: String, andIndex index:Int)
    {
//        print("[\(type(of: self)) \(#function)]")
        self.set(text: value, animated: true)
        self.responderView.resignFirstResponder()
        self.delegate?.pickerInput(self, doneWithValue: value, andIndex: index)
    }
    
    func pickerInput(_ controller: PickerInputViewController, changedWithValue value: String, andIndex index:Int)
    {
//        print("[\(type(of: self)) \(#function)]")
        self.delegate?.pickerInput?(self, changedWithValue: value, andIndex: index)
    }
    
    func pickerInput(_ controller: PickerInputViewController, viewForRow row: Int, reusing view: UIView?) -> UIView?
    {
//        print("[\(type(of: self)) \(#function)]")
        if let delegateView = self.delegate?.pickerInput?(self, viewForRow: row, reusing: view) {
            return delegateView
        }
        return nil
    }
    
    func pickerInput(_ controller: PickerInputViewController, titleForRow row: Int) -> String?
    {
//        print("[\(type(of: self)) \(#function)]")
        if let delegateTitle = self.delegate?.pickerInput?(self, titleForRow: row) {
            // try to get title from delegate
            return delegateTitle
        }
        return nil
    }
    
    func pickerInputRowHeight(_ controller: PickerInputViewController) -> CGFloat?
    {
//        print("[\(type(of: self)) \(#function)]")
        if let rowHeightForComponent = self.delegate?.pickerInputRowHeight?(self) {
            return rowHeightForComponent
        }
        return nil
    }
}
