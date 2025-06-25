
import UIKit
import RoomPlan

@objc public class RoomCaptureViewController: UIViewController, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {

    private var isScanning = false
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfig = RoomCaptureSession.Configuration()
    private var finalResults: CapturedRoom?

    private let exportButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRoomCaptureView()
        activityIndicator.stopAnimating()
    }

    private func setupUI() {
        view.backgroundColor = .white

        exportButton.setTitle("Export", for: .normal)
        exportButton.isEnabled = false
        exportButton.addTarget(self, action: #selector(exportResults), for: .touchUpInside)

        activityIndicator.center = view.center
        view.addSubview(activityIndicator)

        exportButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exportButton)
        NSLayoutConstraint.activate([
            exportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exportButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    private func setupRoomCaptureView() {
        roomCaptureView = RoomCaptureView(frame: view.bounds)
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        view.insertSubview(roomCaptureView, at: 0)
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
    }

    private func stopSession() {
        isScanning = false
        roomCaptureView.captureSession.stop()
    }

    public func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }

    public func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResults = processedResult
        exportButton.isEnabled = true
        activityIndicator.stopAnimating()
    }

    @objc private func exportResults() {
        guard let finalResults = finalResults else { return }

        let destinationFolderURL = FileManager.default.temporaryDirectory.appendingPathComponent("Export")
        let destinationURL = destinationFolderURL.appendingPathComponent("Room.usdz")
        let capturedRoomURL = destinationFolderURL.appendingPathComponent("Room.json")

        do {
            try FileManager.default.createDirectory(at: destinationFolderURL, withIntermediateDirectories: true)
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(finalResults)
            try jsonData.write(to: capturedRoomURL)
            try finalResults.export(to: destinationURL, exportOptions: .parametric)

            let activityVC = UIActivityViewController(activityItems: [destinationFolderURL], applicationActivities: nil)
            activityVC.modalPresentationStyle = .popover
            present(activityVC, animated: true, completion: nil)
            activityVC.popoverPresentationController?.sourceView = exportButton
        } catch {
            print("Export error: \(error)")
        }
    }
}
