//
//  NotesCell.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 09/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit

protocol GrowingCellProtocol: class {
    func updateHeightOfRow(_ cell: NotesCell, _ textView: UITextView)
    func onbtnCheckbox(checked: Bool, index: Int, section: Int)
}

class NotesCell: UITableViewCell, UITextViewDelegate {
    
    weak var cellDelegate: GrowingCellProtocol?
    var indexPath: Int?
    var section: Int?
    var steps: [Steps]?
    var ingredients: [Ingredients]?
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak public var textViewNotes: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewNotes.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onbtnCheck(_ sender: Any) {
        if steps![indexPath!].checked && section == 2{
            cellDelegate?.onbtnCheckbox(checked: false, index: indexPath!, section: section!)
        } else if ingredients![indexPath!].checked && section == 1 {
            cellDelegate?.onbtnCheckbox(checked: false, index: indexPath!, section: section!)
        } else {
            cellDelegate?.onbtnCheckbox(checked: true, index: indexPath!, section: section!)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = cellDelegate {
            deletate.updateHeightOfRow(self, textView)
        }
    }
    
}
