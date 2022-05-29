//
//  ExcelViewController.swift
//  AppArchivos
//
//  Created by Salvador Gómez Moya on 28/05/22.
//

import UIKit
import Network
import WebKit
class ExcelViewController: UIViewController, URLSessionDelegate {
    
    
   
    var a_i = UIActivityIndicatorView()
    
    
    
    
    @IBOutlet weak var webview: WKWebView!
    
  
    
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
            let urlDocuments = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            let ruta = urlDocuments?.appendingPathComponent("localidades.xlsx")
            //Si existe el archivo
        
       
       
        if FileManager.default.fileExists(atPath: ruta!.path){
            a_i.stopAnimating()
                do{
                  
                    
                    print("La imagen existe en \(ruta!)")
                    
                    self.webview.loadFileURL(ruta!, allowingReadAccessTo: ruta!)
                  
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
       
            let urlString = "http://janzelaznog.com/DDAM/iOS/vim/localidades.xlsx"
                  
                guard let url = URL(string: urlString) else {
                    print("El link no está bien")
                    return
                 
                }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
       
        
      let downloadTask =  urlSession.downloadTask(with: url)
        
        downloadTask.resume()
        
    }
  
    
    
    

}

extension ExcelViewController: URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Ubicación del archivo guardado \(location)")
        guard let url = downloadTask.originalRequest?.url else{
            return
        }
        
        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
        
        try? FileManager.default.removeItem(at: destinationPath)
        
        do{
            try FileManager.default.copyItem(at: location,to: destinationPath)
         
            
            DispatchQueue.main.async {
         
                self.a_i.stopAnimating()
                print("Ruta para el archivo de excel: \(destinationPath)")
                
                self.webview.loadFileURL(destinationPath, allowingReadAccessTo: destinationPath)
           
                
            }
            
            
            
            
            print("Destination path: \(destinationPath)")
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    
    

}
