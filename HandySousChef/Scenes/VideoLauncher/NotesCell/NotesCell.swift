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
}

class NotesCell: UITableViewCell, UITextViewDelegate {
    
    weak var cellDelegate: GrowingCellProtocol?
    
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
    
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = cellDelegate {
            deletate.updateHeightOfRow(self, textView)
        }
    }
    
}
