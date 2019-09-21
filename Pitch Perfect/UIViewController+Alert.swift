//
//  UIViewController+Alert.swift
//  Pitch Perfect
//
//  Created by Ivan Radunovic on 21/09/2019.
//  Copyright © 2019 Codingo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
