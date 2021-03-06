//
//  RutasTableViewController.swift
//  ProyectoEjercicio
//
//  Created by ander zugasti on 15/02/2020.
//  Copyright © 2020 ander zugasti. All rights reserved.
//

import UIKit
import RealmSwift

class RutasTableViewController: UITableViewController {
    
    var tag = 0
    
   let realm = try! Realm() // [1]
   var rutas: Results<Ruta> { // [2]
        get{
            return realm.objects(Ruta.self)
        }
    }
    
    override func viewDidLoad() {
        self.tableView.reloadData()
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
       }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rutaCount = rutas.count
        return rutaCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! RutaTableViewCell
        
        let num = indexPath.row
        
        cell.fechalbl.text = rutas[num].dia
        cell.tiempolbl.text = rutas[num].tiempo
        cell.distancialbl.text = rutas[num].distancia + " Km"
        cell.buttInvisible.tag = indexPath.row
        cell.icono.layer.borderWidth = 1
        cell.icono.layer.borderColor = UIColor.black.cgColor
        cell.icono.layer.cornerRadius = 20
        cell.icono.clipsToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.black.cgColor.copy(alpha: 0.2)
        if num % 2 == 0{
            cell.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
            cell.layer.borderWidth = 4
            
        }else{
            cell.layer.borderColor = UIColor.systemYellow.withAlphaComponent(0.5).cgColor
            
            cell.layer.borderWidth = 4
        }
        switch rutas[num].deporte {
        case "Correr":
            cell.icono.image =  UIImage(named:"correr" )
            
            
        case "Bici":
            cell.icono.image =  UIImage(named:"bici" )
            
            
        case "Andar":
            cell.icono.image = UIImage(named: "andando")
            
        default:
            print ("no foto")
        }
        
        
        
        //Configure the cel

        return cell
    }
    
    
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tag = indexPath.row
        
        self.performSegue(withIdentifier:"seleccion", sender: indexPath.row)
        
        
        
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { if( segue.identifier == "seleccion"){
       
           let destino = segue.destination as! RutaListaViewController
           destino.tag = tag
           destino.rutas = rutas[tag]
          
        
           }}


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
