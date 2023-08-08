//
//  ViewController.swift
//  RandomBeer
//
//  Created by 권현석 on 2023/08/07.
//

import UIKit

import SwiftyJSON
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    
    
    @IBOutlet var beerImageView: UIImageView!
    @IBOutlet var beerNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var showBeerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        beerImageView.tintColor = .systemBrown
        configureLabel()
        configureButton()
        
        callRequest(imageView: beerImageView, nameLabel: beerNameLabel, introdcueLabel: descriptionLabel)
        
    }
    
    
    @IBAction func showBeerButtonTapped(_ sender: UIButton) {
        
        callRequest(imageView: beerImageView, nameLabel: beerNameLabel, introdcueLabel: descriptionLabel)
    }
    
    func callRequest(imageView: UIImageView, nameLabel: UILabel, introdcueLabel: UILabel) {
        
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print("JSON: \(json)")
                
                let imageString = json[0]["image_url"].stringValue
                let name = json[0]["name"].stringValue
                let description = json[0]["description"].stringValue
                
                nameLabel.text = "맥주 이름: \(name)"
                introdcueLabel.text = "맛 설명: \(description)"
                guard let imageUrl = URL(string: imageString) else {
                    return imageView.image = UIImage(systemName: "wineglass.fill")
                }
                imageView.kf.setImage(with: imageUrl)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureButton() {
        showBeerButton.setTitle("새 맥주 보기", for: .normal)
        showBeerButton.backgroundColor = .systemIndigo
        showBeerButton.setTitleColor(.white, for: .normal)
        showBeerButton.setTitleColor(.systemIndigo, for: .highlighted)
        showBeerButton.layer.cornerRadius = 8
    }
    
    func configureLabel() {
        descriptionLabel.numberOfLines = 0
        beerNameLabel.text = ""
        descriptionLabel.text = ""
    }
}

