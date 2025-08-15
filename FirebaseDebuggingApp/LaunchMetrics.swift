import UIKit
import FirebasePerformance

final class LaunchMetrics {
    static let shared = LaunchMetrics()
    
    private var firstForegroundObserved = false
    private var launchTrace: Trace?
    private var didMarkFirstFrame = false
    private var notedBackgroundFetch = false
    
    private init() {}
    
    func install() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func noteBackgroundFetch() {
        notedBackgroundFetch = true
    }
    
    func markFirstFrameDrawn() {
        guard let trace = launchTrace, !didMarkFirstFrame else { return }
        didMarkFirstFrame = true
        trace.setValue("stop_reason", forAttribute: "first_frame")
        trace.stop()
        NSLog("[LaunchMetrics] launch_first_frame STOP (first frame)")
        launchTrace = nil
    }
    
    @objc private func didBecomeActive() {
        guard !firstForegroundObserved else { return }
        firstForegroundObserved = true
        
        let perf = Performance.sharedInstance()
        perf.isDataCollectionEnabled = true
        perf.isInstrumentationEnabled = true
        NSLog("[LaunchMetrics] Firebase Performance ENABLED on first foreground")
        
        let t = Performance.startTrace(name: "launch_first_frame")
        t?.setValue("launch_type", forAttribute: notedBackgroundFetch ? "foreground_after_bgfetch" : "foreground")
        launchTrace = t
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self, let trace = self.launchTrace, !self.didMarkFirstFrame else { return }
            trace.setValue("stop_reason", forAttribute: "timeout_3s")
            trace.stop()
            NSLog("[LaunchMetrics] launch_first_frame AUTO-STOP (timeout)")
            self.launchTrace = nil
        }
    }
    
    @objc private func willResignActive() {
        guard let trace = launchTrace, !didMarkFirstFrame else { return }
        trace.setValue("cancel_reason", forAttribute: "resign_active_before_first_frame")
        trace.setValue("launch_type", forAttribute: "background_interrupted")
        trace.stop()
        NSLog("[LaunchMetrics] launch_first_frame CANCEL (resign active)")
        launchTrace = nil
    }
    
    @objc private func didEnterBackground() {
        firstForegroundObserved = false
        didMarkFirstFrame = false
        notedBackgroundFetch = false
    }
}
