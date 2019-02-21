//
//  ViewController.swift
//  Alura Viagens
//
//  Created by Alura on 21/06/18.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tabelaViagens: UITableView!
    @IBOutlet weak var viewHoteis: UIView!
    @IBOutlet weak var viewPacotes: UIView!
    
    // MARK: - Atributos
    
    var listaViagens : Array<Viagem> = []
    var viagemSelecionada : Viagem?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ViagemAPI().getViagens {
            (viagens) in
            self.listaViagens = viagens
            self.tabelaViagens.reloadData()
        }
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapa") {
            let view = segue.destination as! MapaViewController
            view.viagem = self.viagemSelecionada
        }
    }
    
    // MARK: - Métodos
    
    func configuraViews() {
        viewPacotes.layer.cornerRadius = 10
        viewHoteis.layer.cornerRadius = 10
    }
    
    @objc func abrirMapa(_ longPress:UILongPressGestureRecognizer) {
        if longPress.state == .began {
            self.viagemSelecionada = listaViagens[(longPress.view?.tag)!]
            self.performSegue(withIdentifier: "mapa", sender: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaViagens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let viagemAtual = listaViagens[indexPath.row]
        cell.configuraCelula(viagemAtual)
        
        cell.tag = indexPath.row
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirMapa(_:)))
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 175 : 260
    }
}
