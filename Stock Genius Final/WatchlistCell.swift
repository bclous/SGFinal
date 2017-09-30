//
//  WatchlistCell.swift
//  Stock Genius Final
//
//  Created by Brian Clouser on 9/29/17.
//  Copyright © 2017 Clouser. All rights reserved.
//

import UIKit

enum WatchListCellState : Int {
    case noEditingAllowed
    case normal
    case editingActiveForDelete
    case editingActiveForReorder
    case editingInactive
}

enum EditType {
    case deleting
    case reordering
}

protocol WatchListCellDelegate {
    func editingRequestedAtIndex(_ index: Int, editType: EditType )
    func editingComplete()
    func reorderRequested(isUp: Bool, index: Int)
    func deleteRequestedAtIndex(_ index: Int)
}

class WatchlistCell: UITableViewCell, UpDownButtonDelegate, WatchCellContentViewDelegate {

    @IBOutlet weak var downBackgroundView: UIView!
    @IBOutlet weak var upBackgroundView: UIView!
    @IBOutlet weak var upDownButtonsView: UpDownButtonsView!
    @IBOutlet weak var otherCellInEditModeCoverView: UIView!
    @IBOutlet weak var stockContentView: WatchListCellContentView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deleteView: UIView!
    var index : Int?
    var stock : CurrentStock?
    var delegate : WatchListCellDelegate?
    let homeContentOffset = CGPoint(x: 116, y: 0)
    let reorderContentOffset = CGPoint(x: 0, y: 0)
    let deleteContentOffset = CGPoint(x: 174, y: 0)
    var state : WatchListCellState = .normal
    var isUserActive = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = SGConstants.mainBlackColor
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = false
        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        upDownButtonsView.delegate = self
        stockContentView.delegate = self
        upBackgroundView.backgroundColor = SGConstants.mainBlueColor
        downBackgroundView.backgroundColor = SGConstants.mainBlueColor
        formatCellForState(state)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        deleteView.alpha = selected ? 0 : 1
    }
    
    
    
    func formatCellWithStock(_ stock: CurrentStock, index: Int, cellState: WatchListCellState) {
        state = cellState
        self.stock = stock
        self.index = index
        stockContentView.formatViewWithStock(stock)
        formatCellForState(state)
    }
    
    private func formatCellForState(_ state: WatchListCellState) {
        
        adjustScrollViewForState(state, animated: false)
        
        switch state {
        case .noEditingAllowed:
            isUserInteractionEnabled = true
            stockContentView.isInEditMode = false
            scrollView.isUserInteractionEnabled = false
            deleteButton.isEnabled = false
            upDownButtonsView.buttonsAreActive = false
            scrollView.isScrollEnabled = false
            otherCellInEditModeCoverView.alpha = 0
        case .normal:
            isUserInteractionEnabled = true
            stockContentView.isInEditMode = false
            scrollView.isUserInteractionEnabled = false
            deleteButton.isEnabled = false
            upDownButtonsView.buttonsAreActive = false
            scrollView.isScrollEnabled = true
            otherCellInEditModeCoverView.alpha = 0
        case .editingInactive:
            isUserInteractionEnabled = false
            stockContentView.isInEditMode = false
            scrollView.isUserInteractionEnabled = true
            deleteButton.isEnabled = false
            upDownButtonsView.buttonsAreActive = false
            scrollView.isScrollEnabled = false
            otherCellInEditModeCoverView.alpha = 0.4
        case .editingActiveForDelete:
            isUserInteractionEnabled = true
            stockContentView.isInEditMode = true
            scrollView.isUserInteractionEnabled = true
            deleteButton.isEnabled = true
            upDownButtonsView.buttonsAreActive = false
            scrollView.isScrollEnabled = false
            otherCellInEditModeCoverView.alpha = 0
        case .editingActiveForReorder:
            isUserInteractionEnabled = true
            stockContentView.isInEditMode = true
            scrollView.isUserInteractionEnabled = true
            deleteButton.isEnabled = false
            upDownButtonsView.buttonsAreActive = true
            scrollView.isScrollEnabled = false
            otherCellInEditModeCoverView.alpha = 0
        }
    }
    
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        delegate?.deleteRequestedAtIndex(index!)
    }
    
    func directionTapped(isUp: Bool) {
        delegate?.reorderRequested(isUp: isUp, index: index!)
    }

    func returnToHome() {
        state = .normal
        adjustScrollViewForState(state, animated: true)
    }
}

extension WatchlistCell : UIScrollViewDelegate {
    
    func adjustScrollViewForState(_ state: WatchListCellState, animated: Bool) {
        switch state {
        case .noEditingAllowed, .normal, .editingInactive:
            scrollView.setContentOffset(homeContentOffset, animated: animated)
        case .editingActiveForDelete:
            scrollView.setContentOffset(deleteContentOffset, animated: animated)
        case .editingActiveForReorder:
            scrollView.setContentOffset(reorderContentOffset, animated: animated)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isUserActive {
            if scrollView.contentOffset.x >= 174 {
                scrollView.setContentOffset(deleteContentOffset, animated: false)
            } else if scrollView.contentOffset.x <= 0 {
               scrollView.setContentOffset(reorderContentOffset, animated: false)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserActive = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let offset = scrollView.contentOffset.x
            
            if scrollView.contentOffset.x == homeContentOffset.x {
                state = .normal
                adjustCellForState()
            } else if scrollView.contentOffset.x == deleteContentOffset.x {
                state = .editingActiveForDelete
                adjustCellForState()
            } else if scrollView.contentOffset.x == reorderContentOffset.x {
                state = .editingActiveForReorder
                adjustCellForState()
            } else {
                adjustScrollViewForOffset(offset)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        
        if scrollView.contentOffset.x == homeContentOffset.x {
            state = .normal
            adjustCellForState()
        } else if scrollView.contentOffset.x == deleteContentOffset.x {
            state = .editingActiveForDelete
            adjustCellForState()
        } else if scrollView.contentOffset.x == reorderContentOffset.x {
            state = .editingActiveForReorder
            adjustCellForState()
        } else {
            adjustScrollViewForOffset(offset)
        }
    }

    func adjustScrollViewForOffset(_ offset: CGFloat) {

        if offset <= 58 {
            state = .editingActiveForReorder
        } else if offset <= 145 {
            state = .normal
        } else {
            state = .editingActiveForDelete
        }
        
        adjustScrollViewForState(state, animated: true)

    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        adjustCellForState()
    }
    
    func adjustCellForState() {
        if state == .normal {
            delegate?.editingComplete()
        } else {
            let editType : EditType = state == .editingActiveForReorder ? .reordering : .deleting
            delegate?.editingRequestedAtIndex(index!, editType: editType)
        }
    }

    
}
