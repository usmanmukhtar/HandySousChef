//
//  NotesCell.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 09/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit

protocol ChangeBtnCheck {
    func changebtnCheck(checked: Bool, index: Int, section: Int)
}

class NotesCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak public var textViewNotes: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var delegate: ChangeBtnCheck?
    var indexP: Int?
    var section: Int?
    var steps: [Steps]?
    var ingredients: [Ingredients]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animateSwipeHint() {
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.curveEaseOut], animations: {
            self.cellView.transform = CGAffineTransform(translationX: -40, y: 0)
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
                self.cellView.transform = .identity
            }) { (success) in
                
            }
        }
    }
    
    
    @IBAction func onbtnCheck(_ sender: Any) {
        if section == 2 {
            if steps![indexP!].checked {
                delegate?.changebtnCheck(checked: false, index: indexP!, section: section!)
            }else{
                delegate?.changebtnCheck(checked: true, index: indexP!, section: section!)
            }
        }else if section == 1 {
            if ingredients![indexP!].checked {
                delegate?.changebtnCheck(checked: false, index: indexP!, section: section!)
            }else{
                delegate?.changebtnCheck(checked: true, index: indexP!, section: section!)
            }
        }
    }
    
}
