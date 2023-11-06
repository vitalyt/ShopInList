//
//  ProductSectionEditView.swift
//  ShopInList
//
//  Created by Vitalii Todorovych on 04.09.2023.
//

import PhotosUI
import SwiftUI
import CloudKit

struct CDProductSectionEditView: View {
    var model: CDProductSection
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @Environment(\.dismiss) private var dismiss
    @State private var productName = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isShowPicker: Bool = false
    
    @State private var share: CKShare?
    @State private var showShareSheet = false
    @State private var showEditSheet = false
    private let stack = CoreDataStack.shared
    
    init(model: CDProductSection) {
        self.model = model
        self.selectedImageData = model.image?.imageData
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                PhotosPicker(selection: $selectedItem) {
                    Image(systemName: "photo")
                        .font(.headline)
                    Text("IMPORT").font(.headline)
                }
                .onChange(of: selectedItem) {
                    Task {
                        // Retrive selected asset in the form of Data
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            let productImage = CDProductImage(context: managedObjectContext)
                            productImage.imageData = data
                            model.image = productImage
                        }
                    }
                }
            if let imageData = model.image?.imageData,
                let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .cornerRadius(10)
                    }
            HStack {
                Text("Name:")
                TextField(model.name ?? "", text: $productName, onCommit: {
                    model.name = productName
                    dismiss()
                })
            }
        }
#if os(iOS)
        .textFieldStyle(RoundedBorderTextFieldStyle())
#endif
        .padding()
        .navigationBarBackButtonHidden(false)
        .navigationTitle(model.name ?? "")
#if os(iOS)
        .toolbar {
            ToolbarItem() {
                if !stack.isShared(object: model) {
                    Button {
                        Task {
                            await createShare(model)
                            try? CoreDataStack.shared.context.save()
                        }
                        showShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet, content: {
            if let share = share {
                ProductSectionCloudSharingView(share: share, container: stack.ckContainer, model: model)
            }
        })
#endif
    }
}

// MARK: Returns CKShare participant permission, methods and properties to share
extension CDProductSectionEditView {
  private func createShare(_ model: CDProductSection) async {
    do {
      let (_, share, _) = try await stack.persistentContainer.share([model], to: nil)
      share[CKShare.SystemFieldKey.title] = model.name
      self.share = share
    } catch {
      print("Failed to create share")
    }
  }

  private func string(for permission: CKShare.ParticipantPermission) -> String {
    switch permission {
    case .unknown:
      return "Unknown"
    case .none:
      return "None"
    case .readOnly:
      return "Read-Only"
    case .readWrite:
      return "Read-Write"
    @unknown default:
      fatalError("A new value added to CKShare.Participant.Permission")
    }
  }

  private func string(for role: CKShare.ParticipantRole) -> String {
    switch role {
    case .owner:
      return "Owner"
    case .privateUser:
      return "Private User"
    case .publicUser:
      return "Public User"
    case .unknown:
      return "Unknown"
    @unknown default:
      fatalError("A new value added to CKShare.Participant.Role")
    }
  }

  private func string(for acceptanceStatus: CKShare.ParticipantAcceptanceStatus) -> String {
    switch acceptanceStatus {
    case .accepted:
      return "Accepted"
    case .removed:
      return "Removed"
    case .pending:
      return "Invited"
    case .unknown:
      return "Unknown"
    @unknown default:
      fatalError("A new value added to CKShare.Participant.AcceptanceStatus")
    }
  }

  private var canEdit: Bool {
    stack.canEdit(object: model)
  }
}
