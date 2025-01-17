//
//  SlideToActionButton.swift
//  VenusDriver
//
//  Created by TechBuilder on 16/01/25.
//

import Foundation
protocol SlideToActionButtonDelegate: AnyObject {
    func didFinishSliding()
}
class SlideToActionButton: UIView {
    weak var delegate: SlideToActionButtonDelegate?
    init() {
        super.init(frame: .zero)
    }
     
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var xEndingPoint: CGFloat {
        return (bounds.width - handleView.bounds.width)
    }
    private var isFinished = false
    private func updateHandleXPosition(_ x: CGFloat) {
        leadingThumbnailViewConstraint?.constant = x
    }

    func reset() {
        isFinished = false
        updateHandleXPosition(0)
    }
    func animateHandleBackAndForth() {
         // Animate handle from x = 0 to x = 5 and back to 0 repeatedly
 
        leadingThumbnailViewConstraint?.constant = 30
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {

            leadingThumbnailViewConstraint?.constant = 0

        }, completion: nil)
     }
    
    
    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
      if isFinished { return }
      let translatedPoint = sender.translation(in: self).x

      switch sender.state {
      case .changed:
          if translatedPoint <= 0 {
              updateHandleXPosition(0)
          } else if translatedPoint >= xEndingPoint {
              updateHandleXPosition(xEndingPoint)
          } else {
              updateHandleXPosition(translatedPoint)
          }
      case .ended:
          if translatedPoint >= xEndingPoint {
              self.updateHandleXPosition(xEndingPoint)
              isFinished = true
              delegate?.didFinishSliding()
              //TODO: - add action handler
          } else {
              UIView.animate(withDuration: 1) {
                  self.reset()
              }
          }
      default:
        break
      }
    }
    func setLblText(_ title : String) {
        titleLabel.text = title
    }
    func setup() {
        backgroundColor =  VDColors.buttonSelectedOrange.color
        layer.cornerRadius = 23
        addSubview(titleLabel)
        addSubview(draggedView)
        addSubview(handleView)
        handleView.addSubview(handleViewImage)
        
        //MARK: - Constraints
        
        leadingThumbnailViewConstraint = handleView.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        NSLayoutConstraint.activate([
            leadingThumbnailViewConstraint!,
            handleView.topAnchor.constraint(equalTo: topAnchor),
            handleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 80),
            draggedView.topAnchor.constraint(equalTo: topAnchor),
            draggedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            draggedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            draggedView.trailingAnchor.constraint(equalTo: handleView.trailingAnchor),
            handleViewImage.topAnchor.constraint(equalTo: handleView.topAnchor, constant: 10),
            handleViewImage.bottomAnchor.constraint(equalTo: handleView.bottomAnchor, constant: -10),
            handleViewImage.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        handleView.addGestureRecognizer(panGestureRecognizer)
   
    }


}
struct Colors {
    static let background = #colorLiteral(red: 0.657153666, green: 0.8692060113, blue: 0.6173200011, alpha: 1)
    static let draggedBackground = #colorLiteral(red: 0.462745098, green: 0.7843137255, blue: 0.5764705882, alpha: 1)
    static let tint = #colorLiteral(red: 0.1019607843, green: 0.4588235294, blue: 0.6235294118, alpha: 1)
}
private var leadingThumbnailViewConstraint: NSLayoutConstraint?

let handleView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = VDColors.buttonSelectedOrange.color
    view.layer.cornerRadius = 23
    view.layer.masksToBounds = true
//    view.layer.borderWidth = 0
//    view.layer.borderColor = Colors.tint.cgColor
    return view
}()
 
let handleViewImage: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    //UIImage(systemName: "chevron.right.2", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40, weight: .bold)))?.withRenderingMode(.alwaysTemplate)
    view.image = UIImage(named: "forwordWhite")
    view.contentMode = .scaleAspectFit
    view.tintColor = UIColor.white
    return view
}()
 
let draggedView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = VDColors.buttonSelectedOrange.color
    view.layer.cornerRadius = 23
    return view
}()

let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.textColor = UIColor.white
    label.font = .systemFont(ofSize: 17, weight: .regular)
    label.text = ""
    return label
}()

