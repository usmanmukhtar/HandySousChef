//
//  VideoLauncher + Extension.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 09/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

extension PlayerView: UITableViewDelegate, UITableViewDataSource {
    
    func setupUI(){
        self.Notes.dataSource = self
        self.Notes.delegate = self
        self.Notes.separatorStyle = .none
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
            return 70
        default:
            return 40
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        let view = UIView()
        view.backgroundColor = UIColor(named: "primary-color")
        
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
            headerView.btnshare.addTarget(self, action: #selector(onbtnHeader(_:)), for: .touchUpInside)
            return headerView
        case 1:
            title.text = "Ingredients"
        case 2:
            title.text = "Steps"
        default:
            title.text = ""
        }

        let button = UIButton(frame: CGRect(x: frame.size.width - 40, y: 0, width: 40, height: 40))
        button.tag = section
        button.addTarget(self, action: #selector(onbtnAdd(_:)), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus.app.fill"), for: UIControl.State.normal)
        button.tintColor = .white
        view.addSubview(button)
        
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

        cell.textViewNotes.text = (indexPath.section == 1 ? ingredients[indexPath.row].name : (indexPath.section == 2 ? steps[indexPath.row].name : ""))
        if indexPath.section == 1 {
            if ingredients[indexPath.row].checked {
                cell.btnCheck.setBackgroundImage(UIImage(named: "checkBoxFILLED"), for: UIControl.State.normal)
            }else{
                cell.btnCheck.setBackgroundImage(UIImage(named: "checkBoxOUTLINE"), for: UIControl.State.normal)
            }
        }
        else if indexPath.section == 2{
            if steps[indexPath.row].checked {
                cell.btnCheck.setBackgroundImage(UIImage(named: "checkBoxFILLED"), for: UIControl.State.normal)
            }else{
                cell.btnCheck.setBackgroundImage(UIImage(named: "checkBoxOUTLINE"), for: UIControl.State.normal)
            }
            
        }
        
        cell.delegate = self
        cell.indexP = indexPath.row
        cell.section = indexPath.section
        cell.steps = steps
        cell.ingredients = ingredients

        
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
    
    @objc func onbtnHeader(_ sender: UIButton){
        var shareContent: String = "Ingredients: \n"
        for (ingredient) in ingredients {
            if ingredient.checked {
                shareContent.append(contentsOf: "- \(ingredient.name) \n")
            }
        }
        
        print(shareContent)
        let activityController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        rootViewController?.present(activityController, animated: true, completion: nil)
    }
    
    @objc func onbtnAdd(_ sender: UIButton){
        let ac = UIAlertController(title: "Enter Notes", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            self.insertNewRow(section: sender.tag, answer: answer.text ?? "")
        }

        ac.addAction(submitAction)
        
        rootViewController?.present(ac, animated: true)
        
    }
    
    func insertNewRow(section: Int, answer: String) {
        var count = 0
        
        if section == 1 {
            ingredients.append(Ingredients(name: answer))
            count = ingredients.count
        }else if section == 2 {
            steps.append(Steps(name: answer))
            count = steps.count
        }
        
        let indexPath = IndexPath(row: (count - 1), section: section)
        Notes.beginUpdates()
        Notes.insertRows(at: [indexPath], with: .left)
        Notes.endUpdates()
        self.scrollToBottom(indexPath)
        
        if Notes.visibleCells.count < 2 {
            let cell = Notes.visibleCells[0] as! NotesCell
            cell.animateSwipeHint()
        }
        
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
    }
    
    func scrollToBottom(_ indexPath: IndexPath)
    {

        if indexPath.row > 0 {
            Notes.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
        }
    }
}

extension PlayerView: ChangeBtnCheck {
    func changebtnCheck(checked: Bool, index: Int, section: Int) {
        
        if section == 1 {
            ingredients[index].checked = checked
        }else if section == 2 {
            steps[index].checked = checked
        }
        
        Notes.reloadData()
    }
}
