//
//  UIView+Addable.swift
//  juinjang
//
//  Created by KimDongWoo on 3/4/25.
//


import UIKit

public protocol Addable {
    func addSubview(_ view: Self)
}

public protocol AddWith {}

extension AddWith where Self: Addable {
    
    /// Add views to the end of the receiver’s list of subviews.
    /// This method establishes a strong reference to view and sets its next responder to the receiver, which is its new superview.
    /// Views can have only one superview. If view already has a superview and that view is not the receiver, this method removes the previous superview before making the receiver its new superview.
    ///
    ///     self.view.add(
    ///       self.titleLabel,
    ///       self.descriptionLabel,
    ///       self.imageView
    ///     )
    ///
    /// - Parameter subviews: The collection of views to be added. After being added, this views appear on top of any other subviews.
    
    public func add(_ subviews: [Self]) {
        subviews.forEach {
            self.addSubview($0)
        }
    }
    
    
    /// Add views to the end of the receiver’s list of subviews.
    /// This method establishes a strong reference to view and sets its next responder to the receiver, which is its new superview.
    /// Views can have only one superview. If view already has a superview and that view is not the receiver, this method removes the previous superview before making the receiver its new superview.
    ///
    /// - Parameter subviews: The collection of views to be added. After being added, this views appear on top of any other subviews.
    
    public func add(_ subviews: Self...) {
        self.add(subviews)
    }
    
    
    /// Add views to the end of the receiver's list of subviews, and return the receiver.
    ///
    ///     self.scrollView.add(
    ///       self.contentContainer.with(
    ///         self.descriptionLabel
    ///         self.imageView
    ///       )
    ///     )
    ///
    /// - Parameter subviews: The collection of views to be added. After being added, this views appear on top of any other subviews.
    /// - Returns: Receiver, with new subviews.
    
    public func with(_ subviews: Self...) -> Self {
        self.add(subviews)
        return self
    }
    
    public func with(_ subviews: [Self]) -> Self {
        self.add(subviews)
        return self
    }
    
    public func with(_ subviews: [Self]...) -> Self {
        return self.with(subviews.flatMap { $0 })
    }
    
}

extension UIView: AddWith, Addable {}
