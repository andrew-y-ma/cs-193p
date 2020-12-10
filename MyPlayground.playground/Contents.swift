import UIKit

var str = "Hello, playground"

var names = ["Jiim", "Jimbo"]

var indices = names.filter{ element in
    element.hasPrefix("Kim")
}

print(indices)
