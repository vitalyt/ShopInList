#if os(iOS)
import CloudKit
import SwiftUI

struct CloudSharingView: UIViewControllerRepresentable {
  let share: CKShare
  let container: CKContainer
  let model: CDProduct

  func makeCoordinator() -> CloudSharingCoordinator {
    CloudSharingCoordinator(model: model)
  }

  func makeUIViewController(context: Context) -> UICloudSharingController {
    share[CKShare.SystemFieldKey.title] = model.name
    let controller = UICloudSharingController(share: share, container: container)
    controller.modalPresentationStyle = .formSheet
    controller.delegate = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: UICloudSharingController, context: Context) {
  }
}

final class CloudSharingCoordinator: NSObject, UICloudSharingControllerDelegate {
  let stack = CoreDataStack.shared
  let model: CDProduct
  init(model: CDProduct) {
    self.model = model
  }

  func itemTitle(for csc: UICloudSharingController) -> String? {
    model.name
  }

  func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
    print("Failed to save share: \(error)")
  }

  func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
    print("Saved the share")
  }

  func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
    if !stack.isOwner(object: model) {
      stack.delete(model)
    }
  }
}
#endif
