//
//  RateTriangleView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/15/25.
//

import UIKit

final class RateTriangleView: UIView {
    var fillColor: UIColor = .mainWhite
    var cornerRadius: CGFloat = 1.5
    var isGradient: Bool = false
    var gradientColors: [CGColor] = []
    private var rates: [Double] = [0.0, 0.0, 0.0]
    private let maxRate: CGFloat = 5.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for model: TriangleGraphModel) {
        self.rates = model.rates
        self.fillColor = model.fillColor
        self.cornerRadius = model.cornerRadius
        self.isGradient = model.isGradient
        self.gradientColors = model.gradientColors
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let width = rect.width
        let centerX = rect.midX
        let centerY = rect.midY
        let radius = width / sqrt(3)
        
        let angles: [CGFloat] = [270, 30, 150] // 꼭짓점 각도 (도 단위)
        
        let points = zip(rates, angles).map { rate, angle in
            let normalized = CGFloat(rate) / maxRate
            let distance = normalized * radius
            let radian = angle * .pi / 180
            let x = centerX + cos(radian) * distance
            let y = centerY + sin(radian) * distance
            return CGPoint(x: x, y: y+16.5)
        }
        
        let path = UIBezierPath()
        guard let first = points.first else { return }
        path.move(to: first)
        
        for i in 0..<points.count {
            let prev = points[(i - 1 + 3) % 3]
            let current = points[i]
            let next = points[(i + 1) % 3]
            path.moveRounded(from: prev, to: current, next: next, radius: cornerRadius)
        }
        path.close()
        
        if isGradient {
            configureGradient(ctx: ctx, path: path, rect: rect)
            layer.compositingFilter = "multiplyBlendMode"
            layer.shadowColor = UIColor.mainShadow.withAlphaComponent(0.3).cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 10
            layer.shadowOpacity = 1.0
        } else {
            ctx.addPath(path.cgPath)
            ctx.setFillColor(fillColor.cgColor)
            ctx.fillPath()
        }
    }
}

extension RateTriangleView {
    private func configureGradient(ctx: CGContext,
                                   path: UIBezierPath,
                                   rect: CGRect) {
        guard !self.gradientColors.isEmpty else { return }
        
        ctx.saveGState()
        ctx.addPath(path.cgPath)
        ctx.clip()
        
        let colors = self.gradientColors as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 1.0])!
        
        let startPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let endPoint = CGPoint(x: rect.minX, y: rect.maxY)
        ctx.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        ctx.restoreGState()
    }
}

// MARK: - Rouneded Corner
fileprivate extension UIBezierPath {
    func moveRounded(from p0: CGPoint, to p1: CGPoint, next p2: CGPoint, radius: CGFloat) {
        let v1 = CGVector(dx: p1.x - p0.x, dy: p1.y - p0.y)
        let v2 = CGVector(dx: p2.x - p1.x, dy: p2.y - p1.y)
        
        let len1 = hypot(v1.dx, v1.dy)
        let len2 = hypot(v2.dx, v2.dy)
        let inset1 = radius / len1
        let inset2 = radius / len2
        
        let start = CGPoint(x: p1.x - v1.dx * inset1, y: p1.y - v1.dy * inset1)
        let end   = CGPoint(x: p1.x + v2.dx * inset2, y: p1.y + v2.dy * inset2)
        
        self.addLine(to: start)
        self.addQuadCurve(to: end, controlPoint: p1)
    }
}
