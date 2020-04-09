//
//  VideoLauncher + Extension.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 09/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import Foundation
import UIKit

extension PlayerView: UITableViewDelegate, UITableViewDataSource {
    
    func setupUI(){
        self.Notes.dataSource = self
        self.Notes.delegate = self
        registerTVC()
    }
    
    private func registerTVC(){
        
        let headerNib = UINib.init(nibName: "NotesHeader", bundle: Bundle.main)
        self.Notes.register(headerNib, forHeaderFooterViewReuseIdentifier: "NotesHeader")
        self.Notes.register(UINib(nibName: "NotesCell", bundle: nil), forCellReuseIdentifier: "NotesCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 100
        default:
            return 40
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        
        switch section {
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NotesHeader") as! NotesHeader
            return headerView
        case 1:
            title.text = "Ingredients"
        case 2:
            title.text = "Steps"
        default:
            title.text = ""
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1 // last row
        if lastRowIndex == indexPath.row && indexPath.section == 1 {
            insertNewRow(lastRowIndex: lastRowIndex, section: indexPath.section)
        }
    }
    
    func insertNewRow(lastRowIndex: Int, section: Int) {
        
        let indexPath = IndexPath(row: (lastRowIndex + 1), section: section)
        Notes.beginUpdates()
        Notes.insertRows(at: [indexPath], with: .left)
        Notes.endUpdates()
    }
}
