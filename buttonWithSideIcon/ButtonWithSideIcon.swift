//
//  ButtonWithASideIcon.swift
//
//  Created by Badi3
//


import UIKit

@IBDesignable
public final class ButtonWithASideIcon: UIControl {
    @IBInspectable
    public var pressedBackgroundColor: UIColor = UIColor.red
    
    @IBInspectable
    public var titleAndIconColor: UIColor = UIColor.black {
        didSet{
            label.textColor = titleAndIconColor
            imageView.tintColor = titleAndIconColor
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var unpressedBackgroundColor: UIColor = UIColor.red.withAlphaComponent(0.3) {
        didSet {
            backgroundColor = unpressedBackgroundColor
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let label: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        return label
    }()
    
    fileprivate lazy var stackView: UIStackView = {
        
        let redAlertLeftSpace = UIView.init()
        redAlertLeftSpace.translatesAutoresizingMaskIntoConstraints = false
        
        let redAlertRightSpace = UIView.init()
        redAlertRightSpace.translatesAutoresizingMaskIntoConstraints = false
        
        
       
        
        
        
        let stackView = UIStackView(arrangedSubviews: [redAlertLeftSpace, self.imageView, self.label, redAlertRightSpace])
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        redAlertRightSpace.widthAnchor.constraint(equalTo: redAlertLeftSpace.widthAnchor, multiplier: 1, constant: 0).isActive = true
        return stackView
    }()
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        applyStyle()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }
    
    private func applyStyle() {
        imageView.tintColor = titleAndIconColor
        label.textColor = titleAndIconColor
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = 6
        clipsToBounds = true
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ])
    }
}

public extension ButtonWithASideIcon {
    @IBInspectable
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBInspectable
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    @IBInspectable
    var fontSize: CGFloat {
        get {
            return label.font.pointSize
        }
        set {
            label.font = label.font.withSize(newValue)
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layoutMargins = UIEdgeInsets(
                top: newValue,
                left: newValue,
                bottom: newValue / 2,
                right: newValue
            )
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var imagePadding: CGFloat {
        get {
            return image?.alignmentRectInsets.top ?? 0
        }
        set {
            image = image?.withAlignmentRectInsets(
                UIEdgeInsets(
                    top: -newValue,
                    left: -newValue,
                    bottom: -newValue,
                    right: -newValue
                )
            )
        }
    }
    
    
}

//MARK: UIControl Stuff
public extension ButtonWithASideIcon {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isPressed: true)
        
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isPressed: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isPressed: false)
    }
    
    private func animate(isPressed: Bool) {
        let (duration, backgroundColor) = {
            isPressed
                ? (
                    duration: 0.05,
                    backgroundColor: pressedBackgroundColor
                    )
                : (
                    duration: 0.1,
                    backgroundColor: unpressedBackgroundColor
            )
        }()
        
        UIView.animate(withDuration: duration){
            self.backgroundColor = backgroundColor
        }
    }
}
