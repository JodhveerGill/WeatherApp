//
//  weeklyWeatherTableViewController.swift
//  WeatherApp
//
//  Created by Jodhveer Gill on 2019-04-15.
//  Copyright © 2019 Jodhveer Gill. All rights reserved.
//

import UIKit
import CoreLocation

class weeklyWeatherTableViewController: UITableViewController, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    
    var forecastData = [weatherJSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        updateWeather(location: "Toronto")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let location = searchBar.text, !location.isEmpty {
            updateWeather(location: location)
        }
    }
    
    func updateWeather(location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemark: [CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemark?.first?.location {
                    weatherJSON.forecast(withLocation: location.coordinate, completion: {(results: [weatherJSON]?) in
                        if let weatherData = results {
                            self.forecastData = weatherData
                            
                            DispatchQueue.main.sync {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        
        return dateFormatter.string(from: date!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let weatherObject = forecastData[indexPath.section]
        cell.textLabel?.text = weatherObject.summary
        
        let celsius = Int((weatherObject.temperature - 32)*(5/9))
        cell.detailTextLabel?.text = "\(celsius) °C"
        
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
