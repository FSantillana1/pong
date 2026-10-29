//
//  GameScene.swift
//  Pong
//
//  Created by Fernando Santillana on 20/10/26.
//
import SpriteKit

final class GameScene: SKScene {
    
    private let ballRadius: CGFloat = 12
    private let ballSpeed: CGFloat = 450
    private let ball = SKShapeNode()
    private let minimumVerticalSpeed: CGFloat = 120
    
    private let paddleSize = CGSize(width: 110, height: 6)
    private let playerPaddle = SKShapeNode()
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = .zero
        view.showsPhysics = true
        setUpWalls()
        setUpPlayerPaddle(in: view)
        setUpBall()
        launchBall()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        movePaddle(with: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        movePaddle(with: touches)
    }
    
    private func movePaddle(with touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let targetX = touch.location(in: self).x
        let halfWidth = paddleSize.width / 2
        playerPaddle.position.x = min(max(targetX, halfWidth), size.width - halfWidth)
    }
    
    override func update(_ currentTime: TimeInterval) {
        keepBallAtConstantSpeed()
    }
    
    private func keepBallAtConstantSpeed() {
        guard let body = ball.physicsBody else { return }
        var velocity = body.velocity
        
        if abs(velocity.dy) < minimumVerticalSpeed {
            velocity.dy = velocity.dy < 0 ? -minimumVerticalSpeed : minimumVerticalSpeed
        }
        
        let currentSpeed = hypot(velocity.dx, velocity.dy)
        guard currentSpeed > 0 else { return }
        
        let scale = ballSpeed / currentSpeed
        body.velocity = CGVector(dx: velocity.dx * scale, dy: velocity.dy * scale)
        
        
    }
    
    private func setUpWalls() {
        let bottomLeft = CGPoint(x: 0, y: 0)
        let bottomRight = CGPoint(x: size.width, y: 0)
        let topLeft = CGPoint(x: 0, y: size.height)
        let topRight = CGPoint(x: size.width, y: size.height)
        
        addWall(from: bottomLeft, to: topLeft)
        addWall(from: bottomRight, to: topRight)
        addWall(from: topLeft, to: topRight)
        addWall(from: bottomLeft, to: bottomRight)
        
    }
    
    private func addWall(from start: CGPoint, to end: CGPoint) {
        let wall = SKNode()
        let body = SKPhysicsBody(edgeFrom: start, to: end)
        body.friction = 0
        body.restitution = 1
        wall.physicsBody = body
        addChild(wall)
    }
    
    private func setUpBall() {
        ball.path = CGPath(ellipseIn: CGRect(x: -ballRadius, y: -ballRadius, width: ballRadius * 2, height: ballRadius * 2), transform: nil)
        ball.fillColor = .white
        ball.strokeColor = .clear
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        
        let body = SKPhysicsBody(circleOfRadius: ballRadius)
        body.friction = 0
        body.restitution = 1
        body.linearDamping = 0
        body.angularDamping = 0
        body.allowsRotation = false
        body.usesPreciseCollisionDetection = true
        ball.physicsBody = body
        
        addChild(ball)
    }
    
    private func launchBall() {
        let spread = CGFloat.random(in: -0.5...0.5)
        let direction: CGFloat = Bool.random() ? 1 : -1
        ball.physicsBody?.velocity = CGVector(
            dx: ballSpeed * sin(spread),
            dy: ballSpeed * cos(spread) * direction
        )
    }
    private func setUpPlayerPaddle(in view: SKView) {
        let rect = CGRect(x: -paddleSize.width / 2, y: -paddleSize.height / 2, width: paddleSize.width, height: paddleSize.height)
        
        playerPaddle.path = CGPath(roundedRect: rect,
                                   cornerWidth: paddleSize.height / 2,
                                   cornerHeight: paddleSize.height / 2,
                                   transform: nil)
        
        playerPaddle.fillColor = .white
        playerPaddle.strokeColor = .clear
        
        let bottomMargin = view.safeAreaInsets.bottom + 60
        playerPaddle.position = CGPoint(x: frame.midX, y: bottomMargin)
        
        let body = SKPhysicsBody(rectangleOf: paddleSize)
        body.isDynamic = false
        body.friction = 0
        body.restitution = 1
        playerPaddle.physicsBody = body
        
        addChild(playerPaddle)
    }
}
