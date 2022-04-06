//
//  TableViewController.swift
//  CarJournal
//
//  Created by Cheremisin Andrey on 05.04.2022.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    var works: Results<Work>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        self.works = realm.objects(Work.self)
        
    }
    
    
    
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.isEmpty ? 0 : works.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.labelTitle.text = works[indexPath.row].title
        cell.labelDate.text = works[indexPath.row].date
        cell.labelMileage.text = works[indexPath.row].milage
        cell.imageofWork.image = UIImage(data: works[indexPath.row].imageData!)
        
        cell.imageofWork.layer.cornerRadius = cell.imageofWork.frame.size.height / 2
        cell.imageofWork.clipsToBounds = true
        return cell
    }
    
// Сохранение по кнопке
    @IBAction func unwindSegue( _ segue: UIStoryboardSegue) {
        
        guard let newWorkVC = segue.source as? NewWorkViewController else { return }
        newWorkVC.saveNewWork()
        tableView.reloadData()

    }
    
// Удаление файлов из базы
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let realm = try! Realm()
            try! realm.write {
                let work = self.works[indexPath.row]
                realm.delete(work)
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func editWork(_ sender: UIBarButtonItem) {
        let edit = !self.tableView.isEditing
        self.tableView.setEditing(edit, animated: true)
    }
}
