//
//  PickerInputViewController.swift
//  DesignablePickerDemo
//
//  Created by Oleksandr Pronin on 25.09.17.
//  Copyright © 2017 adviqo AG. All rights reserved.
//

import UIKit

protocol PickerInputViewControllerDelegate: class, NSObjectProtocol
{
    func pickerInputViewControllerDidCancel(_ controller: PickerInputViewController)
    func pickerInput(_ controller: PickerInputViewController, doneWithValue value: String, andIndex index:Int)
    func pickerInput(_ controller: PickerInputViewController, changedWithValue value: String, andIndex index:Int)
    func pickerInput(_ controller: PickerInputViewController, viewForRow row: Int, reusing view: UIView?) -> UIView?
    func pickerInput(_ controller: PickerInputViewController, titleForRow row: Int) -> String?
    func pickerInputRowHeight(_ controller: PickerInputViewController) -> CGFloat?
}

class PickerInputViewController: UIViewController
{
    // MARK: - Public
    
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    public weak var delegate: PickerInputViewControllerDelegate?
    
    var data: [String]?
    
    var font: UIFont?
    var tintColor: UIColor? {
        didSet {
            self.cancelButton.tintColor = tintColor
            self.doneButton.tintColor = tintColor
            self.dividerView.backgroundColor = tintColor
        }
    }
    var backgroundColor: UIColor? {
        didSet {
            self.picker.backgroundColor = backgroundColor
            self.toolbar.backgroundColor = backgroundColor
        }
    }
    
    // TODO: need to implement
    var selectedIndex: Int = 0

    // MARK: - Private properties
    
    @IBOutlet fileprivate weak var picker: UIPickerView!
    @IBOutlet fileprivate weak var dividerView: UIView!
    fileprivate let rowHeightForComponent: CGFloat = 44.0

    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupViewsOnLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction fileprivate func cancelAction(_ sender: UIBarButtonItem)
    {
        self.delegate?.pickerInputViewControllerDidCancel(self)
    }
    
    @IBAction fileprivate func doneAction(_ sender: UIBarButtonItem)
    {
        guard
            let delegate = self.delegate,
            let data = self.data,
            data.count > 0
        else
        {
            return
        }
        let index = self.picker.selectedRow(inComponent: 0)
        let value = data[index]
        delegate.pickerInput(self, doneWithValue: value, andIndex: index)
    }
    
    // MARK: - Private
    
    fileprivate func setupViewsOnLoad()
    {
        #if !TARGET_INTERFACE_BUILDER
            self.picker.dataSource = self
            self.picker.delegate = self
        #endif
    }
}

extension PickerInputViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        guard let data = self.data else {
            return 0
        }
        return data.count
    }
}

extension PickerInputViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        if let rowHeightForComponent = self.delegate?.pickerInputRowHeight(self) {
            // try to get height from delegate
            return rowHeightForComponent
        }
        return self.rowHeightForComponent
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        if let delegateView = self.delegate?.pickerInput(self, viewForRow: row, reusing: view) {
            return delegateView
        }
        
        let label: UILabel
        
        if view == nil || !(view is UILabel) {
            let frame = CGRect(
                x: 0,
                y: 0,
                width: self.picker.rowSize(forComponent: component).width,
                height: self.picker.rowSize(forComponent: component).height
            )
            label = UILabel(frame: frame)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            
            let title: String
            if let delegateTitle = self.delegate?.pickerInput(self, titleForRow: row) {
                // try to get title from delegate
                title = delegateTitle
            } else {
                title = self.data![row]
            }
            label.text = title
            if let font = self.font {
                label.font = font
            }
        } else {
            label = view as! UILabel
        }
        
        if let color = self.tintColor {
            label.textColor = color
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        guard
            let delegate = self.delegate,
            let data = self.data
        else
        {
            return
        }
        let value = data[row]
        delegate.pickerInput(self, changedWithValue: value, andIndex: row)
    }
}
