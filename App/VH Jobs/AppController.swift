//
//  ViewController.swift
//  VH Jobs
//
//  Created by tolu oluwagbemi on 2/16/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit

class AppController: UIViewController {

    var delegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        delegate = UIApplication.shared.delegate as! AppDelegate
        view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func label(_ text: String, _ color: UIColor?, _ font: UIFont?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        if color != nil {
            label.textColor = color!
        }
        if font != nil {
            label.font = font
        }
        return label
    }
    
    func medium_label(_ text: String, _ color: UIColor?) -> UILabel {
        let label = self.label(text, color, UIFont.systemFont(ofSize: 14))
        return label
    }
    
    func small_label(_ text: String, _ color: UIColor?) -> UILabel {
        let label = self.label(text, color, UIFont.systemFont(ofSize: 12))
        return label
    }
    
    func xsmall_label(_ text: String, _ color: UIColor?) -> UILabel {
        let label = self.label(text, color, UIFont.systemFont(ofSize: 8))
        return label
    }
    
    func normal_label(_ text: String, _ color: UIColor?) -> UILabel {
        let label = self.label(text, color, UIFont.systemFont(ofSize: 17))
        return label
    }
    
    func large_label(_ text: String, _ color: UIColor?) -> UILabel {
        let label = self.label(text, color, UIFont.boldSystemFont(ofSize: 22))
        return label
    }
    
    func colorView(_ color: UIColor) -> UIView {
        let v = UIView()
        v.backgroundColor = color
        return v
    }
    
    func colorRoundButton(_ text: String, _ color: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 20
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
    }
}


