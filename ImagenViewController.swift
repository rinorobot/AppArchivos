//
//  ImagenViewController.swift
//  AppArchivos
//
//  Created by Salvador Gómez Moya on 26/05/22.
//

import UIKit
import Network



class ImagenViewController: UIViewController{
    
    var a_i = UIActivityIndicatorView()
    @IBOutlet weak var imagen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = InternetStatus.instance
        a_i.style = .large
        a_i.color = .red
        a_i.hidesWhenStopped = true
        a_i.center = self.view.center
    
        cargaImagenLocal()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        a_i.startAnimating()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Tipo de conexión: \(InternetStatus.instance.internetType)")
        
    }
    
    func cargaImagenLocal () {
            //Ruta de la carpeta
            let urlDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let ruta = urlDocuments?.appendingPathComponent("geo_vertical.jpg")
            //Si existe el archivo
        
       
       
        if FileManager.default.fileExists(atPath: ruta!.path){
            a_i.stopAnimating()
                do{
                    //Si existe cargamos la imagen
                    
                    let bytes = try Data(contentsOf: ruta!)
                   
                    let imagen = UIImage(data: bytes)
                    self.imagen.image = imagen
                    
                    print("La imagen existe en \(ruta!)")
                  
                }catch{
                    print("No funcionó la carga de la imagen local")
                    print(error.localizedDescription)
                }
                
               
            }
            //Si no existe
        else{
            self.view.addSubview(a_i)
            if InternetStatus.instance.internetType == .none {
                let alert = UIAlertController(title: "No hay conexión", message: "No hay archivo local y no hay internet", preferredStyle: .alert)
                let boton = UIAlertAction(title: "Ok", style: .default) { alert in
                    self.a_i.stopAnimating()
                }
                alert.addAction(boton)
                self.present(alert, animated:true)
            }
            else if InternetStatus.instance.internetType == .cellular {
                let alert = UIAlertController(title: "Confirme por favor", message: "Solo hay conexión a internet por datos celulares", preferredStyle: .alert)
                let boton1 = UIAlertAction(title: "Continuar", style: .default) { alert in
                    self.descargar()
                }
                let boton2 = UIAlertAction(title: "Cancelar", style: .cancel)
                alert.addAction(boton1)
                alert.addAction(boton2)
                self.present(alert, animated:true)
            } else if InternetStatus.instance.internetType == .wifi{
                let alert = UIAlertController(title: "Buena conexión", message: "Estás conectado a wifi", preferredStyle: .alert)
                
                let boton = UIAlertAction(title: "OK", style: .default){
                    alert in
                    self.descargar()
                }
                alert.addAction(boton)
                self.present(alert, animated: true)
                
            }
            else {
                self.descargar()
            }
            
            
        }
       
        
       
      
            }

    
    func descargar() {
        let urlDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            print("La imagen no existe")
               
            
            
            
            
            let urlString = "http://janzelaznog.com/DDAM/iOS/vim/geo_vertical.jpg"
            
          
          
                guard let url = URL(string: urlString) else {
                    print("El link no está bien")
                    return
                 
                }
                
                URLSession.shared.downloadTask(with: url){fileURL, response, error in
                    if let error = error {
                        print("El error es: \(error.localizedDescription) ")
                    }else{
                        print("El archivo de descargó en: \(fileURL?.path)")
                        print("El archivo se guardó en: \(urlDocuments?.path)")
                        let manager = FileManager()
                        let imagenUrl = urlDocuments?.appendingPathComponent("geo_vertical.jpg")
                        if let nsdata = NSData(contentsOf: (fileURL!) as URL){
                            
                            DispatchQueue.main.async {
                                self.imagen.image = UIImage(data: nsdata as Data)
                                
                                self.a_i.stopAnimating()
                            }
                            
                            let dataImage = UIImage(data: nsdata as Data)!.jpegData(compressionQuality: 1)
                            
                            manager.createFile(atPath: imagenUrl!.path, contents:  dataImage, attributes: [FileAttributeKey.creationDate: Date()])
                                  }
                   
                    }
                    
                }.resume()
         
    }
  
       

}
