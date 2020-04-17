# POC AR

## Liste des tricks

Au lancement de l'application, une liste de deux tricks appairait, "Ollie" ou "Kickflip", j'ai fait cela pour appliquer une rotation différente à mon objet 3D selon le trick sélectionné.

## Détection des surfaces planes

Une fois le choix de trick fait, on arrive sur la vue de la caméra, on peut voir des rectangles blancs apparaîtres. Ils apparaissent que sur les surfaces planes, j'ai mis en a place ça pour mieux me rendre compte de la détection des surfaces planes.
```
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    
    // Enable horizontal plane detection
    configuration.planeDetection = .horizontal
    
    // Run the view's session
    sceneView.session.run(configuration)
}
```

```
if let planeAnchor = anchor as? ARPlaneAnchor {
       let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)); plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.7)
       
       
       let planeNode = SCNNode(geometry: plane)
       
       planeNode.position = SCNVector3Make(
           planeAnchor.center.x,
           planeAnchor.center.y,
           planeAnchor.center.z)
       planeNode.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 2.0)
       ...
```

## Affichage d'un objet 3D dès qu'une surface plane est détectée

Dès qu'une surface plane va être détectée, un skate va apparaitre en réalité augmentée sur  l'écran.


## Animations et modification d'un objet

Lorsqu'on est sur la vue réalité augmentée et que l'on touche l'écran, l'animation de rotation s'exécute. Celle-ci est différente selon le choix du trick fait à l'écran précédent.

```
switch trick {
case "Ollie":
skate.runAction(SCNAction.Tricks.Ollie)
break
case "Kickflip" :
skate.runAction(SCNAction.Tricks.Kickflip)
break
default:
return
}

```
Modification des propriétés d'un objet dans l'optique de mettre en avant des zones sur le skate
```
if let box =  sceneView.scene.rootNode.childNode(withName: "box", recursively: true) {
    box.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
}
```


## Tricks
Pour les tricks, j'ai décidé de créer une structure qui est une extension de SCNAction afin de centraliser mes animations/tricks

```
extension SCNAction{
    struct Tricks {
        static var Ollie: SCNAction { return SCNAction.moveBy(x: 0, y: 20, z: 0, duration: 0.5)}
        static var rotationX: SCNAction { return SCNAction.rotateBy(x: CGFloat(2 * Double.pi), y: 0, z: 0, duration: 0.5)}
        static var Kickflip: SCNAction { return SCNAction.group([Ollie,rotationX])}
    }
}

```

Ce qui me permet après de call mes tricks plus simplement et de manière lisible :
```
skate.runAction(SCNAction.Tricks.Ollie)

```

