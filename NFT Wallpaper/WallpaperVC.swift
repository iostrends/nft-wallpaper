//
//  WallpaperVC.swift
//  NFT Wallpaper
//
//  Created by Mac on 13/02/2022.
//

import UIKit
import Lottie
import AVFoundation
import MBProgressHUD

class WallpaperVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    var address:String? = ""

    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var addressText: UITextField!
    
    let defaultData = UserDefaults.standard.dictionary(forKey: "data")
    var data = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
//        loadingNotification.mode = MBProgressHUDMode.indeterminate
//        loadingNotification.label.text = "Loading"
        self.addressText.text = UserDefaults.standard.string(forKey: "address")
        
        if let arr = defaultData?["data"] as? [[String:Any]]{
            self.data = arr
        }
        
        walletView.layer.cornerRadius = walletView.frame.height/2

        backView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 70)
        
        collection.register(UINib(nibName: "WallpaperCell", bundle: nil), forCellWithReuseIdentifier: "WallpaperCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
       
        let index = data[indexPath.row]
        let clock = index["clock"] as! String
        let name = index["name"] as! String
        let animation_time = index["animation_time"] as! [String:Any]
        let hour = animation_time["hour"] as! Int
        let minue = animation_time["minue"] as! Int
        
        let videoURL = URL(string: clock)
        let player = AVPlayer(url: videoURL!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cell.anime.bounds
        cell.anime.layer.addSublayer(playerLayer)
        cell.name.text = name
        cell.time.text = "\(hour):\(minue)"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      //  let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (20) + (20) + (20)
        let size:CGFloat = (collection.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size+(size/1.5))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "PreviewVC") as! PreviewVC
        let index = data[indexPath.row]
        let clock = index["clock"] as! String
        controller.url = clock
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "", message: "Do you really want to logout.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.set(false, forKey: "login")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "nav")
            newViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.present(newViewController, animated: true, completion: nil)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
       
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
