//
//  UIViewController+Extensions.swift
//  PocketHome
//
//  Created by Issam Lanouari on 17/10/2020.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlertController(title: String, message: String) {
        let attributedTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.red
        ])
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
