//
//  PacotesCollectionViewCell.swift
//  Alura Viagens
//
//  Created by Alura on 21/06/18.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PacotesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imagemViagem: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelQuantidadeDias: UILabel!
    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var star: UIButton!
    
    //MARK: - Variables
    
    var pacote : PacoteViagem?
    
    // MARK: - Métodos
    
    func configuraCelula(_ pacoteViagem: PacoteViagem, favoritado: Bool) {
        self.pacote = pacoteViagem
        labelTitulo.text = pacoteViagem.viagem.titulo
        labelQuantidadeDias.text = "\(pacoteViagem.viagem.quantidadeDeDias) dias"
        labelPreco.text = "R$ \(pacoteViagem.viagem.preco)"
        
        Alamofire.request(pacoteViagem.viagem.caminhoDaImagem).responseImage { response in
            if let image = response.result.value {
                self.imagemViagem.image = image
            }
        }
        if favoritado {
            star.setImage(UIImage(named: "full_star"), for: .normal)
        }
        else {
            star.setImage(UIImage(named: "empty_star"), for: .normal)
        }
        star.addTarget(self, action: #selector(favoritar(_:)) , for: .touchUpInside)
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1).cgColor
        layer.cornerRadius = 8
    }
    
    @objc func favoritar(_ sender: UIButton) {
        switch star.currentImage {
        case UIImage(named: "full_star"):
            star.setImage(UIImage(named: "empty_star"), for: .normal)
            guard let pacoteViagem = pacote else {break}
            PacoteViagemDAO().deletaPacote(pacoteViagem)
        default:
            star.setImage(UIImage(named: "full_star"), for: .normal)
            guard let pacoteViagem = pacote else {break}
            let dicionarioPacote : Dictionary<String, Any> = [
                "caminhoDaImagem" : pacoteViagem.viagem.caminhoDaImagem,
                "dataViagem" : pacoteViagem.dataViagem,
                "descricao" : pacoteViagem.descricao,
                "localizacao" : pacoteViagem.viagem.localizacao,
                "nomeDoHotel" : pacoteViagem.nomeDoHotel,
                "preco" : pacoteViagem.viagem.preco,
                "titulo" : pacoteViagem.viagem.titulo,
                "quantidadeDeDias" : pacoteViagem.viagem.quantidadeDeDias
            ]
            PacoteViagemDAO().salvaPcote(dicionarioDePacote: dicionarioPacote)
        }
    }
}
