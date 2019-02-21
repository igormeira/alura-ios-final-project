//
//  FavoritosCollectionViewCell.swift
//  Alura Viagens
//
//  Created by Igor Meira on 21/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FavoritosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagemViagemFavoritos: UIImageView!
    @IBOutlet weak var labelTituloFavoritos: UILabel!
    @IBOutlet weak var labelQuantidadeDiasFavoritos: UILabel!
    @IBOutlet weak var labelPrecoFavoritos: UILabel!
    
    
    func configuraCelulaFavoritos(_ pacoteViagem: PacoteViagem) {
        labelTituloFavoritos.text = pacoteViagem.viagem.titulo
        labelQuantidadeDiasFavoritos.text = "\(pacoteViagem.viagem.quantidadeDeDias) dias"
        labelPrecoFavoritos.text = "R$ \(pacoteViagem.viagem.preco)"
        
        Alamofire.request(pacoteViagem.viagem.caminhoDaImagem).responseImage { response in
            if let image = response.result.value {
                self.imagemViagemFavoritos.image = image
            }
        }
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1).cgColor
        layer.cornerRadius = 8
    }
    
}
