import UIKit
import Foundation

class RepositoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var repositories = [Repository]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        repositories = GitHubApiManager.sharedInstance.getRepository()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let repositor = GitHubApiManager.sharedInstance.getRepository()
        return repositor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RepositoryTableViewCell()
        cell.author.text = repositories[indexPath.row].name
        return cell
    }
    
    
    

}
