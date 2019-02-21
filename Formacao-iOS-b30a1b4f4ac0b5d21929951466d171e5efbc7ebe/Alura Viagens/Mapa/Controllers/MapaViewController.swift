//
//  MapaViewController.swift
//  Alura Viagens
//
//  Created by Igor Meira on 19/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK: - Variables
    
    var viagem:Viagem?
    lazy var localizacao = Localizacao()
    lazy var gerenciadorDeLocalizacao = CLLocationManager()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo()
        verificaAutorizacaoDoUsuario()
        self.localizarViagem()
        mapa.delegate = localizacao
        gerenciadorDeLocalizacao.delegate = self
    }
    
    // MARK: - Methods
    
    func getTitulo() -> String {
        return "Localizar Cidade"
    }
    
    func verificaAutorizacaoDoUsuario() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
                mapa.addSubview(botao)
                gerenciadorDeLocalizacao.startUpdatingLocation()
                break
            case .notDetermined:
                gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
                break
                
            case .denied:
                
                break
            default:
                break
            }
        }
    }
    
    func localizarViagem() {
        if let viagem = self.viagem {
            Localizacao().converteEnderecoEmCoordenadas(endereco: viagem.localizacao, local: { (localizacaoEncontrada) in
                let pino = Localizacao().configuraPino(titulo: viagem.localizacao, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
                let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 1000000, 1000000)
                self.mapa.setRegion(regiao, animated: true)
                self.mapa.addAnnotation(pino)
            })
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
            mapa.addSubview(botao)
            gerenciadorDeLocalizacao.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    //MARK: - Actions
    
    @IBAction func back(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
}
