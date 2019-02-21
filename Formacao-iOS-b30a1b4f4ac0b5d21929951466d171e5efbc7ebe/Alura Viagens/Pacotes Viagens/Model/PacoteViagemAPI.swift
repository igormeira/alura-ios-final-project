//
//  PacoteViagemAPI.swift
//  Alura Viagens
//
//  Created by Igor Meira on 19/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import Foundation
import Alamofire

class PacoteViagemAPI: NSObject {
    
    //MARK: - GET
    
    func getPacotes (completion:@escaping(_ listaViagens:Array<PacoteViagem>) -> Void) {
        var listaPacotes : Array<PacoteViagem> = []
        Alamofire.request("https://backend-formacao.herokuapp.com/pacotes", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                if let resposta = response.result.value as? Array<Dictionary<String, Any>> {
                    for pacoteAtual in resposta {
                        let viagem = Viagem(titulo: pacoteAtual["titulo"] as! String, quantidadeDeDias: pacoteAtual["quantidadeDeDias"] as! Int, preco: pacoteAtual["preco"] as! String, caminhoDaImagem: pacoteAtual["imageUrl"] as! String, localizacao: pacoteAtual["localizacao"] as! String)
                        let pacote = PacoteViagem(nomeDoHotel: pacoteAtual["nomeDoHotel"] as! String, descricao: pacoteAtual["servico"] as! String, dataViagem: pacoteAtual["data"] as! String, viagem: viagem)
                        listaPacotes.append(pacote)
                    }
                    completion(listaPacotes)
                }
                break
            case .failure:
                print(response.error!)
                completion(listaPacotes)
                break
            }
        }
    }
    
}
