import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

struct PetImageView: View {
    let pet: Pet
    let image: UIImage?
    let size: CGFloat
    let showEditButton: Bool
    let onEditTap: (() -> Void)?
    
    init(pet: Pet, image: UIImage? = nil, size: CGFloat = 100, showEditButton: Bool = false, onEditTap: (() -> Void)? = nil) {
        self.pet = pet
        self.image = image
        self.size = size
        self.showEditButton = showEditButton
        self.onEditTap = onEditTap
    }
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: size, height: size)
                
                Image(systemName: pet.species.icon)
                    .font(.system(size: size * 0.4))
                    .foregroundColor(.blue)
            }
            
            if showEditButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            onEditTap?()
                        }) {
                            Image(systemName: "camera.fill")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
    }
} 