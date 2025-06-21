import SwiftUI

struct FriendsSection: View {
    @EnvironmentObject var petStore: PetStore
    @State private var showingAddPost = false
    @State private var selectedPet: Pet?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Mis Amigos")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                Button(action: { showingAddPost = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            
            if petStore.getAllPosts().isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "pawprint.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No hay fotos compartidas")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("¡Sé el primero en compartir una foto!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(petStore.getAllPosts().prefix(3)) { post in
                        PostCardView(post: post)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddPost) {
            AddPostView()
                .environmentObject(petStore)
        }
    }
}

struct PostCardView: View {
    @EnvironmentObject var petStore: PetStore
    let post: Post
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                if let petImage = post.petImage {
                    Image(uiImage: petImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "pawprint.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.petName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(dateFormatter.string(from: post.createdAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Post image
            if let image = post.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .cornerRadius(8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: "photo")
                                .font(.title)
                                .foregroundColor(.gray)
                            Text("Sin foto")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    )
            }
            
            // Actions - Only paw likes
            HStack(spacing: 20) {
                Button(action: {
                    if let currentPet = petStore.pets.first {
                        petStore.likePost(post, by: currentPet.id)
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: post.likes.contains(petStore.pets.first?.id ?? UUID()) ? "pawprint.fill" : "pawprint")
                            .foregroundColor(post.likes.contains(petStore.pets.first?.id ?? UUID()) ? .red : .gray)
                        Text("\(post.likeCount)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AddPostView: View {
    @EnvironmentObject var petStore: PetStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPet: Pet?
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingPetPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Seleccionar Mascota") {
                    if let selectedPet = selectedPet {
                        HStack {
                            PetImageView(pet: selectedPet, image: selectedPet.image, size: 40)
                            VStack(alignment: .leading) {
                                Text(selectedPet.name)
                                    .font(.headline)
                                Text(selectedPet.breed)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    } else {
                        Button("Seleccionar mascota") {
                            showingPetPicker = true
                        }
                    }
                }
                
                Section("Foto") {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 200)
                                    .cornerRadius(8)
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 200)
                                    .overlay(
                                        VStack {
                                            Image(systemName: "photo")
                                                .font(.title)
                                                .foregroundColor(.gray)
                                            Text("Sin foto")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    )
                            }
                            
                            Button(selectedImage == nil ? "Agregar Foto" : "Cambiar Foto") {
                                showingImagePicker = true
                            }
                            .font(.caption)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Nueva Foto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Compartir") {
                        savePost()
                    }
                    .disabled(selectedPet == nil || selectedImage == nil)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingPetPicker) {
                PetPickerView(selectedPet: $selectedPet)
                    .environmentObject(petStore)
            }
        }
    }
    
    private func savePost() {
        guard let pet = selectedPet else { return }
        
        let post = Post(
            petId: pet.id,
            petName: pet.name,
            petImageData: pet.imageData,
            imageData: selectedImage?.jpegData(compressionQuality: 0.8)
        )
        
        petStore.addPost(post)
        dismiss()
    }
}

struct PetPickerView: View {
    @EnvironmentObject var petStore: PetStore
    @Binding var selectedPet: Pet?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(petStore.pets) { pet in
                Button(action: {
                    selectedPet = pet
                    dismiss()
                }) {
                    HStack {
                        PetImageView(pet: pet, image: pet.image, size: 40)
                        VStack(alignment: .leading) {
                            Text(pet.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(pet.breed)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Seleccionar Mascota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FriendsSection()
        .environmentObject(PetStore())
} 