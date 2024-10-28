
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var btnReset: UIButton!
    var timer:Timer?
    var hour:Int = 0
    var minute:Int = 0
    var second:Int = 0
    let fixedTime = 25 * 60
    var countdownTime = 25 * 60
    let circleLayer = CAShapeLayer()
    var isStarted = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        createCircularPath()
        setupButton()
    }
    
    func setupLabel(){
        let labelSize: CGFloat = 100
        timeLabel.frame = CGRect(x: 0, y: 0, width: labelSize, height: labelSize)
        timeLabel.center = view.center
        
        //        timeLabel.layer.cornerRadius = timeLabel.frame.width/2
        //        timeLabel.layer.borderColor = UIColor.systemOrange.cgColor
        //        timeLabel.layer.borderWidth = 1
        calculateTime()
        timeLabel.text = String(format: "%02d:%02d", minute,second)
    }
    
    func setupButton(){
        btnStart.setTitle("Start", for: .normal)
        btnStart.titleLabel?.font = .boldSystemFont(ofSize: 24)
        btnStart.layer.cornerRadius = 8
        
        btnReset.setTitle("Reset", for: .normal)
        btnReset.titleLabel?.font = .boldSystemFont(ofSize: 24)
        btnReset.layer.cornerRadius = 8
        
    }
    func startAnimation(resume: Bool = false) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        if resume {
            // Resume from where it was paused
            animation.duration = CFTimeInterval(countdownTime)
            animation.fromValue = 1 - (Double(countdownTime) / Double(fixedTime))
            animation.toValue = 0
        } else {
            // Start from the beginning
            animation.duration = CFTimeInterval(countdownTime)
            animation.fromValue = 1
            animation.toValue = 0
        }
        
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        circleLayer.add(animation, forKey: "strokeEndAnimation")
        
        // Gradually change the color from orange to black
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.duration = CFTimeInterval(countdownTime)
        colorAnimation.fromValue = UIColor.systemOrange.cgColor
        colorAnimation.toValue = UIColor.black.cgColor
        colorAnimation.fillMode = .forwards
        colorAnimation.isRemovedOnCompletion = false
        circleLayer.add(colorAnimation, forKey: "strokeColorAnimation")
    }
    
    func startClock(resume: Bool = false) {
        updateTimer()
        if resume {
            // Resume the timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            // Start the timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            startAnimation(resume: resume)
        }
    }
    func createCircularPath() {
        // Create a circular path centered on the timeLabel's center
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
            radius: 100,
            startAngle: -90.degreeToRadians,
            endAngle: 270.degreeToRadians,
            clockwise: true)

        // Configure the circle layer
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.systemOrange.cgColor
        circleLayer.lineWidth = 1
        circleLayer.strokeEnd = 1


        view.layer.addSublayer(circleLayer)
    }


    @objc func updateTimer(){
        if countdownTime > 0{
            countdownTime -= 1
            calculateTime()
            timeLabel.text = String(format: "%02d:%02d", minute,second)
        }
        else{
            timer?.invalidate()
            timeLabel.text = "00:00"
        }
    }
    deinit{
        timer?.invalidate()
    }
    
    func calculateTime(){
        minute = (countdownTime % 3600)/60
        second = countdownTime % 60
    }
    
    @IBAction func reset(_ sender: Any) {
        timer?.invalidate()
        countdownTime = fixedTime
        calculateTime()
        btnStart.setTitle("Start", for: .normal)
        isStarted = false
        circleLayer.strokeEnd = 1
        
        timeLabel.text = String(format: "%02d:%02d", minute,second)
        circleLayer.removeAllAnimations()
    }
    @IBAction func start(_ sender: Any) {
        if btnStart.titleLabel?.text == "Start"{
            btnStart.setTitle("Pause", for: .normal)
            if !isStarted{
                isStarted = !isStarted
                startClock()
            } else  {
                startClock(resume: true)  // Resume the timer and animation
            }
            
        }
        else if btnStart.titleLabel?.text == "Pause"{
            btnStart.setTitle("Start", for: .normal)
            timer?.invalidate()
        }
    }
}

extension Int{
    var degreeToRadians: CGFloat{
        return CGFloat(self) * .pi/180
    }
}
