import p2_OAuth2
import Alamofire

class GitHubApiManager {
    
    static let sharedInstance = GitHubApiManager()
    
    fileprivate var alomofireManager = SessionManager()
    var loader: OAuth2DataLoader?
    let oAuth2 = OAuth2CodeGrant(settings: [
        "client_id": "8ae913c685556e73a16f",
        "client_secret": "60d81efcc5293fd1d096854f4eee0764edb2da5d",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",
        "redirect_uris": ["ppoauthapp://oauth/callback"],
        "secret_in_body": true,
        "verbose": true,
        ] as OAuth2JSON)
    
    
    func signin () {
        
        var request = URLRequest(url: URL(string:"https://api.github.com/user")!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        if oAuth2.isAuthorizing {
            oAuth2.abortAuthorization()
            return
        }
        
        oAuth2.authConfig.authorizeEmbedded = false
        let loader = OAuth2DataLoader(oauth2: oAuth2)
        self.loader = loader
        loader.perform(request: request) { (response) in
            do {
                let json = try response.responseJSON()
                debugPrint(json)
            } catch let error {
                self.didCancelOrFail(error)
            }
        }
        
        
        
    }
    
    func getRepository () -> [Repository] {
        var repositories = [Repository]()
        let sessionManager = SessionManager()
        let retrier = OAuth2RetryHandler(oauth2: oAuth2)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        alomofireManager = sessionManager
        
        
        
        sessionManager.request("https://api.github.com/user/repos")
            .validate()
            .responseJSON { response in
                print(response.result.value)
                if let json = response.result.value as? [String: AnyObject] {
                    if let name = json["name"] as? String {
                        repositories.append(Repository(name: name))
                    }
                }
                
        }
        return repositories
    }
    
    
    
    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
        }
    }
    
}

