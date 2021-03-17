//
//  ModelSeriesViewController.swift
//  StreetMerchantBot
//
//  Created by Paul Ancajima on 3/16/21.
//

import UIKit

struct Series {
    let series: String
    let checked: Bool
}

class ModelSeriesViewController: UIViewController {

    var series = [String:Series]()
    var seriesKeys = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getSeries{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func getSeries(completion: @escaping ()->()) {
        let url = URL(string: Constants.shared.hostGetModelSeries)!
        var request = URLRequest(url: url)
        request.addValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "x-access-token")

        URLSession(configuration: .default).dataTask(with: request) { (data,response,error) in
            
            if error != nil {
                print("error occurred, \(error.debugDescription)")
                return
            }
            
            guard let data = data else { return }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            
            do {
                let array = try JSONSerialization.jsonObject(with: data, options: []) as! [String]
                
                let checkedSeries = UserDefaults.standard.array(forKey: "showOnlySeries") as! [String]
                
                for series in array {
                    self.series[series] = Series(series: series, checked: false)
                }
                
                for series in checkedSeries {
                    self.series[series] = Series(series: series, checked: true)
                }
                self.seriesKeys = Array(self.series.keys)
                
                
                completion()
            } catch {
                print("error: ", error)
            }
        }.resume()
    }

}

extension ModelSeriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let _series = series[seriesKeys[indexPath.row]] else {
            return cell
        }
        cell.textLabel?.text = "\(_series.series), \(_series.checked)"
        return cell
    }
    
    
}
