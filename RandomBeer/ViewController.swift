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
        
        callRequest(imageView: beerImageView, nameLabel: beerNameLabel, introduceLabel: descriptionLabel)
        
    }
    
    
    @IBAction func showBeerButtonTapped(_ sender: UIButton) {
        
        callRequest(imageView: beerImageView, nameLabel: beerNameLabel, introduceLabel: descriptionLabel)
    }
    
    func callRequest(imageView: UIImageView, nameLabel: UILabel, introduceLabel: UILabel) {
        
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                let imageString = json[0]["image_url"].stringValue
                let name = json[0]["name"].stringValue
                let description = json[0]["description"].stringValue
                
                self.callLangDetectRequest(beerName: name)
                
                
                self.callPapagoRequest(sourceLang: "en", description: description, descriptionLabel: self.descriptionLabel)
//                introduceLabel.text = "맛 설명: \(description)"
                guard let imageUrl = URL(string: imageString) else {
                    return imageView.image = UIImage(systemName: "wineglass.fill")
                }
                imageView.kf.setImage(with: imageUrl)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callPapagoRequest(sourceLang: String,description: String, descriptionLabel: UILabel) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKeys.naverID,
            "X-Naver-Client-Secret" : APIKeys.naverSecret
        ]
        
        let parameters: Parameters = [
            "source" : sourceLang,
            "target" : "ko",
            "text" : description
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let descriptionInKorean = json["message"]["result"]["translatedText"].stringValue
                
                descriptionLabel.text = "맛 설명: \(descriptionInKorean)"
                
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    func callLangDetectRequest(beerName: String) {
        let url = "https://openapi.naver.com/v1/papago/detectLangs"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKeys.naverID,
            "X-Naver-Client-Secret" : APIKeys.naverSecret
        ]
        
        let parameters: Parameters = ["query" : beerName]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let language = json["langCode"].stringValue
                
                if language == "unk" {
                    
                    let alert = UIAlertController(title: "알림", message: "알 수 없는 언어 입니다.", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(okay)
                    self.present(alert, animated: true)
                    
                    return
                } else {
                    self.callPapagoRequest(sourceLang: language, description: beerName, descriptionLabel: self.beerNameLabel)
                }
                
                
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

