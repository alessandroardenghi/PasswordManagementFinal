import Foundation
import SwiftUI

// functions to create squiggly lines at the bottom
struct Squiggly1: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let waveHeight = rect.height * 0.3
        let yOffset = rect.height * 0.8
        path.move(to: CGPoint(x: 0, y: yOffset))

        path.addCurve(to: CGPoint(x: rect.width, y: yOffset),
                      control1: CGPoint(x: rect.width * 0.25, y: yOffset + waveHeight),
                      control2: CGPoint(x: rect.width * 0.75, y: yOffset - waveHeight))

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        return path
    }
}

struct Squiggly2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let waveHeight = rect.height * 0.2
        let yOffset = rect.height * 0.67
        path.move(to: CGPoint(x: 0, y: yOffset))

        path.addCurve(to: CGPoint(x: rect.width, y: yOffset),
                      control1: CGPoint(x: rect.width * 0.05, y: yOffset + waveHeight),
                      control2: CGPoint(x: rect.width * 0.70, y: yOffset - waveHeight))

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        return path
    }
}

struct Squiggly3: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let waveHeight = rect.height * 0.2
        let yOffset = rect.height * 0.46
        path.move(to: CGPoint(x: 0, y: yOffset))

        path.addCurve(to: CGPoint(x: rect.width, y: yOffset),
                      control1: CGPoint(x: rect.width * 0.45, y: yOffset + waveHeight),
                      control2: CGPoint(x: rect.width * 0.90, y: yOffset - waveHeight))

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        return path
    }
}

struct BackView: View {
    var body: some View {
        VStack {
            Image("login_icon")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.top)

            Spacer()

            ZStack {
                Squiggly1()
                    .foregroundColor(.blue.opacity(1.1))
                    .frame(height: 300)
                    .offset(x: 0, y: 50)

                Squiggly2()
                    .foregroundColor(.blue.opacity(0.7))
                    .frame(height: 300)
                    .offset(x: 0, y: 30)

                Squiggly3()
                    .foregroundColor(.blue.opacity(0.3))
                    .frame(height: 300)
                    .offset(x: 0, y: 30)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct BackView2: View {
    var body: some View {
        VStack {
            Image("registration_icon_black")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.top)

            Spacer()

            ZStack {
                Squiggly1()
                    .foregroundColor(.blue.opacity(1.1))
                    .frame(height: 300)
                    .offset(x: 0, y: 50)

                Squiggly2()
                    .foregroundColor(.blue.opacity(0.7))
                    .frame(height: 300)
                    .offset(x: 0, y: 30)

                Squiggly3()
                    .foregroundColor(.blue.opacity(0.3))
                    .frame(height: 300)
                    .offset(x: 0, y: 30)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct BackView3: View {
    var body: some View {
        VStack {
            Image("registration_icon_white")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.top)

            Spacer()

            ZStack {
                Squiggly1()
                    .foregroundColor(.blue.opacity(1.1))
                    .frame(height: 300)
                    .offset(x: 0, y: 50)

                Squiggly2()
                    .foregroundColor(.blue.opacity(0.7))
                    .frame(height: 300)
                    .offset(x: 0, y: 30)

                Squiggly3()
                    .foregroundColor(.blue.opacity(0.3))
                    .frame(height: 300)
                    .offset(x: 0, y: 30)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
