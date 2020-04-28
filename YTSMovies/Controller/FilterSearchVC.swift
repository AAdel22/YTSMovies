//
//  FilterSearchVC.swift
//  YTSMovies
//
//  Created by Alaa Adel on 4/26/20.
//  Copyright © 2020 Alaa Adel. All rights reserved.
//

import UIKit

protocol DataSentByDelegate {
    func userDidApplySomeFilter(query: String, genre: String, minRate: Int, quality: String, sortBy: String, orderBy: String)
}

class FilterSearchVC: UIViewController {

    @IBOutlet weak var movieTitleTextField: UITextField!
    
    @IBOutlet weak var movieGenreTextField: UITextField!
    
    @IBOutlet weak var minimumRatingLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var filterBTN: UIButton!
    @IBOutlet weak var cancelBTN: UIButton!
    
    
    var delegate: DataSentByDelegate? = nil
    
    var movieGenrePicker: UIPickerView = UIPickerView()
    
    let genres: [String] = ["All","Action","Adventure","Animation","Biography","Comedy","Crime","Documentary",
                            "Drama","Family","Fantasy","Film Noir","History","Horror","Music","Musical","Mystery",
                            "Romance","Sci-Fi","Short","Sport","Superhero","Thriller","War","Western"]
    
    var movieQuality: String = "All"
    var moviesOrderBy: String = "desc"
    var sortByOptionsisSelected: String = "date added"
    let sortByOptions: [String] = ["date added", "title", "year", "rating", "peers", "seeds", "download count", "like count"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // movie TextField
        self.movieTitleTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.movieTitleTextField.layer.borderWidth = 2
        self.movieTitleTextField.layer.cornerRadius = 5
        self.movieTitleTextField.attributedPlaceholder = NSAttributedString(string: "Movie Title...", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        self.movieTitleTextField.delegate = self
        self.movieTitleTextField.returnKeyType = .done

        // movie TextField
        self.movieGenreTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.movieGenreTextField.layer.borderWidth = 2
        self.movieGenreTextField.layer.cornerRadius = 5
        self.movieGenreTextField.attributedPlaceholder = NSAttributedString(string: "Genre Title...", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        self.movieGenreTextField.delegate = self
        self.movieGenreTextField.returnKeyType = .done
        
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // pickerView
        movieGenrePicker.delegate = self
        movieGenrePicker.dataSource = self
        
        movieGenreTextField.inputView = movieGenrePicker
        
        self.filterBTN.layer.cornerRadius = self.filterBTN.frame.height / 2
        self.filterBTN.layer.borderWidth = 1
        self.filterBTN.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.filterBTN.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
       
        self.cancelBTN.layer.cornerRadius = self.cancelBTN.frame.height / 2
        self.cancelBTN.layer.borderWidth = 1
        self.cancelBTN.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.cancelBTN.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // for dismiss the keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func ratingStepperBTN(_ sender: UIStepper) {
        self.view.endEditing(true)
        self.minimumRatingLabel.text = String(sender.value)
    }
    
    @IBAction func qualitySegmentedBTN(_ sender: UISegmentedControl) {
        self.view.endEditing(true)
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.movieQuality = "All"
        case 1:
            self.movieQuality = "720p"
        case 2:
            self.movieQuality = "1080p"
        default:
            self.movieQuality = "3D"
        }
    }
    
    @IBAction func orderBySegmentedBTN(_ sender: UISegmentedControl) {
        self.view.endEditing(true)
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.moviesOrderBy = "DESC"
        default:
            self.moviesOrderBy = "ASC"
        }
    }
    @IBAction func cancelBTN(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func filterBTN(_ sender: UIButton) {
        if delegate != nil {
            
            let query: String = self.movieTitleTextField.text ?? "" == "" ? "0" : self.movieTitleTextField.text!
            let genre: String = self.movieGenreTextField.text ?? "" == "" ? "All" : self.movieGenreTextField.text!
            let minRate: Int = Int(self.minimumRatingLabel.text ?? "0") ?? 0
            
            // pass the filter data to the delegate
            delegate?.userDidApplySomeFilter(query: query, genre: genre.lowercased(), minRate: minRate, quality: self.movieQuality, sortBy: self.sortByOptionsisSelected.replacingOccurrences(of: " ", with: "_"), orderBy: self.moviesOrderBy)
            
            dismiss(animated: true, completion: nil)
        }
        
        
    }
}

extension FilterSearchVC: UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genres.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        movieGenreTextField.text = genres[row]
        self.view.endEditing(true)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genres[row]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortByOptions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortByCollectionViewCell", for: indexPath) as! SortByCollectionViewCell
        cell.cellDesign()
        cell.configure(with: sortByOptions[indexPath.row], isSelected: (sortByOptionsisSelected == sortByOptions[indexPath.row]))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        sortByOptionsisSelected = sortByOptions[indexPath.row]
        collectionView.reloadData()
    }
}
