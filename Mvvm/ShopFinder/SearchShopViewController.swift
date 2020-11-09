//
//  SearchViewController.swift
//  AutocompleteExample
//

import UIKit
import MapKit

class SearchShopViewController: UIViewController {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.clear
        
        searchResultsTableView.backgroundColor = UIColor.clear
        searchResultsTableView.alpha = 0
        searchBar.alpha = 0
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsOnly
        searchResultsTableView.tableFooterView = UIView()
        
        searchBar.subviews.forEach { searchBarSubview in
            if searchBarSubview is UITextInputTraits {
                do {
                    (searchBarSubview as? UITextField)?.borderStyle = .roundedRect
                } catch {
                    // ignore exception
                }
            }
        }
        
        for view in searchBar.subviews.last!.subviews {
            if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                view.removeFromSuperview()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.searchBar.becomeFirstResponder()
        })
        
        let dismisser = UIView()
        dismisser.frame = view.frame
        view.addSubview(dismisser)
        view.sendSubview(toBack: dismisser)
        
        dismisser.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SearchShopViewController.endSearch(_:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        searchResultsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.leftViewMode = UITextFieldViewMode.never
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font : UIFont(name: "FrutigerLTCom-Roman", size: 13)! // Note the !
        ]
        
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: " Search Zip or City, State", attributes:attributes)
        
        let shadow = UIView()
        shadow.frame = (textFieldInsideSearchBar?.frame)!
        shadow.backgroundColor = UIColor.white
        shadow.layer.cornerRadius = 17
        shadow.layer.shadowColor = Project.Colors.gray.cgColor
        shadow.layer.shadowRadius = 6
        shadow.layer.shadowOpacity = 0.4
        shadow.layer.shadowOffset.height = 0
        
        searchBar.addSubview(shadow)
        searchBar.sendSubview(toBack: shadow)
        
        textFieldInsideSearchBar?.layer.cornerRadius = 17
        
        self.searchBar.superview?.clipsToBounds = false;
        self.searchBar.superview?.layer.masksToBounds = false;
        self.searchBar.removeBackgroundView()
        //textFieldInsideSearchBar?.layer.shadowColor = UIColor.red.cgColor
//        textFieldInsideSearchBar?.layer.shadowRadius = 50.0
//        textFieldInsideSearchBar?.layer.shadowOpacity = 0.7
//        textFieldInsideSearchBar?.layer.shadowOffset.height = 8.0
        
        textFieldInsideSearchBar?.layer.masksToBounds = true
        
        
        //textFieldInsideSearchBar?.layer.cornerRadius = 45.0
        textFieldInsideSearchBar?.clipsToBounds = true

        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: { () -> Void in
            
            self.searchBar.alpha = 1
            self.searchBar.frame.size.width = self.view.frame.size.width
            shadow.frame.size.width = self.view.frame.size.width - 15
            self.searchBar.frame.origin.x = 0
            
        })
    }
    
    @objc func endSearch(_ sender: Any) {
        dismissController()
    }
    
    func dismissController(){
        let parentVC = self.parent as? ShopFinderController
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        parentVC?.searchButton.alpha = 1
    }
    
}

extension SearchShopViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
        if (searchText.trimmingCharacters(in: .whitespacesAndNewlines)).count > 0{
            searchResultsTableView.alpha = 1
        }else{
            searchResultsTableView.alpha = 0
        }
    }
    
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    }
    
    private func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    }
    
    private func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    }
    
    
}

extension SearchShopViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults.removeAll()
        for result in completer.results {
            if (result.subtitle.count == 0 || result.title == searchBar.text) {
                searchResults.append(result)
            }
        }
        
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension SearchShopViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension SearchShopViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        let parentVC = self.parent as? ShopFinderController
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            
            parentVC?.viewModel?.findShops(coordinate!)
        }
        
        dismissController()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = UIView()
        head.frame = CGRect(x:0, y:0, width:view.frame.size.width, height:self.tableView(tableView, heightForHeaderInSection: 0))
        head.backgroundColor = UIColor.white
        return head
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}


extension UISearchBar {
    func removeBackgroundView(){
        if let view:UIView = self.subviews.first {
            for curr in view.subviews {
                guard let searchBarBackgroundClass = NSClassFromString("UISearchBarBackground") else {
                    return
                }
                if curr.isKind(of:searchBarBackgroundClass){
                    curr.layer.masksToBounds = false;
                    curr.clipsToBounds = false;
                    
                    var bounds = curr.frame
                    bounds.size.height = 35 //(set height whatever you want)
                    curr.bounds = bounds
                    
                    if let imageView = curr as? UIImageView{
                        imageView.removeFromSuperview()
                        break
                    }
                }
            }
        }
    }
}
