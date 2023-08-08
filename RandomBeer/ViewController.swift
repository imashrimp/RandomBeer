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
        
        callRequest()

    }
    
    
    @IBAction func showBeerButtonTapped(_ sender: UIButton) {
        callRequest()
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
    
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let imageString = json[0]["image_url"].stringValue
                if let imageUrl = URL(string: imageString) {
                    self.beerImageView.kf.setImage(with: imageUrl)
                } else {
                    self.beerImageView.image = UIImage(systemName: "wineglass.fill")
                }
                
                guard let imageUrl = URL(string: imageString) else {
                    return self.beerImageView.image = UIImage(systemName: "wineglass.fill")
                }
                self.beerImageView.kf.setImage(with: imageUrl)
                
                let name = json[0]["name"].stringValue
                let description = json[0]["description"].stringValue
                
                self.beerNameLabel.text = "맥주 이름: \(name)"
                self.descriptionLabel.text = "맛 설명: \(description)"
                
                print(name, description)
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showImage(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.beerImageView.image = image
                    }
                }
            }
        }
    }
    
    

}

