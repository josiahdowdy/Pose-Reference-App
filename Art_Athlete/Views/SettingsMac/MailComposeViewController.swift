//
//  MailComposeViewController.swift
//  Art_Athlete
//
//  Created by josiah on 2021-12-20.
//

import Foundation
import SwiftUI
import MessageUI

struct MailComposeViewController: UIViewControllerRepresentable {
    var toRecipients: [String]
    var mailBody: String

    var didFinish: ()->()

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailComposeViewController>) -> MFMailComposeViewController {

        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients(self.toRecipients)
        mail.setMessageBody(self.mailBody, isHTML: true)

        return mail
    }

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        var parent: MailComposeViewController

        init(_ mailController: MailComposeViewController) {
            self.parent = mailController
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.didFinish()
            controller.dismiss(animated: true)
        }
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailComposeViewController>) {

    }
}
