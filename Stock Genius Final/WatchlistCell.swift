//
//  WatchlistCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

protocol WatchListCellDelegate {
    func editingInProgressAtIndex(_ index: Int)
    func editingComplete()
}

class WatchlistCell: UITableViewCell {

    @IBOutlet weak var otherCellInEditModeCoverView: UIView!
    @IBOutlet weak var stockContentView: WatchListCellContentView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deleteView: UIView!
    var index : Int?
    var stock : CurrentStock?
    var delegate : WatchListCellDelegate?
    

    var isDragging : Bool = false {
        didSet {
            scrollView.isUserInteractionEnabled = isDragging
            deleteButton.isEnabled = !isDragging
        }
    }
    
    var isInEditMode : Bool = false {
        didSet {
            scrollView.isUserInteractionEnabled = isInEditMode
            deleteButton.isEnabled = isInEditMode
            if !isInEditMode {
                delegate?.editingComplete()
            } else {
                delegate?.editingInProgressAtIndex(index!)
            }
        }
    }
    
    var isInNormalMode : Bool = true {
        didSet {
            scrollView.isUserInteractionEnabled = !isInNormalMode
            deleteButton.isEnabled = !isInNormalMode
        }
    }
    
    var isEditingAllowed : Bool = true {
        didSet {
            scrollView.isScrollEnabled = isEditingAllowed
        }
    }
    
    var isEditingTemporarilyDisabled : Bool = false {
        
        didSet {
            scrollView.isScrollEnabled = !isEditingTemporarilyDisabled
            isUserInteractionEnabled = !isEditingTemporarilyDisabled
            otherCellInEditModeCoverView.alpha = isEditingTemporarilyDisabled ? 0.5 : 0
            let home = CGPoint(x: 0, y: 0)
            let edit = CGPoint(x: 58, y:0)
            let destination = isEditingTemporarilyDisabled ? home : edit
            scrollView.setContentOffset(destination, animated: false)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = false
        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        deleteView.alpha = selected ? 0 : 1
        scrollView.isScrollEnabled = !selected && isEditingAllowed
        
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        print("delete tapped")
    }
    
    func formatCellWithStock(_ stock: CurrentStock, index: Int, isEditingAllowed: Bool) {
        stockContentView.formatViewWithStock(stock)
        self.stock = stock
        self.index = index
        self.isEditingAllowed = isEditingAllowed
        isUserInteractionEnabled = true
        otherCellInEditModeCoverView.alpha = 0
        scrollView.setContentOffset(CGPoint(x: 0, y:0), animated: false)
        
    }
    
    func formatCellForEditModeWithStock(_ stock: CurrentStock, isInEditMode: Bool) {
        stockContentView.formatViewWithStock(stock)
        isEditingTemporarilyDisabled = !isInEditMode
        
        
    }
    
    
    
}

extension WatchlistCell : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        if scrollView.contentOffset.x > 58 {
            scrollView.setContentOffset(CGPoint(x: 58, y: 0), animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let offset = scrollView.contentOffset.x
            adjustScrollViewForOffset(offset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        adjustScrollViewForOffset(offset)
    }
    
    func adjustScrollViewForOffset(_ offset: CGFloat) {
        
        let home = CGPoint(x: 0, y: 0)
        let edit = CGPoint(x: 58, y:0)
        let destination = offset > 29 ? edit : home
        
        if scrollView.contentOffset.x != destination.x {
            scrollView.setContentOffset(destination, animated: true)
        }
        
        isDragging = false
        isInEditMode = offset > 29
        isInNormalMode = offset <= 29
    }
    
    
}
