# KSYCollectionViewLayout

🚀 A waterfall flows collection view layout.

## Results the preview
  <img src="demoPreview.gif" alt="demo preview" />
## How to use

* init
```Swift
  let layout = KSYCollectionViewLayout()
  layout.delegate = self
```

* collection view use layout 
```
  let collect = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
```

* impl KSYCollectionViewLayoutDelegate
```
extension ViewController: KSYCollectionViewLayoutDelegate {
    func numberOfColumn(in collectionView: UICollectionView) -> Int {
        return columnCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: KSYCollectionViewLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let height = 200 + arc4random() % 100
        
        return CGFloat(height)
    }
}
```
