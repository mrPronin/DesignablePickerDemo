//
//  ViewController.swift
//  DesignablePickerDemo
//
//  Created by Oleksandr Pronin on 25.09.17.
//  Copyright © 2017 adviqo AG. All rights reserved.
//

import UIKit

enum FontName: String {
    case HelveticaNeue              = "HelveticaNeue"
    case HelveticaNeueBold          = "HelveticaNeue-Bold"
    case HelveticaNeueLight         = "HelveticaNeue-Light"
    case HelveticaNeueBoldItalic    = "HelveticaNeue-BoldItalic"
    case HelveticaNeueItalic        = "HelveticaNeue-Italic"
}

enum FontStandardSize: CGFloat {
    case h1 = 24.0
    case h2 = 20.0
    case h3 = 18.0
    case h4 = 14.0
    case h5 = 12.0
    case h6 = 10.0
    case h7 = 8.0
}

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerView: DesignablePicker!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let font = UIFont(name: FontName.HelveticaNeueLight.rawValue, size: FontStandardSize.h3.rawValue)!
        let titleFont = UIFont(name: FontName.HelveticaNeue.rawValue, size: FontStandardSize.h6.rawValue)!
        let pickerFont = UIFont(name: FontName.HelveticaNeue.rawValue, size: FontStandardSize.h3.rawValue)!

        let backgroundColor = UIColor(hex: "FAFAFA")
        self.view.backgroundColor = backgroundColor

        let backgroundDarkColor = UIColor(hex: "E2EBF0")
        let color = UIColor(hex: "A0A0A0")
        let mainColor = UIColor(hex: "5A99BB")
        let textColor = UIColor(hex: "333333")

        self.pickerView.data = "mr, mrs, ms".components(separatedBy: ", ")
        self.pickerView.delegate = self
        self.pickerView.color = color
        self.pickerView.font = font
        self.pickerView.titleFont = titleFont
        self.pickerView.pickerColor = mainColor
        self.pickerView.pickerFont = pickerFont
        self.pickerView.background = UIColor.white
        self.pickerView.textColor = textColor
        self.pickerView.toolbarBackgroundColor = backgroundDarkColor
        self.pickerView.activeStateColor = mainColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    @IBAction func setSpaceTextAction(_ sender: UIButton)
    {
        self.pickerView.set(text: " ", animated: true)
    }
    
    @IBAction func setNilAction(_ sender: UIButton)
    {
        self.pickerView.set(text: nil, animated: true)
    }
    
    @IBAction func setTextAction(_ sender: UIButton)
    {
        self.pickerView.set(text: "Bla-bla-bla", animated: true)
    }
    
    @IBAction func setEmptyTextAction(_ sender: UIButton)
    {
        self.pickerView.set(text: "", animated: true)
    }
}

extension ViewController: PickerInputDelegate
{
    func pickerInputDidCancel(_ picker: DesignablePicker)
    {
//        print("[\(type(of: self)) \(#function)]")
    }
    
    func pickerInput(_ picker: DesignablePicker, doneWithValue value: String, andIndex index: Int)
    {
//        print("[\(type(of: self)) \(#function)] value: \(value) index: \(index)")
    }
}
