//
//  DatosPersonalesViewController.swift
//  ProyectoEjercicio
//
//  Created by ander zugasti on 03/02/2020.
//  Copyright © 2020 ander zugasti. All rights reserved.
//

import UIKit

class DatosPersonalesViewController: UIViewController {
    @IBOutlet weak var alturatxt: UITextField!
    @IBOutlet weak var pesotxt: UITextField!
    @IBOutlet weak var estadoActual: UILabel!
    @IBOutlet weak var guardarButt: UIButton!
    
    @IBOutlet weak var gorduralbl: UILabel!
    
    @IBOutlet weak var objetivoAndando: UITextField!
    @IBOutlet weak var objetivoCorrer: UITextField!
    @IBOutlet weak var objetivoBici: UITextField!
    let def = UserDefaults.standard
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        
        if ((UserDefaults.standard.string(forKey: "Altura")) != nil){
            alturatxt.text = UserDefaults.standard.string(forKey: "Altura")
            alturatxt.isUserInteractionEnabled = false
        }
         if ((UserDefaults.standard.string(forKey: "objetivoAndando")) != nil){
             objetivoAndando.text = UserDefaults.standard.string(forKey: "objetivoAndando")
             objetivoAndando.isUserInteractionEnabled = false
        }
           if ((UserDefaults.standard.string(forKey: "objetivoCorrer")) != nil){
            objetivoCorrer.text = UserDefaults.standard.string(forKey: "objetivoCorrer")
            objetivoCorrer.isUserInteractionEnabled = false
        }
            if ((UserDefaults.standard.string(forKey: "objetivoBici")) != nil){
            objetivoBici.text = UserDefaults.standard.string(forKey: "objetivoBici")
            objetivoBici.isUserInteractionEnabled = false
        }
           
            pesotxt.text = UserDefaults.standard.string(forKey: "Peso")
        
            calcularGordura()
        
    }
    
    @IBAction func Guardar_Editar(_ sender: Any) {
         if ((UserDefaults.standard.string(forKey: "Altura")) == nil){
           def.set(alturatxt.text, forKey: "Altura")
        }
         if ((UserDefaults.standard.string(forKey: "objetivoAndando")) == nil){
            def.set(objetivoAndando.text,forKey:"objetivoAndando")
        }
         if ((UserDefaults.standard.string(forKey: "objetivoCorrer")) == nil){
            def.set(objetivoCorrer.text, forKey: "objetivoCorrer")
        }
         if ((UserDefaults.standard.string(forKey: "objetivoBici")) == nil){
            def.set(objetivoBici.text, forKey: "objetivoBici")
        }
        def.set(pesotxt.text, forKey: "Peso")
        def.synchronize()
        
        
        
        let alertController = UIAlertController(title:"Datos guardados con exito", message: "Gracias",preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        calcularGordura()
        
    }
    func calcularGordura(){
        if ((UserDefaults.standard.string(forKey: "Altura")) != nil && (UserDefaults.standard.string(forKey: "Peso")) != nil){
            let altura = Double(alturatxt.text!)!
            let peso = Double(pesotxt.text!)!
            let estado = (peso / pow(altura / 100, 2))
            print (altura, peso, estado)
            switch estado {
            case 0 ... 18,4:
                gorduralbl.text = "Peso insuficiente"
                gorduralbl.textColor = UIColor.blue
                
            case 18,5 ... 24,9:
                gorduralbl.text = "Normopeso"
                gorduralbl.textColor = UIColor.green.withAlphaComponent(0.9)
                
            case 25,0 ... 29,8:
                gorduralbl.text = "Sobrepeso"
                gorduralbl.textColor = UIColor.orange
                break
            default:
                gorduralbl.text = "Obesidad"
                gorduralbl.textColor = UIColor.red
            }
        }
    }
    
}
