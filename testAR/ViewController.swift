//
//  ViewController.swift
//  testAR
//
//  Created by Hugo Lefrant on 09/04/2020.
//  Copyright © 2020 Hugo Lefrant. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    var tricksList:[String] = ["Ollie", "Kickflip"]
    @IBOutlet weak var tricksTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tricksTable.delegate = self
        tricksTable.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toARViewController"{
            if let dest = segue.destination as? ARViewController{
                if let indexPath = self.tricksTable.indexPathForSelectedRow{
                    dest.trick = tricksList[indexPath.row]
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tricksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tricksList[indexPath.row]
        cell.textLabel?.textColor = UIColor.CrewSade.firstColor
        return cell
    }
}

extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toARViewController", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
