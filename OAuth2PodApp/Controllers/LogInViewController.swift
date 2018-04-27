import UIKit

class LogInViewController: UIViewController {
    @IBOutlet var signIn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        signIn.isHidden = true
        if GitHubApiManager.sharedInstance.oAuth2.accessToken != nil {
            performSegue(withIdentifier: "ShowRepository", sender: nil)
        }
        else {
            signIn.isHidden = false
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        GitHubApiManager.sharedInstance.signin()
        performSegue(withIdentifier: "ShowRepository", sender: nil)
    }

    @IBAction func getrepos(_ sender: Any) {
        print(GitHubApiManager.sharedInstance.getRepository())
    }
    
}
