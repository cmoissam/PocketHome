//
//  UIComponents.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import Foundation
import UIKit

class LocalizedLabel : UILabel {
    
    @IBInspectable var keyValue: String {
        get {
            return self.text!
        }
        set(value) {
            self.text = NSLocalizedString(value, comment: "")
            
        }
    }
}

class LocalizedButton : UIButton {
    
    @IBInspectable var keyValue: String? {
        get {
            return self.titleLabel?.text
        }
        set(value) {
            setTitle(NSLocalizedString(value!, comment: ""), for: .normal)
            
        }
    }
}
