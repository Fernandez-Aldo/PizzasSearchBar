//
//  KrustyKrabViewController.swift
//  Day4TableView
//
//  Created by Kevin Yu on 2/25/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

// JSON: JavaScript Object Notation

import UIKit

class KrustyKrabViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var sliderLabel: UILabel!
    @IBOutlet var loadButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!

    var tableView: UITableView!
    
    var bikiniBottomers = ["SpongeBob", "Sandy", "Patrick", "Plankton", "Mr. Krabs"]
    var imageNames = ["sponebob.jpg", "sandy.jpeg", "patrick.png", "plankton.jpg", "mrkrabs.png"]
    
    var favoritePizzas = [Pizza]()
    var pizzas = [Pizza]()
    //Create the new array to search for pizza
    var searchPizza = [Pizza]()
    
    override func loadView() {
        super.loadView()

        // create a tableView
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        // create constraints
        let topConstraint = NSLayoutConstraint(item: tableView, attribute: .top,
                                               relatedBy: .equal,
                                               toItem: stackView, attribute: .bottom,
                                               multiplier: 1.0, constant: 8.0)
        // nts: figure out what the 0.5 does.
        let leadingConstraint = NSLayoutConstraint(item: self.view, attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: tableView, attribute: .leading,
                                                   multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self.view, attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: tableView, attribute: .trailing,
                                                    multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: tableView, attribute: .bottom,
                                                  multiplier: 1.0, constant: 0.0)
        // activate constraints
        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // nib = NeXTSTEP Interface Builder file
        let nib = UINib(nibName: "BikiniBottomerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BikiniBottomerTableViewCell")
        
        let nib2 = UINib(nibName: "PizzaTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "PizzaTableViewCell")
        
        
        loadButton.addTarget(self,
                             action: #selector(loadButtonAction),
                             for: .touchUpInside)
        
        slider.addTarget(self,
                         action: #selector(sliderAction(_:)),
                         for: .valueChanged)
        slider.isEnabled = false
    }
    
    @objc func sliderAction(_ sender: UISlider) {
        // update the label
        sliderLabel.text = String(Int(sender.value))
        // update the tableView
        tableView.reloadData()
    }
    
    @objc func loadButtonAction() {
        // load the JSON file as Data
        var tempPizzas = Pizza.loadPizzas()
        if tempPizzas.count == 0 {
            let bundle = Bundle.main
            let jsonPath = bundle.path(forResource: "pizzas", ofType: "json")
            let jsonURL = URL(fileURLWithPath: jsonPath!)
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                
                let jsonDict = try JSONSerialization.jsonObject(with: jsonData,
                                                                options: .mutableLeaves) as! [[String:Any]]
                // create pizzas from the JSON
                for pizzaDict in jsonDict {
                    let toppings = pizzaDict["toppings"] as! [String]
                    let price = pizzaDict["price"] as? Int
                    let pizza = Pizza(toppings: toppings, price: price)
                    
                    // add pizza to container to show in tableView
                    tempPizzas.append(pizza)
                }
            }
            catch {
                print(error)
            }
        }
        
        
        // filter through, get favorites
        favoritePizzas.removeAll()
        pizzas.removeAll()
        for pizza in tempPizzas {
            if pizza.favorite == true {
                favoritePizzas.append(pizza)
            }
            else {
                pizzas.append(pizza)
            }
        }
        
        slider.minimumValue = 0.0
        slider.maximumValue = 20.0 // Float(pizzas.count)
        slider.setThumbImage(UIImage(named: "tinyPatty.png"), for: .normal)
        slider.value = 20.0
        sliderLabel.text = String(Int(slider.value))
        slider.isEnabled = true
        
        // put pizzas in tableView
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
/*
 IndexPath = two parts: section & row
 // examples: News Site
 SECTION A  (category)
    -> ROW 1    (items within category)
    -> ROW 2
    -> ROW 3
 SECTION B      (POLITICS)
    -> ROW 1
    -> ROW 2
 SECTION C      (SPORTS)
    -> ROW 1    (NBA)
    -> ROW 2    (NFL)
    -> ROW 3    (LoL)
    -> ROW 4
 SECTION D (no rows)
 SECTION E      (ENTERTAINMENT)
*/
extension KrustyKrabViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return favoritePizzas.count
        }
        else if section == 3 {
            let val = Int(slider.value)
            return (val >= pizzas.count) ? pizzas.count : val
        }
        return 0 // bikiniBottomers.count
    }
    // customize each cell (item)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            // get a cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            // customize my cell
            cell.textLabel?.text = bikiniBottomers[indexPath.row]
            cell.imageView?.image = UIImage(named: imageNames[indexPath.row])
            
            // return cell
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BikiniBottomerTableViewCell", for: indexPath) as! BikiniBottomerTableViewCell
            
            cell.label.text = bikiniBottomers[indexPath.row]
            cell.imageV.image = UIImage(named: imageNames[indexPath.row])
            
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaTableViewCell", for: indexPath) as! PizzaTableViewCell
            
            let pizza = favoritePizzas[indexPath.row]
            cell.label.text = pizza.toppings.joined(separator: "\n")
            cell.isFavorite = pizza.favorite
            cell.index = indexPath.row
            cell.delegate = self
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaTableViewCell", for: indexPath) as! PizzaTableViewCell
            
            let pizza = pizzas[indexPath.row]
            cell.label.text = pizza.toppings.joined(separator: "\n")
            cell.isFavorite = pizza.favorite
            cell.index = indexPath.row + favoritePizzas.count
            cell.delegate = self
            
            return cell
        }
    }
    
}

extension KrustyKrabViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when I select a pizza
        // display a new VC
        // with labels displaying
        // the toppings
        
        // if the toppings include pepperoni, also display a custom image
        // otherwise, just show the labels
        
        
    }
    
}

extension KrustyKrabViewController: MakeFavoriteProtocol {
    func toggle(at index: Int) {
        var pizza: Pizza! = nil
        var indexPath: IndexPath! = nil
        var i = 0
        if index < favoritePizzas.count {
            i = index
            pizza = favoritePizzas[i]
            indexPath = IndexPath(row: i, section: 2)
        }
        else {
            i = index - favoritePizzas.count
            pizza = pizzas[i]
            indexPath = IndexPath(row: i, section: 3)
        }
        let last = pizza.favorite
        pizza.favorite.toggle()
        
        if last == false {
            // remove from pizza, add into favorite
            favoritePizzas.append(pizza)
            pizzas.remove(at: i)
        }
        else {
            // remove from favorite, add into pizza
            pizzas.insert(pizza, at: 0)
            favoritePizzas.remove(at: i)
        }
        
        Pizza.savePizzas(favoritePizzas + pizzas)
        // tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
}

//extension KrustyKrabViewController: UISearchBarDelegate{
    //func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //searchPizza = pizzas.filter { $0.contains(_, other: searchBar.text)}
        //tableView.reloadData()
        
    //}
//}
