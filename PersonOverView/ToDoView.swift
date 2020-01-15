//
//  ToDoView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 30/12/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI

var toDo =
"""
 E n d r i n g e r :

 1. .sheet Vedlikehold:
        a) Legg inn avslutt

 2. .sheet Slett:
       a) Legg inn avslutt med Spørsmål

 F e r d i g :

 1. Reduserte meldinger i SignInView.swift
 2. Reduserte meldinger i SignUpView.swift
 3. Ta bort "online keyboard"
    ... Lagt inn .modifier(DismissingKeyboard())
 4. Reduserer nå størrelsen på bildet som blir lagret på CloudKit.
 5. Viser nå kun lagret bilde i CloudKit.
    ... Uten lagret bilde vises et blankt bilde i SignInView.swift
 6. Endre "Feil e-Post eller passord" til "Ukjent ...."
 7. Endret fra UserMaintenanceView().environmentObject(User()
    til : UserMaintenanceView().environmentObject(self.user)
 8. Ny .sheet som inneholder :
       a) Endre profil bilde
       b) Endre navn
       c) Endre e-Post
       d) Endre passord
 9. Lagt inn "slett bruker" meny
10. "Sign up" -> Registrer(ing)
11. Blanke feltene etter:
       a) "Meld deg inn"
       b) "Slett"
12. "Innlogging CloudKit":
       a) "Bruker vedlikehold" går tilbake til "Innlogging CloudKit"
           Løsning: Flytte .sheet rett etter hver "Button"

S e n e r e (om mulig) :

1. Trykke på bildet istedet for på teksten i "SignUpView.swift"
   ... Bruk: .contextMenu

"""

struct ToDoView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("To be done")
                    .font(.title)
                    .padding()
                Text(toDo)
                    .font(.custom("courier", size: 16))
                    .foregroundColor(.none)
                    .multilineTextAlignment(.leading)
            }

        }
    }
}

/// Image Resizing Techniques
/// https://nshipster.com/image-resizing/#technique-1-drawing-to-a-uigraphicsimagerenderer
func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
    guard let image = UIImage(contentsOfFile: url.path) else {
        return nil
    }
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
        image.draw(in: CGRect(origin: .zero, size: size))
    }
}

