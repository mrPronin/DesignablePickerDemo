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
    
    let salutation = "mr, mrs, ms"
    var dataSource: [String] = []
    let font = UIFont(name: FontName.HelveticaNeueLight.rawValue, size: FontStandardSize.h3.rawValue)!
    let titleFont = UIFont(name: FontName.HelveticaNeue.rawValue, size: FontStandardSize.h6.rawValue)!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.dataSource = salutation.components(separatedBy: ", ")
//        self.pickerView.text = "Initial text"
        self.pickerView.data = self.dataSource
        self.pickerView.delegate = self
        self.pickerView.pickerColor = UIColor(hex: "A36BC0")
        self.pickerView.pickerFont = font
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
