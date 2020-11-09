//
//

import UIKit

open class MapHeader: UIView {
    
    open var mapView : UIView!
    fileprivate var contentSize = CGSize.zero
    fileprivate var topInset : CGFloat = 0
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    fileprivate func commonInit() {
        mapView = UIView()
        mapView.backgroundColor = UIColor.white
        mapView.clipsToBounds = true
        mapView.isUserInteractionEnabled = true
        
        
        
        addSubview(mapView)
    }
    
    // MARK: Public
    open func stretchHeaderSize(headerSize: CGSize, imageSize: CGSize, controller: UIViewController) {
        
        let status_height = UIApplication.shared.statusBarFrame.height
        let navi_height = controller.navigationController?.navigationBar.frame.size.height ?? 44
        
        controller.automaticallyAdjustsScrollViewInsets = false
        
        mapView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        contentSize = imageSize
        self.frame = CGRect(x: 0, y: 0, width: headerSize.width, height: headerSize.height)
    }
    
    open func updateScrollViewOffset(_ scrollView: UIScrollView) {
        
        if mapView == nil { return }
        var scrollOffset : CGFloat = scrollView.contentOffset.y
        scrollOffset += topInset
        
        if scrollOffset < 0 {
            mapView.superview?.frame = CGRect(x: 0, y: scrollOffset, width: contentSize.width - (scrollOffset * 2) , height: contentSize.height - scrollOffset);
        } else {
            mapView.superview?.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: contentSize.width, height: contentSize.height);
        }
    }
}
