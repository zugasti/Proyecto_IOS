//
//  RutaListaViewController.swift
//  ProyectoEjercicio
//
//  Created by  on 18/02/2020.
//  Copyright © 2020 ander zugasti. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class RutaListaViewController: UIViewController {

    @IBOutlet weak var fechaLbl: UILabel!
    @IBOutlet weak var distanciaLbl: UILabel!
    @IBOutlet weak var tiempoLbl: UILabel!
    @IBOutlet weak var mediaLbl: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    var vista = 0.5
    var tag: Int = 0
    var rutas: Ruta? = nil
    var recorrido = [[CLLocationCoordinate2D]]()
    var polilinea : MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch rutas?.deporte {
        case "Andar":
            vista = 0.04
        case "Bici":
            vista = 0.1
        case "Correr":
            vista = 0.03
            
        default:
            vista = 1
        }
        rellenaRuta(latitudes: Array(rutas!.listaLatitudes), longitudes: Array(rutas!.listaLongitudes))
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: vista, longitudeDelta: vista)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: (recorrido[0][recorrido[0].count/2]), span: span)
        mapa.setRegion(region, animated:true)
        mapa.delegate = self 
        fechaLbl.text = rutas?.dia
        distanciaLbl.text = rutas!.distancia + "Km"
        tiempoLbl.text = rutas?.tiempo
        mediaLbl.text = rutas?.tienpoPorKm
        for ruta in recorrido {
            polilinea = MKPolyline(coordinates: ruta, count: ruta.count)
            mapa.addOverlay(polilinea!)
        }
        
       
        // Do any additional setup after loading the view.
    }
    func rellenaRuta(latitudes: Array<String> ,longitudes: Array<String>){
        var camino = [CLLocationCoordinate2D]()
        var cont = 0
        
        for punto in rutas!.listaLatitudes{
            if punto != "siguiente"{
                var location: CLLocationCoordinate2D
                let latitud = punto
                let longitud = rutas?.listaLongitudes[cont]
                
                location = CLLocationCoordinate2DMake(CLLocationDegrees(latitud)!,  CLLocationDegrees(longitud!)!)
                camino.append(location)
                cont+=1
                
            }else{
                cont+=1
                recorrido.append(camino)
                camino.removeAll()
            }
            
        }
        
    }

    @IBAction func borrarButt(_ sender: Any) {
        let realm = try! Realm()
        let borrar = realm.objects(Ruta.self).filter("id = %@", rutas!.id)
        try! realm.write {
        
            realm.delete(borrar)
        
        }
      
        let alertController = UIAlertController(title:"Ruta eliminada con exito", message: "",preferredStyle: UIAlertController.Style.alert)
        let CancelarAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
             self.navigationController?.popViewController(animated: true)
         }
         alertController.addAction(CancelarAction)
        
         
         self.present(alertController, animated: true)
        
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



extension RutaListaViewController:MKMapViewDelegate{
  func mapView(_ mapView: MKMapView,rendererFor overlay: MKOverlay)-> MKOverlayRenderer!{
      if (overlay is MKPolyline){
          let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
          renderer.strokeColor = UIColor.blue.withAlphaComponent(1)
          renderer.lineWidth=4
           return renderer
      }
  
      
     return nil
 
     
      

  }
}


