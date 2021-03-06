//
//  MapaViewController.swift
//  ProyectoEjercicio
//
//  Created by  on 31/01/2020.
//  Copyright © 2020 ander zugasti. All rights reserved.
//

import UIKit
import MapKit




class MapaViewController: UIViewController {
    
    @IBOutlet weak var FinalizarBoton: UIButton!
    @IBOutlet weak var kmContadorlbl: UILabel!
    @IBOutlet weak var kmlbl: UILabel!
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var InicioBoton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cronometrolbl: UILabel!
    @IBOutlet weak var horaslbl: UILabel!
    @IBOutlet weak var textoObjetivo: UILabel!
    
    
    var KMTotales: Double=0
    var ruta: MKPolyline?
    var ArrayPuntos = [CLLocationCoordinate2D]()
    var rutaFinal = [[CLLocationCoordinate2D]]()
    var enFuncionamiento = false
    var cronometro = Timer()
    var segundos: Int = 0
    var minutos: Int = 0
    var horas: Int = 0
    var contador: Int=0
    var enPausa: Bool = true
    var puntoAnterior: MKMapPoint?
    let locationManager = CLLocationManager()
    var seleccionEjercicio = 0
    var objetivo = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        switch seleccionEjercicio {
        case 1:
            self.title = "Corriendo "
        case 2:
            self.title = "En bici"
        case 3:
            self.title = "Andando"
        default:
            self.title = "Ejerci"
        }
        
        localizar()
        FinalizarBoton.isHidden = true
        kmlbl.isHidden = true
        kmContadorlbl.isHidden = true
        pauseButton.isHidden = true
        
        
        locationManager.delegate = self
        mapa.delegate = self
        locationManager.startUpdatingLocation()
        
                   
        // Do any additional setup after loading the view.
    }
    
    func sacarObjetivo(numero: Int){
        switch numero {
        case 1:
            objetivo = UserDefaults.standard.string(forKey: "objetivoCorrer")!
        case 2:
            objetivo = UserDefaults.standard.string(forKey: "objetivoBici")!
        case 3:
            objetivo = UserDefaults.standard.string(forKey: "objetivoAndando")!
        default:
            objetivo = "ninguno"
        }
        textoObjetivo.text = "Objetivo a superar  " + objetivo + " Km"
        
    }
       
        
    func localizar(){
        
       let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
         switch status {
        
        
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .restricted:
                 locationManager.requestWhenInUseAuthorization()
                case .denied:
                    break
                case .authorizedAlways:
                    mapa.showsUserLocation = true
                case .authorizedWhenInUse:
                    mapa.showsUserLocation = true
                default:
                    break
                }
        
        
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { if( segue.identifier == "finalizado") {
        let destino = segue.destination as! ActividadFinalizadaViewController
        destino.KMTotales2 = KMTotales
        destino.cronometro2 = contador
        destino.ruta2 = rutaFinal
        destino.objetivo = seleccionEjercicio
        }}
    
    @IBAction func EmpezarButt(_ sender: Any) {
        FinalizarBoton.isHidden = true
        InicioBoton.isHidden = true
        kmContadorlbl.isHidden = false
        kmlbl.isHidden = false
        pauseButton.isHidden = false
        enFuncionamiento = true
        cronometro = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MapaViewController.UpdateTimer), userInfo: nil, repeats: true)
        enPausa = false
        sacarObjetivo(numero: seleccionEjercicio)
        
        
        
        
    }
    
    @IBAction func PauseButt(_ sender: Any) {
        enPausa = true
        InicioBoton.isHidden = false
        pauseButton.isHidden = true
        cronometro.invalidate()
        FinalizarBoton.isHidden = false
    }
    
    
    @IBAction func FinalizarButt(_ sender: Any) {
        /*Se guardan todos los valores:
        - generar un diccionario de tiempo por kilometro se guardara el tiempo mas bajo y el tiempo mas alto */
       enFuncionamiento = false
       cronometro.invalidate()
       enPausa = true
       
        
        
    }
    
    @objc func UpdateTimer(){
         contador += 1
         segundos += 1
        if(contador % 60 == 0){
            segundos = 0
            minutos += 1
            if(minutos % 60 == 0){
                minutos = 0
                horas += 1
                
            }
            
            
        }
        
           
        
        
        
         
         horaslbl.text = String (format: "%.2d : %.2d : %.2d",horas, minutos,segundos)
    }
    
    
    }

    
    
    
    
    
    
    





    
extension MapaViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let miLocalizacion = locations.last else {return}
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(miLocalizacion.coordinate.latitude,  miLocalizacion.coordinate.longitude )

        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        mapa.setRegion(region, animated:true)
        
        
        
       
        if (!enPausa ){
            
            if (ArrayPuntos .isEmpty){
            }
            else{
                puntoAnterior = MKMapPoint(((ArrayPuntos.last ?? nil)!))
                let puntoActual: MKMapPoint = MKMapPoint(myLocation)
                let distanciaRecorrida = puntoAnterior!.distance(to: puntoActual)
                KMTotales += distanciaRecorrida
                var aSuperar = Double(objetivo)!*1000
                if (aSuperar < KMTotales){
                    textoObjetivo.text = "El objetivo de " + objetivo + " Km ha sido superado"
                }
            }
                ArrayPuntos.append(myLocation)
                ruta = MKPolyline(coordinates: ArrayPuntos, count:  ArrayPuntos.count)
                mapa.addOverlay(ruta!)
                self.kmContadorlbl.text = String(format: "%.03f", KMTotales/1000)
            
            
        }else{
            if (enFuncionamiento && !ArrayPuntos.isEmpty){
                rutaFinal.append(ArrayPuntos)
                ArrayPuntos.removeAll()
            }
            
    
}
}
}


extension MapaViewController:MKMapViewDelegate{
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


    
        
        
    




