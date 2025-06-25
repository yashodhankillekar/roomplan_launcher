import UIKit
import RoomPlan

@objc public class RoomCaptureViewController: UIViewController, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {

    private var isScanning = false
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfig = RoomCaptureSession.Configuration()
    private var finalResults: CapturedRoom?

    private let exportButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let cancelButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRoomCaptureView()
        activityIndicator.stopAnimating()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Configure Export Button
        exportButton.setTitle("Export", for: .normal)
        exportButton.isEnabled = false
        exportButton.addTarget(self, action: #selector(exportResults), for: .touchUpInside)

        // Configure Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelScanning), for: .touchUpInside)

        // Configure Done Button
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneScanning), for: .touchUpInside)

        // Add subviews
        [exportButton, cancelButton, doneButton, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        // Layout constraints
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),

            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),

            exportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),

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

    @objc private func doneScanning() {
        if isScanning {
            stopSession()
        } else {
            cancelScanning()
        }
        exportButton.isEnabled = false
        activityIndicator.startAnimating()
    }

    @objc private func cancelScanning() {
        self.dismiss(animated: true)
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
            activityVC.popoverPresentationController?.sourceView = exportButton
            present(activityVC, animated: true)
        } catch {
            print("Export error: \\(error)")
        }
    }
}
