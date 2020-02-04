//
//  HomeVC.swift
//  sahibindenCodeCase
//
//  Created by Umut Sefer on 6.02.2019.
//  Copyright © 2019 Umut Sefer. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {

    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var lblPlaceHolder: UILabel!
    
    let cellIdentifier = "contentCell"
    let si_PresentKindPopup = "SI_PresentKindPopup"
    let si_PushContentDetail = "SI_PushContentDetail"
    var dataSource: [ContentModel]?
    var selectedKind: String = AppStrings.all.rawValue
    var typedTerm: String = ""
    var limit = "100"
    var cellsCount:CGFloat = 1
    let cellPadding:CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        navigationType = .rightFilter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       collectionViewSizeForSafeArea(size: UIScreen.main.bounds.size)
    }
    
    /// Search Request to the web service. Calls when the user types keywords to the search bar.
    ///
    /// - Parameters:
    ///   - term: Text string you want to search for. It is a required parameter.
    ///   - limit: The number of search results you want the iTunes Store to return.
    ///   - kind: Media type of the results. e.g. Music, Podcast, Movie
    func searchData(term: String?, limit: String?, kind: String?) {
        
        guard let term = term else { return }
        
        let searchRequest = SearchRequest(term: term)
        searchRequest.limit = limit
        searchRequest.media = kind
        
        /// Make a search request to the web service with parameters. Loading Indicator will be shown on self.view. Returns a list which contains ContentModels.
        ServiceManager.shared.search(request: searchRequest, loadingOn: self) { (contents: [ContentModel]) in
            ///set data source array from returned list.
            self.dataSource = contents
            
            ///Filter array and reload collection view.
            self.reloadCollectionView()
        }
    }
    
    func collectionViewSizeForSafeArea (size: CGSize) {
        
        var safeFrameSize = size
        
        if #available(iOS 11.0, *) {
            safeFrameSize = self.view.safeAreaLayoutGuide.layoutFrame.size
        }
        
        adjustCollectionViewSize(size: safeFrameSize)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (context) in
            // During rotation
        }) { (context) in
            // After rotation
            self.collectionViewSizeForSafeArea(size: size)
        }
    }
    
    func adjustCollectionViewSize (size: CGSize) {
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        //especially shows one item for iPhone portrait mode. All other cases(iPad or iPhone landscape) shows two items
        cellsCount = UIDevice.current.orientation.isLandscape ? 2 : (UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2)
        
        let widthMinusPadding = size.width - ((cellPadding * 2) * cellsCount)
        let eachSide = widthMinusPadding / cellsCount
        flowLayout.itemSize = CGSize(width: eachSide, height: 100)
        flowLayout.invalidateLayout()
    }
    
    func reloadCollectionView() {
        
        guard let dataSource = self.dataSource else { return }
        /// Data Source array first filters by deleted Contents and flags for Visited Contents. Assign to the data source of the collection view.
        self.dataSource = DataAdapter.shared.getFilteredList(contents: dataSource)

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
        }
    }
    
    
    /// Opens Filter Popup
    ///
    /// - Parameter sender: sender
    @objc override func rightButtonClicked(sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: si_PresentKindPopup, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == si_PresentKindPopup {
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? SelectionPopupVC {
                    dest.selectedRowValue = selectedKind
                }
            }
        } else if segue.identifier == si_PushContentDetail {
            if let dest = segue.destination as? ContentDetailVC {
                guard let content = sender as? ContentModel else { return }
                dest.content = content
            }
        }
    }
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        
        if let source = sender.source as? SelectionPopupVC {
            if selectedKind != source.selectedRowValue {
                selectedKind = source.selectedRowValue
                searchData(term: typedTerm , limit: limit, kind: selectedKind)
            }
        } else if let source = sender.source as? ContentDetailVC {
            
            guard let content = source.content else { return }
            let index = dataSource?.firstIndex(where: { $0.trackId == content.trackId}) ?? 0
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.performBatchUpdates({
                ///delete from data source
                self.dataSource?.remove(at: index)
                ///remove from collection view
                self.collectionView.deleteItems(at:[indexPath])
            }, completion: { (finished) in
                ///add to file which contains deleted Ids
                DataAdapter.shared.addContentForDeleted(content: content)
            })
        }
    }
}

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ContentCell
        guard let source = dataSource, source.count > indexPath.item else { return cell }
        cell.content = source[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
}

extension HomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        ///All this lines below for the flag selected content and marked as visible. And reload related Index of the collection view
        guard let source = dataSource, source.count > indexPath.item else { return }
        var content = source[indexPath.item]
        DataAdapter.shared.addContentForVisited(content: content)
        content.isVisited = true
        dataSource?[indexPath.item] = content
        performSegue(withIdentifier: si_PushContentDetail, sender: content)
        collectionView.reloadItems(at: [indexPath])
    }
}

extension HomeVC: UISearchBarDelegate {
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        typedTerm = searchText
        searchData(term: searchText, limit: limit, kind: selectedKind)
        lblPlaceHolder.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()
    }
}

