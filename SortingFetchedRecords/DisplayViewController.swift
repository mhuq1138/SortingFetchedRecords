//
//  DisplayViewController.swift
//  FetchRequestInFourWays
//
//  Created by Mazharul Huq on 2/24/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class DisplayViewController: UITableViewController {
    
    @IBOutlet var headerLabel: UILabel!
    
    var coreDataStack:CoreDataStack!
    
    var sortOption = 0
    var countries:[Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.coreDataStack = CoreDataStack(modelName: "CountryList")
    
        self.tableView.rowHeight = 70.0
    
        let fetchRequest:NSFetchRequest<Country> = Country.fetchRequest()
        if let sort = getSortType(sortOption){
            fetchRequest.sortDescriptors = [sort]
            self.headerLabel.text = String(describing: sort)
        }
        do{
            countries = try coreDataStack.managedContext.fetch(fetchRequest)
        }
        catch
            let nserror  as NSError{
                print("Could not save \(nserror),(nserror.userInfo)")
        }
    }
    
    
    func getSortType(_ option:Int)-> NSSortDescriptor?{
        var sort:NSSortDescriptor?
        switch option{
        case 0:
            sort = NSSortDescriptor(key: "name", ascending: true)
        case 1:
            sort  = NSSortDescriptor(key: "capital", ascending: false)
        case 2:
            sort = NSSortDescriptor(key: "population", ascending: true)
        case 3:
            sort = NSSortDescriptor(key: "area", ascending: false)
        default:
            break
        }
        return sort
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let country = countries[indexPath.row]
        var nameString = ""
        var capitalString = ""
        
        if let name = country.name{
            nameString = name
        }
        if let capital = country.capital{
            capitalString = "Capital: \(capital)"
        }

        cell.textLabel?.text = nameString + " " + capitalString
        cell.detailTextLabel?.text = """
        Area: \(country.area) sq mi
        Population: \(country.population) millions
        """
        return cell
    }
}
