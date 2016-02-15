//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Shakeel Daswani on 2/8/16.
//  Copyright © 2016 Shakeel Daswani. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
   
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.title = "Movie Details"
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width
            , infoView.frame.origin.y + infoView.frame.size.height)
        
        
        
        let title = movie["title"] as? String
        titleLabel.text = title
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        overviewLabel.sizeToFit()

        
        
        let baseUrl = "http://image.tmdb.org/t/p/w45"
        let lowbaseUrl = "http://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as? String
        
        let smallImageRequest = NSURLRequest(URL: NSURL(string: baseUrl + posterPath!)!)
        let largeImageRequest = NSURLRequest(URL: NSURL(string: lowbaseUrl + posterPath!)!)
        
        self.posterImageView.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage;
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.posterImageView.alpha = 1.0
                    
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.posterImageView.setImageWithURLRequest(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.posterImageView.image = largeImage;
                                
                            },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                })
            },
            failure: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })


     //if let posterPath = movie["poster_path"] as? String {
       //    let imageUrl = NSURL(string: baseUrl + posterPath)
         //  posterImageView.setImageWithURL(imageUrl!)
//  }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
