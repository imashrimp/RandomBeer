//
//  ViewController.swift
//  RandomBeer
//
//  Created by 권현석 on 2023/08/07.
//

import UIKit

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
        
    }
    
    
    @IBAction func showBeerButtonTapped(_ sender: UIButton) {

        callRequest(imageView: beerImageView, nameLabel: beerNameLabel, introduceLabel: descriptionLabel) { beer in
            
            guard
                let quickTypeData = beer
            else { return }

            self.beerNameLabel.text = quickTypeData.first?.name
            self.descriptionLabel.text = quickTypeData.first?.description
            
            guard
                let urlString = quickTypeData.first?.imageURL,
                    let url = URL(string: urlString)
            else {
                self.beerImageView.image = UIImage(systemName: "wineglass.fill")
                return }

            DispatchQueue.global().async {
                do {
                    let imageData = try? Data(contentsOf: url)

                    DispatchQueue.main.async {
                        //MARK: - 여기 강제해제 해도 되는지 물어보기
                        self.beerImageView.image = UIImage(data: imageData!)
                    }
                }
            }
        }
    }
    
    func callRequest(imageView: UIImageView, nameLabel: UILabel, introduceLabel: UILabel, completionHandler: @escaping (Beers?) -> Void) {
        
        let scheme = "https"
        let host = "api.punkapi.com"
        let path = "/v2/beers/random"
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        guard let randomBeerUrl = components.url else {
            return
        }
        
        URLSession.shared.dataTask(with: randomBeerUrl) { data, response, error in
            
            DispatchQueue.main.async {
                
                if let error {
                    completionHandler(nil)
                    print(error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...500).contains(response.statusCode) else {
                    completionHandler(nil)
                    print(error)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil)
                    print(error)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(Beers.self, from: data)
                    completionHandler(result)
                } catch {
                    completionHandler(nil)
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
        
//        AF.request(url, method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//
//                let imageString = json[0]["image_url"].stringValue
//                let name = json[0]["name"].stringValue
//                let description = json[0]["description"].stringValue
//
//                self.callLangDetectRequest(beerName: name)
//
//
//                self.callPapagoRequest(sourceLang: "en", description: description, descriptionLabel: self.descriptionLabel)
////                introduceLabel.text = "맛 설명: \(description)"
//                guard let imageUrl = URL(string: imageString) else {
//                    return imageView.image = UIImage(systemName: "wineglass.fill")
//                }
//                imageView.kf.setImage(with: imageUrl)
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
//    func callPapagoRequest(sourceLang: String,description: String, descriptionLabel: UILabel) {
//        let url = "https://openapi.naver.com/v1/papago/n2mt"
//
//        let headers: HTTPHeaders = [
//            "X-Naver-Client-Id" : APIKeys.naverID,
//            "X-Naver-Client-Secret" : APIKeys.naverSecret
//        ]
//
//        let parameters: Parameters = [
//            "source" : sourceLang,
//            "target" : "ko",
//            "text" : description
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//
//                let descriptionInKorean = json["message"]["result"]["translatedText"].stringValue
//
//                descriptionLabel.text = "맛 설명: \(descriptionInKorean)"
//
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//
//    }
    
//    func callLangDetectRequest(beerName: String) {
//        let url = "https://openapi.naver.com/v1/papago/detectLangs"
//
//        let headers: HTTPHeaders = [
//            "X-Naver-Client-Id" : APIKeys.naverID,
//            "X-Naver-Client-Secret" : APIKeys.naverSecret
//        ]
//
//        let parameters: Parameters = ["query" : beerName]
//
//        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                let language = json["langCode"].stringValue
//
//                if language == "unk" {
//
//                    let alert = UIAlertController(title: "알림", message: "알 수 없는 언어 입니다.", preferredStyle: .alert)
//                    let okay = UIAlertAction(title: "확인", style: .default)
//                    alert.addAction(okay)
//                    self.present(alert, animated: true)
//
//                    return
//                } else {
//                    self.callPapagoRequest(sourceLang: language, description: beerName, descriptionLabel: self.beerNameLabel)
//                }
//
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
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

