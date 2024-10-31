
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
    //Set up
    private func setupLabel(){
        let labelSize: CGFloat = 100
        timeLabel.frame = CGRect(x: 0, y: 0, width: labelSize, height: labelSize)
        timeLabel.center = view.center
        timeLabel.font = UIFont.systemFont(ofSize: 14,weight: .bold)
        //        calculateTime()
        timeLabel.text = convertTime(remainingSecond: countdownTime)
    }
    
    private func setupButton(){
        btnStart.setTitle("Start", for: .normal)
        btnStart.setTitleColor(.black, for: .normal)
        btnStart.titleLabel?.font = UIFont.systemFont(ofSize: 14,weight: .bold)
        btnStart.layer.cornerRadius = 8
        
        btnReset.setTitle("Reset", for: .normal)
        btnReset.setTitleColor(.white, for: .normal)
        btnReset.layer.borderColor = UIColor.white.cgColor
        btnReset.layer.borderWidth = 1
        btnReset.titleLabel?.font = UIFont.systemFont(ofSize: 14,weight: .bold)
        btnReset.layer.cornerRadius = 8
        
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2)
        btnStart.configuration = configuration
        btnReset.configuration = configuration
    }
    //Draw circle
    private func createCircularPath() {
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
            radius: 50,
            startAngle: -CGFloat.pi/2,
            endAngle: 3/2 * CGFloat.pi,
            clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.systemOrange.cgColor
        circleLayer.lineWidth = 1
        circleLayer.strokeEnd = 1
        
        view.layer.addSublayer(circleLayer)
    }
    //Actions
    @IBAction func reset(_ sender: Any) {
        timer?.invalidate()
        countdownTime = fixedTime
        //        calculateTime()
        btnStart.setTitle("Start", for: .normal)
        isStarted = false
        circleLayer.strokeEnd = 1
        timeLabel.text = convertTime(remainingSecond: fixedTime)
        circleLayer.removeAllAnimations()
    }
    @IBAction func start(_ sender: Any) {
        if btnStart.titleLabel?.text == "Start"{
            btnStart.setTitle("Pause", for: .normal)
            if !isStarted{
                isStarted = !isStarted
                startClock()
            } else  {
                startClock(resume: true)
            }
        }
        else if btnStart.titleLabel?.text == "Pause"{
            btnStart.setTitle("Start", for: .normal)
            timer?.invalidate()
        }
    }
    //Timer logic
    private func startClock(resume: Bool = false) {
        updateTimerCounter()
        if resume {
            // Resume the timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerCounter), userInfo: nil, repeats: true)
        } else {
            // Start the timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerCounter), userInfo: nil, repeats: true)
        }
    }
    @objc func updateTimerCounter(){
        if countdownTime == 0 {
            resetCounting()
            return
        }
        countdownTime -= 1
        updateRingProgress()
        timeLabel.text = convertTime(remainingSecond: countdownTime)
    }
    private func convertTime (remainingSecond : Int) -> String {
        let minutes : Int = remainingSecond / 60
        let seconds = remainingSecond % 60
        return String(format: "%02d:%02d",  minutes, seconds)
    }
    //update progress
    private func updateRingProgress() {
        let progress = CGFloat(countdownTime) / CGFloat(fixedTime)
        circleLayer.strokeEnd = progress
    }
    private func resetCounting(){
        timer?.invalidate()
    }
    deinit{
        resetCounting()
    }
}
