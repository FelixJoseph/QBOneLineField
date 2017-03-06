//
//  QBOneLineField.swift
//  Pods
//
//  Created by Felix Joseph on 12/12/16.
//
//

import UIKit

public struct FieldType {
    
    public var name : String?
    public var contentType : Int?
    
    public init(fieldName: String) {
        name = fieldName
        contentType = ContentType.Username
    }
    
    public init(fieldName: String , ofContentType: Int) {
        name = fieldName
        contentType = ofContentType
    }
    
}

public enum ContentType {
    
    public static let Username = 0
    public static let Email = 1
    public static let Password = 2
    public static let ConfirmPassword = 3
}
private enum Constant {
    
    static let fontsize: CGFloat = 14
    static let defaultOffset = 10
    static let defaultDuration = 0.5
    static let semiTransparentAlpha: CGFloat = 0.5
    static let defaultDelay = 0.3
    static let sighnUpPlaceholderString = "Sign Up"
    static let Zero: CGFloat = 0
    static let One: CGFloat = 1
    static let defaultCornerRadius: CGFloat = 5
    static let emptyString = ""
}

public class QBOneLineField: UITextField {
    
    var label = UILabel()
    let button = UIButton()
    var isFloatingLabelActive : Bool = false
    public var fieldArray = [FieldType]()
    var fieldIndex = 0
    var currentIndex = 0
    let textFieldleftView = UIView()
    let leftImageView = UIImageView()
    let rightNextButton = UIButton()
    var result = [String: String]()
    public var userImage = #imageLiteral(resourceName: "User")
    public var passwordImage = #imageLiteral(resourceName: "PasswordIcon")
    public var emailIcon = #imageLiteral(resourceName: "MailIcon")
    public var confirmPassworIcon = #imageLiteral(resourceName: "ConfirmPassword")
    
