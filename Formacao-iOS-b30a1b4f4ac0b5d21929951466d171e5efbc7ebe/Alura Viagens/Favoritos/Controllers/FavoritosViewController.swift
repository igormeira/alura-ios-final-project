//
//  FavoritosViewController.swift
//  Alura Viagens
//
//  Created by Igor Meira on 20/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class FavoritosViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewColecao: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelNumeroDePacotes: UILabel!
    
    
    // MARK: - Atributos
    
    var listaComTodasViagens: [PacoteViagem] = []
    var listaViagens: [PacoteViagem] = []
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        listaComTodasViagens = PacoteViagemDAO().recuperaPacotes().pacoteViagem
        listaViagens = listaComTodasViagens
        labelNumeroDePacotes.text = atualizaContadorLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.listaComTodasViagens = PacoteViagemDAO().recuperaPacotes().pacoteViagem
        self.listaViagens = self.listaComTodasViagens
        labelNumeroDePacotes.text = atualizaContadorLabel()
        self.viewColecao.reloadData()
    }
    
    // MARK: - Métodos
    
    func atualizaContadorLabel() -> String {
        return listaViagens.count == 1 ? "1 pacote encontrado" : "\(listaViagens.count) pacotes encontrados"
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listaViagens = listaComTodasViagens
        if searchText != "" {
            listaViagens = listaViagens.filter({ $0.viagem.titulo.contains(searchText) })
        }
        labelNumeroDePacotes.text = atualizaContadorLabel()
        viewColecao.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaViagens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celulaPacote = collectionView.dequeueReusableCell(withReuseIdentifier: "celulaFavoritos", for: indexPath) as! FavoritosCollectionViewCell
        let pacoteAtual = listaViagens[indexPath.item]
        celulaPacote.configuraCelulaFavoritos(pacoteAtual)
        
        return celulaPacote
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pacote = listaViagens[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "detalhes") as! DetalhesViagemViewController
        controller.pacoteSelecionado = pacote
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UICollectionViewLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: collectionView.bounds.width/2-20, height: 160) : CGSize(width: collectionView.bounds.width/3-20, height: 250)
    }
}
