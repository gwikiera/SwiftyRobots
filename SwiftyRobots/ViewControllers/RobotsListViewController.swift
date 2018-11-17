/*
 * Created by Grzegorz Wikiera on 05.02.2018.
 * Copyright (c) 2018 Grzegorz Wikiera <gwikiera@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

final class RobotsListViewController: UITableViewController {
    let dataManager = RobotsDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRobotButtonTapped(_:)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "RobotDetails", let detailsViewController = segue.destination as? RobotDetailsViewController, let robotIndex = tableView.indexPathForSelectedRow?.row {
            let robot = dataManager.robots[robotIndex]
            detailsViewController.robot = robot
        }
    }
}

private extension RobotsListViewController {
    @objc func addRobotButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Generate a new robot!", message: "Type any text to generate a new robot. Robots lovingly delivered by Robohash.org.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert, weak self] (_) in
            guard let text = alert?.textFields?.first?.text else { return }
            self?.getRobot(for: text)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getRobot(for text: String) {
        dataManager.fetchRobot(for: text, completion: { [weak self] _ in
            self?.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
}

extension RobotsListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.robots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError()
        }
        
        let robot = dataManager.robots[indexPath.row]
        cell.textLabel?.text = robot.name
        cell.imageView?.image = UIImage(contentsOfFile: robot.imagePath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension RobotsListViewController {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let robot = dataManager.robots[indexPath.row]
        dataManager.removeRobot(robot)
        tableView.reloadData()
    }
}
