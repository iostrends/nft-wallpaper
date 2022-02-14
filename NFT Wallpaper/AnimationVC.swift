//
//  AnimationVC.swift
//  NFT Wallpaper
//
//  Created by Mac on 13/02/2022.
//

import UIKit
import Lottie

class AnimationVC: UIViewController {

    @IBOutlet weak var anime: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anime.loopMode = .loop
        anime.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let controller = story.instantiateViewController(identifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    

  
}
