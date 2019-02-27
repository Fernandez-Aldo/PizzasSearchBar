//
//  Pizza.swift
//  Day4TableView
//
//  Created by Kevin Yu on 2/25/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

// NeXTSTEP
// (NS)KeyArchiver

// To use NSKeyArchiver, we need to
// 1. subclass NSObject
// 2. adopt NSCoding
// (optionally) 3. adopt NSSecureCoding (for iOS 12+)
class Pizza: NSObject, NSCoding, NSSecureCoding {
    
    // define a static file to save data to
    static let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("favorites")
    
    // NSSecureCoding
    static var supportsSecureCoding = true
    
    // MARK: - Properties
    
    var toppings: [String]
    var price: Int?
    var favorite: Bool
    
    init(toppings: [String], price: Int? = 0) {
        self.toppings = toppings
        self.price = price
        self.favorite = false
    }
    
    // MARK: - NSCoding
    
    // decode data from NSCoder
    // call decodeObjectForKey:
    // keys should be consistent for encoding&decoding
    required init?(coder aDecoder: NSCoder) {
        if let toppings = aDecoder.decodeObject(forKey: "toppings") as? [String] {
            self.toppings = toppings
        }
        else {
            self.toppings = []
        }
        
        // optionals are not plains Ints, decode as Object
        self.price = aDecoder.decodeObject(forKey: "price") as! Int?
        self.favorite = aDecoder.decodeBool(forKey: "favorite")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(toppings, forKey: "toppings")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(favorite, forKey: "favorite")
    }
    
    /// MARK: - Class functions for saving
    
    // note:
    // class - method you can use without an instance
    // static - same as class, but you can't override it
    
    class func savePizzas(_ pizzas: [Pizza]) {
        do {
            // transform objects into Data
            let data = try NSKeyedArchiver.archivedData(withRootObject: pizzas,
                                                        requiringSecureCoding: true)
            
            // save Data to a file
            try! data.write(to: Pizza.filePath)
        }
        catch {
            // print an error if there is one
            print(error)
        }
    }
    
    class func loadPizzas() -> [Pizza] {
        // read Data from a file
        var pizzas: [Pizza] = []
        guard let pizzaData = try? Data.init(contentsOf: Pizza.filePath) else {
            return []
        }
        do {
            // transform Data into Objects
            // new in iOS 12: need to state types of data inside
            pizzas = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, Pizza.self],
                                                            from: pizzaData) as! [Pizza]
        }
        catch {
            print(error)
        }
        return pizzas
    }
    
}