    var textFieldBackgroundColor: UIColor? = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialiseSubscribeField()
    }
    
    required override public init(frame: CGRect) {
        
        super.init(frame: frame)
        self.initialiseSubscribeField()
    }
    
    
    override public func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        self.initialiseSubscribeField()
    }
    
    func initialiseSubscribeField(){
        
        //Set the properties of Text field.
        self.backgroundColor = textFieldBackgroundColor
        self.font = UIFont.systemFont(ofSize: Constant.fontsize)
        self.textColor = UIColor.white
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.tintColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        //Initialize and set the properties of the floating label.
        label = UILabel(frame: CGRect(x: Constant.Zero, y: Constant.Zero, width: (self.bounds.width), height: (self.bounds.height)))
        label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        label.font = UIFont.systemFont(ofSize: Constant.fontsize)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = Constant.sighnUpPlaceholderString
        self.addSubview(label)
    }
    
    func buttonAction(sender: UIButton!) {
        if self.text != Constant.emptyString {
            if self.fieldArray[self.fieldIndex].contentType == ContentType.Email {
                if (isValidEmail(testStr: self.text!)) {
                    self.result[self.fieldArray[fieldIndex].name!] = self.text
                    self.changeTextFieldType()
                }
                else {
                    self.shake()
                }
            } else {
                if self.fieldArray[self.fieldIndex].contentType == ContentType.ConfirmPassword {
                    if self.result["Password"] != self.text {
                        self.shake()
                    } else {
                        self.result[self.fieldArray[fieldIndex].name!] = self.text
                        self.changeTextFieldType()
                    }
                } else {
                    self.result[self.fieldArray[fieldIndex].name!] = self.text
                    self.changeTextFieldType()
                }
            }
        } else {
            self.shake()
        }
    }
    
    func changeTextFieldType() {
        
        self.fieldIndex+=1
        let delay = Int(0.5 * Double(1000))
        if self.fieldIndex < self.fieldArray.count {
            
            UIView.animate(withDuration: Constant.defaultDuration*3, delay: Constant.defaultDelay, options: .curveLinear, animations: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay) ) {
                    self.text = ""
                    if self.fieldArray[self.fieldIndex].contentType == ContentType.Password || self.fieldArray[self.fieldIndex].contentType == ContentType.ConfirmPassword {
                        self.isSecureTextEntry = true
                    } else {
                        self.isSecureTextEntry = false
                    }
                    self.label.text = self.fieldArray[self.fieldIndex].name
                }
                self.transitIconView()
                }, completion:nil)
        } else if self.fieldIndex == self.fieldArray.count {
            UIView.animate(withDuration: Constant.defaultDuration*3, delay: Constant.defaultDelay, options: .curveLinear, animations: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay*2) ) {
                    self.label.text = ""
                    self.label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
                    self.label.frame.size = self.bounds.size
                    self.label.textAlignment = .center
                    self.label.font = UIFont.systemFont(ofSize: Constant.fontsize)
                    self.rightView = nil
                    self.layer.borderWidth = 0
                    self.label.alpha = Constant.Zero
                    self.resignFirstResponder()
                }
                self.transitIconView()
                self.text = ""
                }, completion:{(value:Bool) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .showHideTransitionViews, animations: {
                        //Change the text of button.
                        self.label.text = "Welcome"
                        self.label.alpha = Constant.One
                        }, completion: nil)
            })
        }
    }
    
    func transitIconView() {
        
        var leftView = self.viewWithTag(self.fieldIndex-1 + 100)
        var viewFrame = leftView?.frame
        viewFrame?.origin = CGPoint(x: 500 , y: 0)
        self.viewWithTag(self.fieldIndex-1 + 100)?.frame = viewFrame!;
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
        if !isFloatingLabelActive {
            label.frame.size = self.bounds.size
        }
        if(self.isFirstResponder && !isFloatingLabelActive) {
            isFloatingLabelActive = true
            UIView.animate(withDuration: 0, delay: 0, options: .transitionFlipFromLeft, animations: {
                //On selecting the textfield. set the label as floating label.
                //                self.label.transform = self.label.transform.scaledBy(x: Constant.defaultScalingFactor, y: Constant.defaultScalingFactor)
                self.label.text = ""
                self.label.font = UIFont.systemFont(ofSize: 8)
                var labelFrame = self.label.frame
                labelFrame.origin = CGPoint(x: self.bounds.height + CGFloat(Constant.defaultOffset/2) , y: -self.bounds.height/4)
                self.label.frame = labelFrame;
                self.label.textAlignment = .left
                self.label.alpha = Constant.semiTransparentAlpha
                
                }, completion:{(value:Bool) in
                    //                    //Create the button and set as disabled.
                    self.label.text = self.fieldArray[self.fieldIndex].name
                    self.createLeftViews()
                    
                    self.rightNextButton.setImage(#imageLiteral(resourceName: "NextButton"), for: .normal)
                    
                    let rightView = UIView()
                    rightView.addSubview(self.rightNextButton)
                    self.rightViewMode = .always
                    rightView.frame = CGRect(x:0, y:0, width:self.bounds.height, height:self.bounds.height)
                    rightView.backgroundColor = self.textFieldBackgroundColor
                    self.rightNextButton.frame = CGRect(x:0, y:0, width:self.bounds.height/2, height:self.bounds.height/2)
                    self.rightNextButton.center = CGPoint(x: rightView.bounds.midX, y: rightView.bounds.midY)
                    self.rightNextButton.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                    rightView.layer.cornerRadius = self.bounds.height/2
                    rightView.layer.borderWidth = 1
                    rightView.layer.masksToBounds = true
                    rightView.layer.borderColor = UIColor.white.cgColor
                    rightView.tag = 555
                    self.rightView = rightView
            })
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        
    }
    
    func createLeftViews() {
        
        for index in  (0 ..< fieldArray.count).reversed() {
            var leftImageView = UIImageView()
            
            leftImageView.image = self.iconForDisplay(type: self.fieldArray[index].contentType!)
            
            var textFieldleftView = UIView()
            textFieldleftView.addSubview(leftImageView)
            self.leftViewMode = .always
            textFieldleftView.backgroundColor = textFieldBackgroundColor
            textFieldleftView.frame = CGRect(x:0, y:0, width:self.bounds.height, height:self.bounds.height)
            leftImageView.frame = CGRect(x:0, y:0, width:self.bounds.height/2, height:self.bounds.height/2)
            leftImageView.center = CGPoint(x: textFieldleftView.bounds.midX, y: textFieldleftView.bounds.midY)
            
            textFieldleftView.layer.cornerRadius = self.bounds.height/2
            textFieldleftView.layer.borderWidth = 1
            textFieldleftView.layer.masksToBounds = true
            textFieldleftView.layer.borderColor = UIColor.white.cgColor
            textFieldleftView.tag = index+100
            self.addSubview(textFieldleftView)
        }
    }
    
    func iconForDisplay(type: Int) -> UIImage {
        
        switch type {
        case 0:
            return userImage
        case 1:
            return emailIcon
        case 2:
            return passwordImage
        case 3:
            return confirmPassworIcon
        default:
            return userImage
        }
    }
    
    func shake() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    //Function for changing the text area of the textfield.
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: CGFloat(Constant.defaultOffset), dy: CGFloat(Constant.defaultOffset))
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect.init(x: bounds.origin.x + Constant.defaultCornerRadius + self.bounds.height , y: bounds.origin.y + bounds.height/(Constant.defaultCornerRadius/2), width: bounds.width, height: bounds.height)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: CGFloat(Constant.defaultOffset), dy: CGFloat(Constant.defaultCornerRadius*3))
    }
}
