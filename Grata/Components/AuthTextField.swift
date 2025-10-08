import SwiftUI
import UIKit

// A reusable auth text field with leading icon and optional password visibility toggle
struct AuthTextField<FocusField: Hashable>: View {
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    let field: FocusField
    let focus: FocusState<FocusField?>.Binding
    var isSecure: Bool = false
    var submitLabel: SubmitLabel = .next
    var onSubmit: (() -> Void)? = nil
    var disabled: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil

    @State private var isPasswordVisible = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundColor(.secondary)
                .frame(width: 22)

            ZStack(alignment: .trailing) {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .textContentType(.password)
                        .submitLabel(submitLabel)
                        .keyboardType(keyboardType)
                        .disabled(disabled)
                        .focused(focus, equals: field)
                        .onSubmit { onSubmit?() }
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(textContentType)
                        .submitLabel(submitLabel)
                        .keyboardType(keyboardType)
                        .disabled(disabled)
                        .focused(focus, equals: field)
                        .onSubmit { onSubmit?() }
                }

                if isSecure {
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing, 4)
                    .contentShape(Rectangle())
                    .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
                }
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.primary.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

struct AuthTextField_Previews: PreviewProvider {
    private struct PreviewWrapper: View {
        private enum InputField { case email, password }
        @State private var email = ""
        @State private var password = ""
        @FocusState private var focused: InputField?

        var body: some View {
            VStack(spacing: 16) {
                AuthTextField(
                    placeholder: "Email",
                    systemImage: "envelope.fill",
                    text: $email,
                    field: InputField.email,
                    focus: $focused,
                    isSecure: false,
                    submitLabel: .next,
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress
                )

                AuthTextField(
                    placeholder: "Password",
                    systemImage: "lock.fill",
                    text: $password,
                    field: InputField.password,
                    focus: $focused,
                    isSecure: true,
                    submitLabel: .go
                )
            }
            .padding()
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
    }
}
