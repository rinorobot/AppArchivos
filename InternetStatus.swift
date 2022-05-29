//
//  InternetStatus.swift
//  AppArchivos
//
//  Created by Salvador Gómez Moya on 26/05/22.
//
import Network

enum InternetType {
    case none
    case cellular
    case wifi
}

class InternetStatus: NSObject {
    //////////////// Implementación Singleton
    static let instance = InternetStatus()
    private override init() {
        super.init()
        monitoring()
    }
    /////////////////////
    var internetType: InternetType = .none
    
    private func monitoring() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                self.internetType = .none
            }
            else {
                if path.usesInterfaceType(.wifi) {
                    self.internetType = .wifi
                }
                else if path.usesInterfaceType(.cellular) {
                    self.internetType = .cellular
                }
            }
        }
        // El queue global, se utiliza para ejecutar cualquier cosa en background mientras no necesitemos mayores recursos
        monitor.start(queue: DispatchQueue.global())
    }
}
