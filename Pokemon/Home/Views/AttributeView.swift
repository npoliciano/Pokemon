//
//  AttributeView.swift
//  Pokemon
//
//  Created by Nicolle on 17/03/24.
//

import UIKit

final class AttributeView: UIView {
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setCornerRadius()
    }

    private func setCornerRadius() {
        containerView.layer.cornerRadius = 9
        containerView.layer.masksToBounds = true
    }

    private func setConstraints() {
        addSubview(containerView)
        containerView.constrainToEdges(superview: self)

        containerView.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setContent(value: String?) {
        if let value {
            valueLabel.text = value
            containerView.isHidden = false
        } else {
            containerView.isHidden = true
        }
    }
}
