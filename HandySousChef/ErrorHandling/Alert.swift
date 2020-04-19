//
//  Alert.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 14/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import Foundation
import UIKit


class Alert {
    func msg(message: String, title: String = "", errorCode: String = "")
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if errorCode == "-1001" {
            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        } else if errorCode == "-1009"{
            alertView.addAction(UIAlertAction(title: "Go Back", style: .default, handler: { (alert: UIAlertAction!) in
                let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                navController?.popViewController(animated: true)
            }))
        }

        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
}
