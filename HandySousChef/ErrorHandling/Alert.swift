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
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
           return
        }
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if errorCode == "-1001" {
            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        } else if errorCode == "-1009"{
            alertView.addAction(UIAlertAction(title: "Go Back", style: .default, handler: { (alert: UIAlertAction!) in
                if let navController = rootViewController as? UINavigationController {
                       navController.popViewController(animated: true)
                }
                
            }))
        } else if errorCode == "403" {
            alertView.message = message + " Please Try Again Tomorrow :("
            alertView.addAction(UIAlertAction(title: "Go Back", style: .default, handler: { (alert: UIAlertAction!) in
                if let navController = rootViewController as? UINavigationController {
                       navController.popViewController(animated: true)
                }
            }))
        }

        rootViewController.present(alertView, animated: true, completion: nil)
    }
}
