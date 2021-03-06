//
//  MenuViewController.swift
//  ProyectoEjercicio
//
//  Created by  on 14/02/2020.
//  Copyright © 2020 ander zugasti. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    @IBOutlet weak var correrImg: UIImageView!
    @IBOutlet weak var BiciImg: UIImageView!
    @IBOutlet weak var andarImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        correrImg.image = UIImage(named:"correr" )
        BiciImg.image = UIImage(named: "bici")
        andarImg.image = UIImage(named: "andando")
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "correr":
            let destino = segue.destination as! MapaViewController;
            destino.seleccionEjercicio = 1
        case "bici":
            let destino = segue.destination as! MapaViewController;
            destino.seleccionEjercicio = 2
        case "andar":
            let destino = segue.destination as! MapaViewController;
            destino.seleccionEjercicio = 3
            
        default:
            print("datos")
            
            
        }
        
        
            
        
    
    
    }

    /*
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
