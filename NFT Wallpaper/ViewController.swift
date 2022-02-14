//
//  ViewController.swift
//  NFT Wallpaper
//
//  Created by Mac on 13/02/2022.
//

import UIKit
import MBProgressHUD
import Toast_Swift
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var bottoView: UIView!
    @IBOutlet weak var textBackgroung: UIView!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var anime: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anime.loopMode = .loop
        anime.play()
        bottoView.layer.borderColor = UIColor(named: "blue")?.cgColor
        bottoView.layer.borderWidth = 2
        bottoView.layer.cornerRadius = 20
        
        textBackgroung.layer.cornerRadius = textBackgroung.frame.height/2
        
        NextButton.layer.cornerRadius = NextButton.frame.height/2
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func nextText(_ sender: Any) {
        if self.textInput.text != ""{
            request()
        }else{
            self.view.makeToast("Please enter your address")
        }
      
    }
    
    @IBAction func next(_ sender: Any) {
        if self.textInput.text != ""{
            request()
        }else{
            self.view.makeToast("Please enter your address")
        }
    }
    
    func request(){
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
        let text = self.textInput.text ?? ""
        let Url = String(format: "https://testnet.everyminutecounts.io/api/wallet?address=\(text)")
        let serviceUrl = URL(string: Url ?? "")!
      //  let parameterDictionary = ["address" : self.textInput.text ?? ""]
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
          //  guard let httpBody = try? JSONSerialization.data(withJSONObject: [], options: []) else {
         //       return
         //   }
            //request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        let obj = json as? [String:Any]
                        let data = obj?["data"] as? String ?? ""
                   //     print(data)
                        if data == "Not Found"{
                            
                            DispatchQueue.main.async {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.view.makeToast(data)
                            }
                           
                        }else{
                            DispatchQueue.main.async {
                                let story = UIStoryboard(name: "Main", bundle: nil)
                                let controller = story.instantiateViewController(identifier: "WallpaperVC") as! WallpaperVC
                                
                                MBProgressHUD.hide(for: self.view, animated: true)
                                UserDefaults.standard.set(self.textInput.text, forKey: "address")
                                UserDefaults.standard.set(true, forKey: "login")
                                UserDefaults.standard.set(obj, forKey: "data")
                                self.navigationController?.pushViewController(controller, animated: true)
                              }
                        }
                       
                       
                        
                    } catch {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.view.makeToast(error.localizedDescription)
                        print(error)
                    }
                }
            }.resume()
    }
    
}

extension UserDefaults {

    public func optionalInt(forKey defaultName: String) -> Int? {
        let defaults = self
        if let value = defaults.value(forKey: defaultName) {
            return value as? Int
        }
        return nil
    }

    public func optionalBool(forKey defaultName: String) -> Bool? {
        let defaults = self
        if let value = defaults.value(forKey: defaultName) {
            return value as? Bool
        }
        return nil
    }
}

