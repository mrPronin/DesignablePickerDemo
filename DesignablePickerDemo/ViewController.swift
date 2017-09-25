//
//  ViewController.swift
//  DesignablePickerDemo
//
//  Created by Oleksandr Pronin on 25.09.17.
//  Copyright © 2017 adviqo AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerView: DesignablePicker!
    
    let salutation = "mr, mrs, ms"
    var dataSource: [String] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.dataSource = salutation.components(separatedBy: ", ")

        self.pickerView.text = "Initial text"
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

