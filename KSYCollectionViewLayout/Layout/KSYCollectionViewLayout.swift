//
//  KSYCollectionViewLayout.swift
//  KSYCollectionViewLayout
//
//  Created by huangdaxia on 2017/8/9.
//  Copyright © 2017年 ksyfast. All rights reserved.
//

import UIKit

@objc public protocol KSYCollectionViewLayoutDelegate {
    func numberOfColumn(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, layout: KSYCollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
}

public class KSYCollectionViewLayout: UICollectionViewLayout {
    
    /// 行间距
    public var lineSpacing: CGFloat
    
    /// 列间距
    public var columnSpacing: CGFloat
    
    public var sectionInsets: UIEdgeInsets
    
    public var sectionLeft: CGFloat = 0 {
        didSet {
            sectionInsets.left = sectionLeft
        }
    }
    
    public var sectionRight: CGFloat = 0 {
        didSet {
            sectionInsets.right = sectionRight
        }
    }
    
    public var sectionTop: CGFloat = 0 {
        didSet {
            sectionInsets.top = sectionTop
        }
    }
    
    public var sectionBottom: CGFloat = 0 {
        didSet {
            sectionInsets.bottom = sectionBottom
        }
    }
    
    /// delegate for layout
    public weak var delegate: KSYCollectionViewLayoutDelegate?
    
    fileprivate var columnHeights: [Int : CGFloat] = [Int : CGFloat]()
    
    fileprivate var attributes: [UICollectionViewLayoutAttributes] = []
    
    public init(lineSpacing: CGFloat = 8,
                columnSpacing: CGFloat = 8,
                sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)) {
        self.lineSpacing = lineSpacing
        self.columnSpacing = columnSpacing
        self.sectionInsets = sectionInsets
        
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var collectionViewContentSize: CGSize {
        if columnHeights.count <= 0 {
            fatalError("column heights count is zero!")
        }
        
        var maxHeight: CGFloat = 0
        maxHeight = columnHeights.reduce(columnHeights.first!.value, {
            return max($0, $1.value)
        })
     
        return CGSize(width: collectionView?.frame.width ?? 0, height: maxHeight + sectionBottom)
    }
 
    public override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            print("collect is nil!")
            return
        }
        if let columnCount = delegate?.numberOfColumn(in: collectionView) {
            for index in 0..<columnCount {
                columnHeights[index] = sectionInsets.top
            }
        }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        attributes.removeAll()
        for i in 0..<itemCount {
            if let attribute = layoutAttributesForItem(at: IndexPath(row: i, section: 0)) {
                attributes.append(attribute)
            }
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            print("collect is nil!")
            return nil
        }
        
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let width = collectionView.frame.width
        if let columnCount = delegate?.numberOfColumn(in: collectionView), columnHeights.count > 0 {
            let cgColumnCount = CGFloat(columnCount)
            guard cgColumnCount > 0, columnHeights.count > 0 else { return nil }
            let totalSpacing = (cgColumnCount - 1) * columnSpacing
            let totalWidth = width - sectionInsets.left - sectionInsets.right - totalSpacing
            let itemWidth = totalWidth / cgColumnCount
            let itemHeight = delegate?.collectionView(collectionView, layout: self, heightForItemAt: indexPath) ?? 0
            let minColumnHeight = columnHeights.reduce(columnHeights.first!, {
                if $1.value < $0.value {
                    return $1
                }
                
                return $0
            })
            let minIndex = minColumnHeight.key
            let cgMinIndex = CGFloat(minIndex)
            let itemX = sectionInsets.left + (columnSpacing + itemWidth) * cgMinIndex
            let minHeight = minColumnHeight.value
            let itemY = minHeight + lineSpacing
            
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            columnHeights[minIndex] = attribute.frame.maxY
        }
        
        return attribute
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}
