//
//  AppDetailViewController.swift
//  AppStore
//
//  Created by Bishal Kurumbang on 07/02/17.
//  Copyright © 2017 kBangProduction. All rights reserved.
//

import UIKit

class AppDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    var app: App?{
        didSet{
            if app?.screenshots != nil{
                return
            }
            if let id = app?.id{
                if let path = Bundle.main.path(forResource: "\(id)", ofType: "json"){
                    do{
                        let data = try(NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe))

                        let json = try(JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers))
                        
                        let dictionary = json as? NSDictionary
                        
                        let appDetail = App()
                        appDetail.setValuesForKeys(dictionary as!  [String : AnyObject])
                        
                        self.app = appDetail
                        
                        DispatchQueue.main.async {
                           self.collectionView?.reloadData()
                        }
                        
                    }catch let err{
                        print(err)
                    }
                }
                
            }
        }
        
    }
    private let headerId = "headerId"
    private let cellId = "cellId"
    private let descriptionCellId = "descriptionCellId"
    private let informationCellId = "informationCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(ScreenshotsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
        collectionView?.register(AppDetailInformationCell.self, forCellWithReuseIdentifier: informationCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
         //------------------------------ TODO ------------------------------
        if indexPath.item == 2 {
           
            var infoObjects = [AppInformation]()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: informationCellId, for: indexPath) as! AppDetailInformationCell
            if let appinfo = app?.appInformation{
                //print(appinfo)
                for info in appinfo as! [[String: AnyObject]]{
                    let infoObject = AppInformation()
                    infoObject.setValuesForKeys(info)
                    infoObjects.append(infoObject)
                }
                
            }
            
            return cell
        }
         //------------------------------ TODO ENDs Here ------------------------------
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotsCell
        cell.app = app
        return cell
    }
    
    private func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Description\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        if let desc = app?.desc{
            attributedText.append(NSAttributedString(string: desc, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 11), NSForegroundColorAttributeName: UIColor.darkGray]))
        }
        
        return attributedText
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            let dummySize = CGSize.init(width: view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            return CGSize.init(width: view.frame.width, height: rect.height + 30)
        }
        return CGSize.init(width: view.frame.width, height: 170)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        header.app = app
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 170)
    }
    
}

class AppDetailDescriptionCell: BaseCell{
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE EXAMPLE"
        return tv
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(textView)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: textView)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
}

/*
 *
 *  TODO Show App Information
 *
 *
 */

class AppDetailInformationCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    private let infoCellId = "infoCellId"
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.text = "Information"
        return tv
    }()
    
    let infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.blue
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
   
    override func setupViews() {
        super.setupViews()
//       addSubview(textView)
        addSubview(infoCollectionView)
        infoCollectionView.dataSource = self
        infoCollectionView.delegate = self
        
        infoCollectionView.register(InfoCell.self, forCellWithReuseIdentifier: infoCellId)
        addConstraintsWithFormat(format: "H:|[v0]|", views: infoCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: infoCollectionView)

        
//        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: textView)
//        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: textView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellId, for: indexPath) as! InfoCell
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: frame.width, height: 10)
    }

}


class InfoCell: BaseCell{
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        return label
    }()
    
    let textValue: UILabel = {
        let label = UILabel()
        label.text = "Information"
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textLabel)
        addSubview(textValue)
        
    }
}


class AppInformation : NSObject{
    var name: String?
    var value: String?
}

// ------------------------------ TODO ENDs HERE !------------------------------



// AppDetail Header Part

class AppDetailHeader: BaseCell{
    
    var app: App? {
        didSet {
            if let imageName = app?.imageName{
                imageView.image = UIImage(named: imageName)
            }
            
            if let appName = app?.name{
                nameLabel.text = appName
            }
            
            if let price = app?.price{
                buyButton.setTitle("$\(price)", for: .normal)
            }else{
                buyButton.setTitle("Free", for: .normal)
            }
            
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = UIColor.darkGray
        sc.selectedSegmentIndex = 0
        return sc
     
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor(colorLiteralRed: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        
        super.setupViews()
        
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
       
        
        addConstraintsWithFormat(format: "H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-14-[v0(100)]|", views: imageView)
        
        addConstraintsWithFormat(format: "V:|-14-[v0(20)]", views: nameLabel)
        
        addConstraintsWithFormat(format: "H:[v0(60)]-14-|", views: buyButton)
        addConstraintsWithFormat(format: "V:[v0(32)]-56-|", views: buyButton)
        
        addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithFormat(format: "V:[v0(34)]-8-|", views: segmentedControl)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(0.5)]|", views: dividerLineView)
        
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictonary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictonary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictonary))
        
    }
}

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
    }
}
