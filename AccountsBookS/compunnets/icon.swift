//inside comunnet Icon

// icons


//for swift ui
// can call the icon from here

import SwiftUI

struct Icons: View {
    var customIcon: String
    var size: CGFloat
    var color : Color
    
    var body: some View {
        let iconName = determineIcon()
        
        return Image(systemName: iconName)
           
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(color)
      
           
    }
    
    private func determineIcon() -> String {
        switch customIcon {
        case "up":
            return "arrowshape.up.fill" //addd
        
        case "delete":
            return "trash.circle.fill" //addd
            
        case "next":
            return "arrowshape.right.circle.fill"  //addd
            
        case "befor":
            return "arrowshape.backward.circle.fill"  //addd
            
        case "add":
            return "plus.app" // add
        case "find":
            return "magnifyingglass.circle.fill" // add
        case "3dod":
            return "poweroutlet.type.l.fill" // add
        case "edit":
            return "square.and.pencil.circle.fill" //add
        case "pass":
            return "mappin.circle.fill" // add
        case "bank":
            return "building.columns.circle.fill" // add
        case "manu":
            return "list.bullet.circle.fill" //add
        case "close":
            return "xmark.circle.fill" // add
        case "ok":
            return "checkmark.seal.fill" // add
        case "newp":
            return "person.fill.badge.plus" // add
        case "prof":
            return "person.circle.fill" // add
        case "logout":
            return "power.circle.fill" // add
        case "gear":
            return "gear.circle.fill" // add
        case "dark":
            return "moon.circle.fill" // add
        default:
            return "exclamationmark.bubble.circle.fill"
        }
    }
}///checkmark.seal.fill

struct Icons_Previews: PreviewProvider {
    static var previews: some View {
        Icons( customIcon: "bank", size: 50, color: Color(.label))
    }
}
