//
//  ViewController.swift
//  ProyectoEjercicio
//
//  Created by ander zugasti on 18/01/2020.
//  Copyright © 2020 ander zugasti. All rights reserved.
//

import UIKit
import SideMenu
import RealmSwift
class ViewController: UIViewController {
    
    @IBOutlet weak var fechalbl: UILabel!
    @IBOutlet weak var Distancialbl: UILabel!
    @IBOutlet weak var Tiempolbl: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var txtlbl: UILabel!
    @IBOutlet weak var recuadro: UIView!
    @IBOutlet weak var viewObjetivos: UIView!
    @IBOutlet weak var objCorr: UILabel!
    @IBOutlet weak var objBici: UILabel!
    @IBOutlet weak var ObjCami: UILabel!
    
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        viewObjetivos.layer.borderWidth = 1
        viewObjetivos.layer.borderColor = UIColor.black.cgColor
        viewObjetivos.layer.cornerRadius = 20
         
}
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.navigationController!.isToolbarHidden){
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            
        }
        if ((UserDefaults.standard.string(forKey: "objetivoCorrer")) != nil || (UserDefaults.standard.string(forKey: "objetivoBici")) != nil || (UserDefaults.standard.string(forKey: "objetivoAndando")) != nil){
                objCorr.text = "Objetivo Corriendo: " + UserDefaults.standard.string(forKey: "objetivoCorrer")! + " Km"
                objBici.text = "Objetivo en Bici: " + UserDefaults.standard.string(forKey: "objetivoBici")! + " Km"
                ObjCami.text = "Objetivo Caminando: " + UserDefaults.standard.string(forKey: "objetivoAndando")! + " Km"
             }else{
                objCorr.text = "Por favor rellene "
                objBici.text = "los datos en el menú"
                 ObjCami.text = "Datos personales"
            
        }
        let realm = try! Realm()
        var rutas: Results<Ruta> { 
            get{
                return realm.objects(Ruta.self)
            }
        }
            if rutas.isEmpty{
                txtlbl.text = "Realiza un ejercicio"
                fechalbl.isHidden = true
                Tiempolbl.isHidden = true
                Distancialbl.isHidden = true
                imagen.isHidden = true
            }else{
                let ultimo = rutas.count-1
                txtlbl.text = "Ultimo recorrido"
                fechalbl.isHidden = false
                Tiempolbl.isHidden = false
                Distancialbl.isHidden = false
                imagen.isHidden = false
                fechalbl.text = rutas[ultimo].dia
                Distancialbl.text = String(rutas[ultimo].distancia) + " Km"
                Tiempolbl.text = rutas[ultimo].tiempo
                imagen.layer.borderWidth = 1
                imagen.layer.borderColor = UIColor.black.cgColor
                imagen.layer.cornerRadius = 20
                imagen.clipsToBounds = true
                recuadro.layer.borderWidth = 1
                recuadro.layer.borderColor = UIColor.black.cgColor
                recuadro.layer.cornerRadius = 20
                
                switch rutas[ultimo].deporte{
                case "Correr":
                    imagen.image =  UIImage(named:"correr" )
                   
                    
                case "Bici":
                    imagen.image =  UIImage(named:"bici" )
                case "Andar":
                    imagen.image =  UIImage(named:"andando" )
                default:
                    print("error")
                }
                
            }
        }
    }









