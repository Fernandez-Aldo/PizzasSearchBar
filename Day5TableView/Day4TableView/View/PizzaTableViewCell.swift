//
//  PizzaTableViewCell.swift
//  Day4TableView
//
//  Created by Kevin Yu on 2/26/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

class PizzaTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    
    weak var delegate: MakeFavoriteProtocol!
    var index: Int?
    
    var isFavorite: Bool! {
        set {
            if newValue == true {
                button.setImage(UIImage(named: "goldstar.png"), for: .normal)
                button.tag = 1
            }
            else {
                button.setImage(UIImage(named: "graystar.png"), for: .normal)
                button.tag = 0
            }
        }
        get {
            return button.tag == 1
        }
    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        // make selected pizza a favorite (or unfavorite it)
        guard let i = index else { return }
        self.delegate?.toggle(at: i)
    }
    
}
