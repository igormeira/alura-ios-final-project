//
//  ViagemAPI.swift
//  Alura Viagens
//
//  Created by Igor Meira on 19/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import Foundation
import Alamofire

class ViagemAPI: NSObject {
    
    //MARK: - GET
    
    func getViagens (completion:@escaping(_ listaViagens:Array<Viagem>) -> Void) {
        var listaViagens : Array<Viagem> = []
        Alamofire.request("https://backend-formacao.herokuapp.com/viagens", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let resposta = response.result.value as? Array<Dictionary<String, Any>> {
                    for viagemAtual in resposta {
                        let viagem = Viagem(titulo: viagemAtual["titulo"] as! String, quantidadeDeDias: viagemAtual["quantidadeDeDias"] as! Int, preco: viagemAtual["preco"] as! String, caminhoDaImagem: viagemAtual["imageUrl"] as! String, localizacao: viagemAtual["localizacao"] as! String)
                        listaViagens.append(viagem)
                    }
                    completion(listaViagens)
                }
                break
            case .failure:
                print(response.error!)
                completion(listaViagens)
                break
            }
        }
    }
    
}
