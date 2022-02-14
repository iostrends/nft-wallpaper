//
//  PreviewVC.swift
//  NFT Wallpaper
//
//  Created by Mac on 13/02/2022.
//

import UIKit
import AVFoundation
import Photos


class PreviewVC: UIViewController {

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var anime: UIView!
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.anime.bounds
        self.loopVideo(videoPlayer: player)
        self.anime.layer.addSublayer(playerLayer)
        player.play()
        downloadButton.layer.cornerRadius = downloadButton.frame.height/2

    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func download(_ sender: Any) {
        self.downloadVideo(url: url)
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    func downloadVideo(url:String){
        let videoImageUrl = url

        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: videoImageUrl),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFile.mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            print("Video is saved!")
                            
                            DispatchQueue.main.async {
                                let refreshAlert = UIAlertController(title: "", message: "Video saved successfully.", preferredStyle: UIAlertController.Style.alert)

                                refreshAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
                                      print("Handle Cancel Logic here")
                                }))

                                self.present(refreshAlert, animated: true, completion: nil)
                            }
                         
                        }
                    }
                }
            }
        }
    }

}
