//
//  ActividadFinalizadaViewController.swift
//  ProyectoEjercicio
//
//  Created by  on 06/02/2020.
//  Copyright © 2020 ander zugasti. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import RealmSwift
class Ruta: Object {
    @objc dynamic var id = 0
    @objc dynamic var distancia = ""
    @objc dynamic var tiempo = ""
    var listaLatitudes = List<String>()
    var listaLongitudes = List<String>()
    @objc dynamic var tienpoPorKm = ""
    @objc dynamic var dia = ""
    @objc dynamic var deporte = ""
    override class func primaryKey() -> String {
        return "id"
    }
    
}




class ActividadFinalizadaViewController: UIViewController {
    
   
    var cronometro2: Int = 0
    var KMTotales2: Double = 0.0
    var ruta2 = [[CLLocationCoordinate2D]]()
    var listaLatitudes = List<String>()
    var listaLongitudes = List<String>()
    var horas:Int = 0
    var minutos: Int = 0
    var segundos: Int = 0
    var division = 0.0
    var horas2:Int = 0
    var minutos2: Int = 0
    var segundos2: Int = 0
    var polilinea : MKPolyline?
    var objetivo = 0
    var ejercicio = ""
    var deporte = ""
    let fecha = Date()
    let formater = DateFormatter()
    let realm = try! Realm()
       var rutas: Results<Ruta> {
           get{
               return realm.objects(Ruta.self)
           }
       }

     
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapa2: MKMapView!
    @IBOutlet weak var KM_min: UILabel!
    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var tiempo: UILabel!
    @IBOutlet weak var objetivolbl: UILabel!
    var vista = 0.0
    
    
    
    override func viewDidLoad() {
        switch objetivo {
        case 1:
            vista = 0.05
        case 2:
            vista = 0.06
        case 3:
            vista = 0.05
            
        default:
            vista = 0.04
        }
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: vista, longitudeDelta: vista)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: ruta2[0][(ruta2[0].count)/2], span: span)
        mapa2.setRegion(region, animated:true)
        mapa2.delegate = self
        distancia.text = String(format: "%.02f", KMTotales2/1000)
        calcularTiempo()
        tiempo.text = String("\(horas)h \(minutos)min \(segundos)s")
        calcularKM_min()
        
        Objetivo(numero: objetivo)
        rutaAString(ruta: ruta2)
        for ruta in ruta2 {
            polilinea = MKPolyline(coordinates: ruta, count: ruta.count)
            mapa2.addOverlay(polilinea!)
        }
        
       
    }
    
    
    
    func Objetivo(numero: Int){
        switch numero {
        case 1:
            ejercicio = UserDefaults.standard.string(forKey: "objetivoCorrer")!
            deporte = "Correr"
        case 2:
            ejercicio = UserDefaults.standard.string(forKey: "objetivoBici")!
            deporte = "Bici"
        case 3:
            ejercicio = UserDefaults.standard.string(forKey: "objetivoAndando")!
            deporte = "Andar"
        default:
            ejercicio = "ninguno"
        }
        let reto: Double = Double(ejercicio)!
        if (KMTotales2/1000 >  reto){
            switch numero {
            case 1:
                UserDefaults.standard.set(String((Int(ejercicio) ?? 0)+2), forKey: "objetivoCorrer")
           
            case 2:
                UserDefaults.standard.set(String((Int(ejercicio) ?? 0)+10), forKey: "objetivoBici")
            case 3:
                UserDefaults.standard.set(String((Int(ejercicio) ?? 0)+5), forKey: "objetivoAndando")
            default:
                ejercicio = "ninguno"
            }
            objetivolbl.text = "objetivo superado"
            
        }
        else{
            objetivolbl.text = "objetivo no superado"
        }
        
    }
    
    func rutaAString(ruta: [[CLLocationCoordinate2D]]){
        for recorrido in ruta{
            for punto in recorrido{
                let latitud = String(punto.latitude)
                let longitud = String(punto.longitude)
                listaLatitudes.append(latitud)
                listaLongitudes.append(longitud)
            }
            listaLatitudes.append("siguiente")
            listaLongitudes.append("siguiente")
            
        }
        
    }
    
    func calcularTiempo(){
         horas = cronometro2 / 3600
         minutos = (cronometro2-(horas*3600))/60
         segundos = ((cronometro2-(horas*3600))-(60*minutos))
    }
    
    func calcularKM_min(){
        
        let tiempoS = Double(cronometro2)
        print (cronometro2)
        print ("ok")
        print (KMTotales2)
        if (KMTotales2  > 1000.0){
            print ("ok")
            let tiempoPara1Km = Int(tiempoS / (KMTotales2/1000))
            minutos2 = tiempoPara1Km/60
            segundos2 = (tiempoPara1Km)-(60*minutos2)
            KM_min.text = String("\(minutos2)min \(segundos2)s")
            }
        else{
            KM_min.text = "Ruta muy corta"
        }
    }
    
    
    
    func guardaDatos() -> Ruta {
        
        formater.dateFormat = "dd.MM.yyyy"
        let result = formater.string(from: fecha)
        /*Datos para guardar*/
        let KMGuardar = distancia.text
        let TiempoGuardar = tiempo.text
        let KMinGuardar = KM_min.text
        let latitudesGuardar = listaLatitudes
        let longitudesGuardar = listaLongitudes
        
        let nuevoRecorrido = Ruta()
        if rutas.isEmpty{
            nuevoRecorrido.id = 0
        }else{
        nuevoRecorrido.id = (rutas[rutas.count-1].id)+1
        }
        nuevoRecorrido.distancia = KMGuardar!
        nuevoRecorrido.tiempo = TiempoGuardar!
        nuevoRecorrido.listaLatitudes = latitudesGuardar
        nuevoRecorrido.listaLongitudes = longitudesGuardar
        nuevoRecorrido.tienpoPorKm = KMinGuardar!
        nuevoRecorrido.dia = String(result)
        nuevoRecorrido.deporte = deporte
        print(nuevoRecorrido)
        return nuevoRecorrido
    }
    
    @IBAction func GuardarButt(_ sender: Any) {
        let alertController = UIAlertController(title:"Ruta guardad con exito", message: "",preferredStyle: UIAlertController.Style.alert)
        let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
            let realm = try! Realm()
            
            let rutaAGuardar = self.guardaDatos()
            try! realm.write{
            realm.add(rutaAGuardar)
            
            }
        let CancelarAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(CancelarAction)
       
        
        self.present(alertController, animated: true)
        }
    
    @IBAction func DescartarButt(_ sender: Any) {
        let alertController = UIAlertController(title:"¿Esta seguro que desea descartar la ruta?", message: "",preferredStyle: UIAlertController.Style.alert)
        let pantallaPrincipal = UIAlertAction(title: "Si", style: .default) { (action) in
            
            self.navigationController?.popToRootViewController(animated: true)

        }
        
        let CancelarAction = UIAlertAction(title: "Atras", style: .cancel) { (action) in
            
        }
        alertController.addAction(CancelarAction)
        alertController.addAction(pantallaPrincipal)
       
        
        self.present(alertController, animated: true)
        }
    
    
    

}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}

extension ActividadFinalizadaViewController:MKMapViewDelegate{
  func mapView(_ mapView: MKMapView,rendererFor overlay: MKOverlay)-> MKOverlayRenderer!{
      if (overlay is MKPolyline){
          let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
          renderer.strokeColor = UIColor.blue.withAlphaComponent(0.8)
          renderer.lineWidth=4
           return renderer
      }
  
      
     return nil
 
     
      

  }
}
