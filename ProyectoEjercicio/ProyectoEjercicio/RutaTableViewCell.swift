//
//  RutaTableViewCell.swift
//  ProyectoEjercicio
//
//  Created by ander zugasti on 15/02/2020.
//  Copyright © 2020 ander zugasti. All rights reserved.
//

import UIKit

class RutaTableViewCell: UITableViewCell {

    @IBOutlet weak var fechalbl: UILabel!
    @IBOutlet weak var distancialbl: UILabel!
    @IBOutlet weak var tiempolbl: UILabel!
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var buttInvisible: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
