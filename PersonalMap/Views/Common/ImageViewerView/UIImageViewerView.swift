import UIKit

public class UIImageViewerView: UIView {
    private let uiImage: UIImage
    private let scrollView: UIScrollView = UIScrollView()
    private let imageView: UIImageView = UIImageView()
        
    required init(uiImage: UIImage) {
        self.uiImage = uiImage
        super.init(frame: .zero)
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
                
        imageView.image = uiImage
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func layoutSubviews() {
       super.layoutSubviews()
        scrollView.frame = bounds
        imageView.frame = scrollView.frame
    }
}

extension UIImageViewerView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
