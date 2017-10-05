//
//  TrendingStocksView.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 10/5/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

class TrendingStocksView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var trendingStocks = DataStore.shared.watchlistPortfolio.trendingStocks
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TrendingStocksView", owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        content.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.backgroundColor = SGConstants.mainBlackColor
        mainCollectionView.backgroundColor = SGConstants.mainBlackColor
        formatCollectionView()
    }
    
    public func updateTrendingStocksView() {
        DataStore.shared.updateTrendingStocks { (success) in
            self.trendingStocks = DataStore.shared.watchlistPortfolio.trendingStocks
            self.mainCollectionView.reloadData()
        }
    }
    
}

extension TrendingStocksView : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func formatCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.register(TrendingStockCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "trendingCell")

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(trendingStocks.count)")
        return trendingStocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! TrendingStockCollectionViewCell
        let stock = trendingStocks[indexPath.row]
        cell.formatCellWithStock(stock)
        return cell
    }
    
    
    
    
    
    
    
    
    
}
