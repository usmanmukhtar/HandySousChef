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
        steps.append(Steps(name: ""))
        ingredients.append(Ingredients(name: ""))
        registerTVC()
    }
    
    private func registerTVC(){
        
        let headerNib = UINib.init(nibName: "NotesHeader", bundle: Bundle.main)
        self.Notes.register(headerNib, forHeaderFooterViewReuseIdentifier: "NotesHeader")
        self.Notes.register(UINib(nibName: "NotesCell", bundle: nil), forCellReuseIdentifier: "NotesCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            return ingredients.count
        case 2:
            return steps.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesCell
        cell.cellDelegate = self
        cell.textViewNotes.text = (indexPath.section == 1 ? ingredients[indexPath.row].name : (indexPath.section == 2 ? steps[indexPath.row].name : ""))
        
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1 // last row
        if lastRowIndex == indexPath.row {
            cell.btnAdd.alpha = 1
            cell.btnAdd.tag = indexPath.section
            cell.btnAdd.addTarget(self, action: #selector(onbtnAdd), for: .touchUpInside)
        }else{
            cell.btnAdd.alpha = 0
        }
        
        cell.indexPath = indexPath.row
        cell.section = indexPath.section
        cell.steps = steps
        cell.ingredients = ingredients
        if steps[indexPath.row].checked && indexPath.section == 2{
            cell.btnCheck.setBackgroundImage(UIImage(named: "checkBoxFILLED"), for: .normal)
        } else if ingredients[indexPath.row].checked && indexPath.section == 1{
            cell.btnCheck.setBackgroundImage(UIImage(named: "checkBoxFILLED"), for: .normal)
        } else {
            cell.btnCheck.setBackgroundImage(UIImage(named: "checkBoxOUTLINE"), for: .normal)
        }

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRow(indexPath: indexPath)
        }
    }
    
    @objc func onbtnAdd(_ sender: UIButton){
        insertNewRow(section: sender.tag)
    }
    
    func insertNewRow(section: Int) {
        var count = 0
        
        if section == 1 {
            ingredients.append(Ingredients(name: ""))
            count = ingredients.count
        }else if section == 2 {
            steps.append(Steps(name: ""))
            count = steps.count
        }
        
        var indexPath = IndexPath(row: (count - 1), section: section)
        Notes.beginUpdates()
        Notes.insertRows(at: [indexPath], with: .left)
        Notes.endUpdates()
        self.scrollToBottom(indexPath)
        indexPath.row -= 1
        Notes.reloadRows(at: [(indexPath)], with: .left)
    }
    
    func deleteRow(indexPath: IndexPath) {
        if indexPath.section == 1 {
            ingredients.remove(at: indexPath.row)
            
        }
        else if indexPath.section == 2 {
            steps.remove(at: indexPath.row)
        }
        
        Notes.beginUpdates()
        Notes.deleteRows(at: [indexPath], with: .right)
        Notes.endUpdates()
        
        if ingredients.isEmpty {
            insertNewRow(section: 1)
        }
        else if steps.isEmpty {
            insertNewRow(section: 2)
        }
    }
    
    func scrollToBottom(_ indexPath: IndexPath)
    {

        if indexPath.row > 0 {
            Notes.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
}

extension PlayerView: GrowingCellProtocol {
    func updateHeightOfRow(_ cell: NotesCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = Notes.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            Notes?.beginUpdates()
            Notes?.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = Notes.indexPath(for: cell) {
                Notes.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func onbtnCheckbox(checked: Bool, index: Int, section: Int) {
        if section == 1 {
            ingredients[index].checked = checked
        } else if section == 2 {
            steps[index].checked = checked
        }
        Notes.reloadData()
    }
}
