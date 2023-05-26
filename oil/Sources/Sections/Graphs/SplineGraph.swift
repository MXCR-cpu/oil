//
//  SplineGraph.swift
//  oil
//
//  Created by Maximus on 5/23/23.
//
// Spline Creation Source:
// https://www.math.ucla.edu/~baker/149.1.02w/handouts/dd_splines/node6.html
//

import Foundation
import AppKit
import Defaults
import SwiftUI
import LASwift


class SplineGraph: Graph {
    private var testPoints: [CGPoint] = [
        CGPoint(x: 1, y: -1),
        CGPoint(x: -1, y: 2),
        CGPoint(x: 1, y: 4),
        CGPoint(x: 4, y: 3),
        CGPoint(x: 7, y: 5),
    ]
    
    override init() {
        super.init()
        type = .spline
    }
    
    override func draw(data: [Int]) -> Path {
        var index: Int = 0
        var points: [CGPoint] = data.compactMap {
            index += 1
            return CGPoint(x: CGFloat(stepSize * (historyLength - index)),
                           y: getY(val: $0))
        }
        for i in (points.count)..<historyLength {
            points.append(CGPoint(x: CGFloat(stepSize * (historyLength - i - 1)),
                                  y: 0))
        }
        points.reverse()
        let BSplineControlPoints: [CGPoint] =
            createBSplineControlPoints(data: points)
        let controlPoints: [[CGPoint]] =
            createSplineControlPoints(data: [points[0]] +
                                      BSplineControlPoints +
                                      [points[points.count-1]])
        var path: Path = createSplinePath(points: points,
                                          controlPoints: controlPoints)
        if Defaults[.graphFill] {
            path.addLine(to: CGPoint(x: stepSize * (historyLength - 1),
                                     y: 0))
            path.addLine(to: .zero)
            path.closeSubpath()
        }
        return path
    }
    
    private func getY(val: Int) -> CGFloat {
        return CGFloat(18 * val) / 100
    }
    
    private func createSplinePath(points: [CGPoint],
                                  controlPoints: [[CGPoint]]) -> Path {
        var path: Path = Path()
        path.move(to: points[0])
        for i in 1..<points.count {
            path.addCurve(to: points[i],
                          control1: controlPoints[i-1][0],
                          control2: controlPoints[i-1][1])
        }
        return path
    }
    
    private func createSplineControlPoints(data: [CGPoint]) -> [[CGPoint]] {
        var controlPoints: [[CGPoint]] = []
        for i in 0..<(data.count-1) {
            let lengthDifference: CGPoint = data[i+1] - data[i]
            controlPoints.append([
                (((1/3) * lengthDifference) + data[i]).rounded(places: 2),
                (((2/3) * lengthDifference) + data[i]).rounded(places: 2)
            ])
        }
        return controlPoints
    }
    
    private func createBSplineControlPoints(data: [CGPoint]) -> [CGPoint] {
        var ansVector: [CGPoint] = [(6 * data[1]) - data[0]]
        if data.count < 5 {
            return ansVector
        }
        for i in 2..<data.count-2 {
            ansVector.append(6 * data[i])
        }
        ansVector.append((6 * data[data.count - 2]) - data[data.count-1])
        let pointsMatrix: Matrix =
            convertPointsToMatrix(data: ansVector)
        let transformMatrix: Matrix =
            createTransformationMatrix(width: data.count - 2)
        let BSplineControlPointMatrix: Matrix =
            mtimes(inv(transformMatrix), pointsMatrix)
        let BSplineControlPointArray: [CGPoint] =
            convertMatrixToPoints(data: BSplineControlPointMatrix)
        return BSplineControlPointArray
    }
    
    private func convertPointsToMatrix(data: [CGPoint]) -> Matrix {
        var vals: [Vector] = data.compactMap { _ in return Vector() }
        for i in 0..<data.count {
            vals[i].append(data[i].x)
            vals[i].append(data[i].y)
        }
        return Matrix(vals)
    }
    
    private func convertMatrixToPoints(data: Matrix) -> [CGPoint] {
        var vals: [CGPoint] = []
        let len: Int = (data.flat.count - 1) / 2
        for i in 0...len {
            vals.append(CGPoint(x: data.flat[2*i], y: data.flat[(2*i)+1]))
        }
        return vals
    }
    
    private func createTransformationMatrix(width: Int) -> Matrix {
        var vals: [Vector] = []
        for i in 0..<width {
            vals.append(Vector())
            for j in 0..<width {
                vals[i].append(Double(max((-3 * abs(j - i)) + 4, 0)))
            }
        }
        return Matrix(vals)
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: (lhs * rhs.x).rounded(places: 2),
                       y: (lhs * rhs.y).rounded(places: 2))
    }
    
    func rounded(places: Int) -> Self {
        return CGPoint(x: self.x.rounded(places: places),
                       y: self .y.rounded(places: places))
    }
}

extension FloatingPoint {
    func rounded(places: Int) -> Self {
        let divisor: Self = Self(Int(pow(10, Double(places))))
        return (self * divisor).rounded() / divisor
    }
}
