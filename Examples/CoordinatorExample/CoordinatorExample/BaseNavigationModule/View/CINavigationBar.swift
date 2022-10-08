//
//  ProjectNavigationBar.swift
//  ProjectNavigationBar
//
//  Created by Скибин Александр on 30.08.2021.
//

import UIKit

public protocol CINavigationBarDelegate: AnyObject {
    
    /// Максимальная высота контента
    var maxContentHeight: CGFloat { get}
    
    /// Высота контент бара
    var heightContent: CGFloat { get }
    
    /// Заголовок
    var titleBar: String? { get }
    
    /// Обновить состояние navigationItem title
    func updateNavigationItemTitle(_ isHidden: Bool)
    
}

public final class CINavigationBar: UINavigationBar {
    
    // MARK: - Properties
    
    var customDelegate: CINavigationBarDelegate?
    
    var titleLabel: UILabel = UILabel(frame: .zero)
    var titleLabelWidth : NSLayoutConstraint?

    // MARK: - Public Properties
    
    var barBackground: UIView? {
        guard
            let subView = self.subviews.first(
                where: {
                    view in NSStringFromClass(view.classForCoder).contains("UIBarBackground")
                }
            )
        else {
            return nil
        }
        
        return subView
    }
    
    var barContentBackground: UIView? {
        guard
            let subView = self.subviews.first(
                where: {
                    view in NSStringFromClass(view.classForCoder).contains("UINavigationBarContentView")
                }
            )
        else {
            return nil
        }
        
        return subView
    }
    
    // MARK: - Layouts

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(
            width: UIScreen.main.bounds.width,
            height: customDelegate?.heightContent ?? .zero
        )
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard
            let barBackground = barBackground,
            let barContentBackground = barContentBackground
        else {
            return
        }
        
        let currentHeight = customDelegate?.heightContent ?? .zero >= 0 ? customDelegate?.heightContent ?? .zero : .zero
        let maxHeight = customDelegate?.maxContentHeight ?? .zero
        
        let changeHeight = currentHeight > maxHeight ? maxHeight : currentHeight
        
        barBackground.backgroundColor = .clear
        
        barBackground.frame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.width,
            height: changeHeight
        )
        barBackground.sizeToFit()
        
        barContentBackground.frame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.width,
            height: barContentBackground.frame.height
        )
        
        barContentBackground.sizeToFit()
        
        ///
        
        checkPositionTitleLabel()
    }
    
    // MARK: - UI
    
    func configureBackgorundImage() {
        guard let backgroundView = barBackground else {
            return
        }
        
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "top")
        imageView.contentMode = .scaleAspectFill
        
        backgroundView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: customDelegate?.maxContentHeight ?? .zero).isActive = true
        imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        
        imageView.contentMode = .scaleAspectFill
    }
    
    func configureTitle() {
        guard let backgroundView = barBackground else {
            return
        }
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        
        backgroundView.addSubview(titleLabel)
        
        titleLabel.text = customDelegate?.titleBar
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
    }
    
    /// Проверяем состояние title label
    func checkPositionTitleLabel() {
        let isHidden = ((titleLabel.center.y - (barContentBackground?.center.y ?? .zero)) <= 12)
        self.titleLabel.isHidden = isHidden
        customDelegate?.updateNavigationItemTitle(isHidden)
    }
    
}
