//
//  PacoteViagemDAO.swift
//  Alura Viagens
//
//  Created by Igor Meira on 20/02/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import CoreData

class PacoteViagemDAO: NSObject {
    
    //MARK: - Variables
    
    var gerenciadorDeResultados:NSFetchedResultsController<Pacote>?
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //MARK: - Methods
    
    func recuperaPacotes() -> (pacoteViagem: Array<PacoteViagem>, pacote: Array<Pacote>) {
        let pesquisaPacote:NSFetchRequest<Pacote> = Pacote.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "titulo", ascending: true)
        pesquisaPacote.sortDescriptors = [ordenaPorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaPacote, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let listaDePacotes = gerenciadorDeResultados?.fetchedObjects else { return ([], []) }
        let listaDePacoteViagens = recuperaPacoteViagens(listaDePacotes)
        
        return (listaDePacoteViagens, listaDePacotes)
    }
    
    func recuperaPacoteViagens(_ listaDePacotes : Array<Pacote>) -> Array<PacoteViagem> {
        var pacotes : Array<PacoteViagem> = []
        
        for pacote in listaDePacotes {
            let viagem = Viagem(titulo: pacote.titulo!, quantidadeDeDias: Int(pacote.quantidadeDeDias), preco: pacote.preco!, caminhoDaImagem: pacote.caminhoDaImagem!, localizacao: pacote.localizacao!)
            let pacoteViagem = PacoteViagem(nomeDoHotel: pacote.nomeDoHotel!, descricao: pacote.descricao!, dataViagem: pacote.dataViagem!, viagem: viagem)
            pacotes.append(pacoteViagem)
        }
        
        return pacotes
    }
    
    func salvaPcote(dicionarioDePacote:Dictionary<String, Any>) {
        var pacote:NSManagedObject?
        
        let entidade = NSEntityDescription.entity(forEntityName: "Pacote", in: contexto)
        pacote = NSManagedObject(entity: entidade!, insertInto: contexto)
        
        pacote?.setValue(dicionarioDePacote["caminhoDaImagem"] as? String, forKey: "caminhoDaImagem")
        pacote?.setValue(dicionarioDePacote["dataViagem"] as? String, forKey: "dataViagem")
        pacote?.setValue(dicionarioDePacote["descricao"] as? String, forKey: "descricao")
        pacote?.setValue(dicionarioDePacote["localizacao"] as? String, forKey: "localizacao")
        pacote?.setValue(dicionarioDePacote["nomeDoHotel"] as? String, forKey: "nomeDoHotel")
        pacote?.setValue(dicionarioDePacote["preco"] as? String, forKey: "preco")
        pacote?.setValue(dicionarioDePacote["titulo"] as? String, forKey: "titulo")
        
        guard let dias = dicionarioDePacote["quantidadeDeDias"] else { return }
        
        if (dias is String) {
            pacote?.setValue((dicionarioDePacote["quantidadeDeDias"] as! NSString).intValue, forKey: "quantidadeDeDias")
        }
        else {
            let conversaoDeDias = String(describing: dias)
            pacote?.setValue((conversaoDeDias as NSString).intValue, forKey: "quantidadeDeDias")
        }
        atualizaContexto()
    }
    
    func deletaPacote(_ pacoteViagem:PacoteViagem) {
        let pacotes = self.recuperaPacotes().pacote
        for pacote in pacotes {
            if (pacote.nomeDoHotel == pacoteViagem.nomeDoHotel) && (pacote.descricao == pacoteViagem.descricao) && (pacote.dataViagem == pacoteViagem.dataViagem) {
                contexto.delete(pacote)
                break
            }
        }
        atualizaContexto()
    }
    
    func atualizaContexto() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
