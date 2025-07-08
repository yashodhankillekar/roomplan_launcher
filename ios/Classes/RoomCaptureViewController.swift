import UIKit
import RoomPlan
import Flutter

@objc public class RoomCaptureViewController: UIViewController, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {

    private var isScanning = false
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfig = RoomCaptureSession.Configuration()
    private var finalResults: CapturedRoom?
    public  var usdzFilePath: String?
    private let finishButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let cancelButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRoomCaptureView()
        activityIndicator.stopAnimating()
    }

    @objc public static func isSupported() -> Bool {
        if #available(iOS 16.0, *) {
            return RoomCaptureSession.isSupported
        }
        return false
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Configure Finish Button
        finishButton.setTitle("Finish", for: .normal)
        finishButton.isEnabled = false
        finishButton.isHidden = true
        finishButton.alpha = 0.0
        finishButton.backgroundColor = UIColor.systemBlue
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.layer.cornerRadius = 12
        finishButton.addTarget(self, action: #selector(finishAndReturnResult), for: .touchUpInside)

        // Configure Cancel and Done Buttons
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelScanning), for: .touchUpInside)

        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneScanning), for: .touchUpInside)

        // Add subviews
        [finishButton, cancelButton, doneButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        // Layout constraints
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),

            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),

            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            finishButton.widthAnchor.constraint(equalToConstant: 120),
            finishButton.heightAnchor.constraint(equalToConstant: 44),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupRoomCaptureView() {
        roomCaptureView = RoomCaptureView(frame: .zero)
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        roomCaptureView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(roomCaptureView, at: 0)

        NSLayoutConstraint.activate([
            roomCaptureView.topAnchor.constraint(equalTo: view.topAnchor),
            roomCaptureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            roomCaptureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomCaptureView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }

    private func startSession() {
        isScanning = true
        roomCaptureView.captureSession.run(configuration: roomCaptureSessionConfig)
        
        // Hide Finish button
        finishButton.isHidden = true
        finishButton.alpha = 0.0

        // Show Done button again (in case it was hidden before)
        doneButton.isHidden = false
        doneButton.alpha = 1.0
    }

    private func stopSession() {
        isScanning = false
        roomCaptureView.captureSession.stop()

        // Show Finish button
        finishButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.finishButton.alpha = 1.0
        }

        // Hide Done button
        UIView.animate(withDuration: 0.3) {
            self.doneButton.alpha = 0.0
        } completion: { _ in
            self.doneButton.isHidden = true
        }
    }

    public func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }

    public func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResults = processedResult
        finishButton.isEnabled = true
        activityIndicator.stopAnimating()

        // Export USDZ file
        exportToUSDZ()
    }

    private func exportToUSDZ() {
        guard let finalResults = finalResults else { return }
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let roomScansFolder = documentsPath.appendingPathComponent("room_scans")
            
            // Create the RoomScans directory if it doesn't exist
            if !FileManager.default.fileExists(atPath: roomScansFolder.path) {
                try FileManager.default.createDirectory(at: roomScansFolder, withIntermediateDirectories: true)
            }
            
            let fileName = "scan_\(Int(Date().timeIntervalSince1970)).usdz"
            let fileURL = roomScansFolder.appendingPathComponent(fileName)
            try finalResults.export(to: fileURL)
            self.usdzFilePath = fileURL.path
        } catch {
            print("Failed to export USDZ file: \(error)")
        }
    }

    @objc private func doneScanning() {
        if isScanning {
            stopSession()
        } else {
            cancelScanning()
        }
        finishButton.isEnabled = false
        activityIndicator.startAnimating()
    }

    @objc private func cancelScanning() {
        self.dismiss(animated: true)
    }

    @objc private func finishAndReturnResult() {
        guard let finalResults = finalResults else {
            self.dismiss(animated: true)
            return
        }

        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(finalResults)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                // Send data to Flutter via MethodChannel
                if let controller = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
                    let channel = FlutterMethodChannel(name: "in.yashodhankillekar/roomplan_launcher", binaryMessenger: controller.binaryMessenger)
                    channel.invokeMethod("onRoomCaptureFinished", arguments: jsonString)
                }
            }
        } catch {
            print("Failed to encode finalResults: \\(error)")
        }

        self.dismiss(animated: true)
    }
}
