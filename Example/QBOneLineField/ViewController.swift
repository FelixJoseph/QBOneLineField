//
//  ViewController.swift
//  QBOneLineField
//
//  Created by Felix on 12/12/2016.
//  Copyright (c) 2016 Felix. All rights reserved.
//

import UIKit
import QBOneLineField

class ViewController: UIViewController {

    var backgroundColor: UIColor? = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
    @IBOutlet weak var oneLineField: QBOneLineField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        var fieldType = FieldType(fieldName: "Name", ofContentType: ContentType.Username)
        oneLineField.fieldArray.append(fieldType)
        fieldType.name = "Email"
        fieldType.contentType = ContentType.Email
        oneLineField.fieldArray.append(fieldType)
        fieldType.name = "Password"
        fieldType.contentType = ContentType.Password
        oneLineField.fieldArray.append(fieldType)
        fieldType.name = "Confirm Password"
        fieldType.contentType = ContentType.ConfirmPassword
        oneLineField.fieldArray.append(fieldType)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

