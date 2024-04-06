import SwiftUI
import PassKit

struct ApplePayButtonView: View {
  @State private var showingPaymentSheet = false

  var body: some View {
    PaymentButton(action: {
      self.showingPaymentSheet = true
    })
    .frame(height: 50)
    .padding()
    .sheet(isPresented: $showingPaymentSheet) {
      PaymentAuthorizationViewControllerWrapper {
        // This closure will be called once the payment is processed.
        print("Payment Processed")
      }
    }
  }
}

@available(iOS 14.0, *)
struct PaymentButton: UIViewRepresentable {
  var action: () -> Void

  func makeUIView(context: Context) -> some UIView {
    let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
    button.addTarget(context.coordinator, action: #selector(Coordinator.pay), for: .touchUpInside)
    return button
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(action: action)
  }

  class Coordinator: NSObject {
    var action: () -> Void

    init(action: @escaping () -> Void) {
      self.action = action
    }

    @objc func pay() {
      action()
    }
  }
}

struct PaymentAuthorizationViewControllerWrapper: UIViewControllerRepresentable {
  var onCompletion: () -> Void

  func makeUIViewController(context: Context) -> UIViewController {
    let paymentRequest = createPaymentRequest()
    let viewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)!
    viewController.delegate = context.coordinator
    return viewController
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(onCompletion: onCompletion)
  }

  class Coordinator: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    var onCompletion: () -> Void

    init(onCompletion: @escaping () -> Void) {
      self.onCompletion = onCompletion
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
      controller.dismiss(animated: true, completion: nil)
      onCompletion()
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
      // Process the payment here
      completion(.success)
    }
  }
}

func createPaymentRequest() -> PKPaymentRequest {
  let request = PKPaymentRequest()
  request.merchantIdentifier = "merchant.bryandebourbon.coach"
  request.countryCode = "US"
  request.currencyCode = "USD"
  request.supportedNetworks = [.visa, .masterCard, .amex]
  request.merchantCapabilities = .threeDSecure
  request.paymentSummaryItems = [
    PKPaymentSummaryItem(label: "Item Name", amount: NSDecimalNumber(decimal: 10.00)),
    PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal: 10.00))
  ]
  return request
}
