//
//  ChatMessageCell.swift
//  ChatApplication
//
//  Created by student-2 on 10/01/25.
//
import UIKit

class ChatMessageCell: UITableViewCell {

    var messageLabel: UILabel!
    var timeLabel: UILabel!
    var bubbleView: UIView!
    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    var timeTrailingConstraint: NSLayoutConstraint!
    var timeLeadingConstraint: NSLayoutConstraint!

    let bubbleWidth: CGFloat = 200

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Bubble view configuration
        bubbleView = UIView()
        bubbleView.layer.cornerRadius = 15
        bubbleView.layer.masksToBounds = true
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)

        // Message label configuration
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addSubview(messageLabel)

        // Time label configuration
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = .systemFont(ofSize: 10)  // Smaller font for time
        timeLabel.textColor = .gray
        contentView.addSubview(timeLabel)

        // Constraints setup
        NSLayoutConstraint.activate([
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: bubbleWidth),
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),

            // Time label constraints (bottom of the bubble view)
            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 5),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        // Default alignment to left
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        timeLeadingConstraint = timeLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10)
        timeTrailingConstraint = timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10)

        NSLayoutConstraint.activate([
            leadingConstraint,
            trailingConstraint,
            timeLeadingConstraint,
            timeTrailingConstraint
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configure the cell with message data and alignment
    func configure(with message: String, isCurrentUser: Bool) {
        messageLabel.text = message
        messageLabel.textColor = isCurrentUser ? .white : .black
        bubbleView.backgroundColor = isCurrentUser ? .systemBlue : .lightGray

        // Adjust constraints based on user (align left or right)
        if isCurrentUser {
            trailingConstraint.isActive = true
            leadingConstraint.isActive = false
            timeTrailingConstraint.isActive = true
            timeLeadingConstraint.isActive = false
        } else {
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
            timeLeadingConstraint.isActive = true
            timeTrailingConstraint.isActive = false
        }

        // Set time label with formatted current time
        timeLabel.text = getCurrentTime()
    }

    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: Date())
    }
}
