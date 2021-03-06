# Swift iOS ANE  

Example Xcode project showing how to create Air Native Extensions for iOS using Swift.
It supports iOS 9.0+

This project is used as the basis for the following ANEs   
[Google Maps ANE](https://github.com/tuarua/Google-Maps-ANE)   
[AdMob ANE](https://github.com/tuarua/AdMob-ANE)  


-------------

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

It is comprised of 3 parts.

1. A static library which exposes methods to AIR and a thin ObjectiveC API layer to the Swift code.
2. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
3. A dynamic Swift Framework which contains the main logic of the ANE.

> To allow FRE functions to be called from within Swift a protocol acting 
> as a bridge back to Objective C was used.

SwiftIOSANE_LIB/SwiftIOSANE_LIB.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the number of methods here 

````objectivec
static FRENamedFunction extensionFunctions[] =
{
 MAP_FUNCTION(TRSOA, load)
,MAP_FUNCTION(TRSOA, goBack)
};
`````


SwiftIOSANE_FW/SwiftController.swift  
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

````swift
@objc public func getFunctions(prefix: String) -> Array<String> {
functionsToSet["\(prefix)load"] = load
functionsToSet["\(prefix)goBack"] = goBack    
}
`````

Add Swift method(s)

````swift
func load(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}

func goBack(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}
`````

----------

### How to use
###### Converting from FREObject args into Swift types, returning FREObjects
The following table shows the primitive as3 types which can easily be converted to/from Swift types


| AS3 type | Swift type | AS3 param->Swift | return Swift->AS3 |
|:--------:|:--------:|:--------------|:-----------|
| String | String | let str = String(argv[0]) | return str.toFREObject()|
| int | Int | let i = Int(argv[0]) | return i.toFREObject()|
| Boolean | Bool | let b = Bool(argv[0]) | return b.toFREObject()|
| Number | Double | let dbl = Double(argv[0]) | return dbl.toFREObject()|
| Number | CGFloat | let cfl = CGFloat(argv[0]) | return cfl.toFREObject()|
| Date | Date | let date = Date(argv[0]) | return date.toFREObject()|
| Rectangle | CGRect | let rect = CGRect(argv[0]) | return rect.toFREObject()|
| Point | CGPoint | let pnt = CGPoint(argv[0]) | return pnt.toFREObject()|


Example
````swift
let airString = String(argv[0])
trace("String passed from AIR:", airString)
let swiftString: String = "I am a string from Swift"
return swiftString.toFREObject()
`````

FreSwift is fully extensible. New conversion types can be added in your own project. For example, Rectangle and Point are built as Extensions.

----------

Example - Call a method on an FREObject

````swift
let person = FreObjetSwift(argv[0])
if let addition: FreObjectSwift = try person.callMethod(name: "add", args: 100, 31) {
    if let sum: Int = addition.value as? Int {
        trace("addition result:", sum)
    }
}
`````

Example - Reading items in array
````swift
let airArray: FreArraySwift = FreArraySwift.init(freObject: inFRE0)
do {
    if let itemZero: FreObjectSwift = try airArray.getObjectAt(index: 0) {
        if let itemZeroVal: Int = itemZero.value as? Int {
            trace("AIR Array elem at 0 type:", "value:", itemZeroVal)
            let newVal = try FreObjectSwift.init(int: 56)
            try airArray.setObjectAt(index: 0, object: newVal)
            return airArray.rawValue
         }
    }
} catch {}
`````

Example - Convert BitmapData to a UIImage and add to native view
````swift
let asBitmapData = FreBitmapDataSwift.init(freObject: inFRE0)
defer {
    asBitmapData.releaseData()
}
do {
    if let cgimg = try asBitmapData.getAsImage() {
        let img:UIImage = UIImage.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
           let imgView: UIImageView = UIImageView.init(image: img)
           imgView.frame = CGRect.init(x: 0, y: 0, width: img.size.width, height: img.size.height)
           rootViewController.view.addSubview(imgView)
        }
    }
} catch {}
`````

Example - Error handling
````swift
do {
    _ = try person.getProperty(name: "doNotExist") //calling a property that doesn't exist
} catch let e as FreError {
    if let aneError = e.getError(#file, #line, #column) {
        return aneError //return the error as an actionscript error
    }
} catch {}
`````
----------
### Running on Simulator

The example project can be run on the Simulator from IntelliJ using AIR 26. AIR 27 beta contains a bug when packaging.

### Running on Device

The example project can be run on the device from IntelliJ using AIR27 Beta.
AIR 27 now correctly signs the included Swift frameworks and therefore no resigning tool is needed.

### Prerequisites

You will need

- Xcode 8.3 / AppCode
- IntelliJ IDEA
- AIR 26 RC and AIR 27 Beta
