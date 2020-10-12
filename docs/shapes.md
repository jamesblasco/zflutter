---
layout: default
title: Shapes
nav_order: 3
permalink: /docs/shapes/
---


# Shapes
{: .no_toc}
`ZShapes` are a special type of Flutter widget that need to be inside a
    `ZIllustration` widget.




## Table of contents
{: .no_toc .text-delta }


1. TOC
{:toc}

---
## ZRect
A rectangle. Set size with `width` and `height`. Default sizes: `width: 1, height: 1`.
<div  class="code-box">
<div class="code-md" markdown="1">
```dart
ZRect(
    width: 120,
    height: 80,
    stroke: 20,
    color: Color(0xFFEE6622),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/rect">
</iframe>
</div>
</div>

All shapes are oriented facing "front" — towards the positive z-axis. Set rotate to orient a shape in another direction.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZGroup(
    children: [
        ZPositioned(
            translate: ZVector.only(x: -48),
            rotate: ZVector.only(y: tau / 4),
            child: ZRect(
                width: 80,
                height: 64,
                stroke: 10,
                color: Color(0xFFEE6622),
            ),
        ),
        ZPositioned(
            translate: ZVector.only(y: -48),
            rotate: ZVector.only(x: tau / 4),
            child: ZRect(
                width: 80,
                height: 64,
                stroke: 10,
                color: Color(0xFF663366),
            ),
        ),
    ],
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
     src="https://z.flutter.gallery/examples/#/demo/rects">
</iframe>
</div>
</div>
---

## ZRoundedRect
A rectangle with rounded corners. Set size with `width` and `height`, like with `ZRect`. Set rounded corner radius with `borderRadius`. Default: `cornerRadius: 0`.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZRoundedRect(
    width: 120,
    height: 80,
    borderRadius: 30,
    stroke: 20,
    color: Color(0xffEEAA00),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/rounded_rect">
</iframe>
</div>
</div>
---

## ZCircle
A circle. Set `diameter`.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZCircle(
    diameter: 80,
    stroke: 20,
    color: Color(0xFFCC2255),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
     src="https://z.flutter.gallery/examples/#/demo/circle">
</iframe>
</div>
</div>
---
## ZEllipse
A ellipse. Set `width` and `height`.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZEllipse(
    width: 60,
    height: 120,
    stroke: 20,
    color: Color(0xFFCC2255),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/ellipsis">
</iframe>
</div>
</div>

For `ZCircle` and `ZEllipse` set quarters to an integer for quarter- and semi-circles. 
The quarter circle starts in the upper-right and continues clockwise.


<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZCircle(    
    diameter: 80,
    quarters: 2,
    stroke: 20,
    color: Color(0xFFCC2255),
)
```
</div>
</div>

---
## ZPolygon
A regular polygon. Set size with `radius` and the number of sides with `sides`. Default: `radius: 0.5`, `sides: 3`.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZPolygon(
    sides: 5,
    radius: 50,
    stroke: 20,
    color: Color(0xff663366),
),
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/polygon">
</iframe>
</div>
</div>
---
## ZShape
Shape widget for custom shapes. The shape of a ZShape is defined by its `path`.


---
### path
Defines the shape.

When unset, `path` defaults to a single point. With `stroke` set, a single point renders as a sphere.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZShape(
    stroke: 20,
    color: Color(0xff663366),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/sphere">
</iframe>
</div>
</div>

### Path commands
Set `path` to Array of path commands. Path commands set the directions for the path to shape. Similar to drawing a path in Canvas

There are four path commands: `ZLine, ZMove, ZArc, and ZBezier.` 
```dart
path: [
    ZMove(0,0,0),

    ZLine(/*x,y,z*/),
    
    ZArc(
        corner: ZVector(/*x,y,z*/) // corner point
        end: ZVector(/*x,y,z*/)  // end point
    ),

    ZBezier([
        ZVector(/*x,y,z*/) // start control point
        ZVector(/*x,y,z*/) // end control point
        ZVector(/*x,y,z*/) // end point
    ]),
]
```

 ---
### ZLine
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZShape(
    path: [
        ZMove.only(x: -40),
        ZLine.only(x: 40),
    ],
    stroke: 20,
    color: Color(0xff663366),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/simple_line">
</iframe>
</div>
</div>

<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZShape(
    path: [
        ZMove.only(x: -32, y: -40), // start at top left
        ZLine.only(x: 32, y: -40), // line to top right
        ZLine.only(x: -32, y: 40), // line to bottom left
        ZLine.only(x: 32, y: 40), // line to bottom right
    ],
    closed: false,
    stroke: 20,
    color: Color(0xff663366),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
     src="https://z.flutter.gallery/examples/#/demo/z_plain">
</iframe>
</div>
</div>

Path points can use `z` coordinates to form 3D shapes

<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZShape(
    path: [
        ZMove.only(x: -32, y: -40, z: 40),
        ZLine.only(x: 32, y: -40), 
        ZLine.only(x: -32, y: 40, z: 40), 
        ZLine.only(x: 32, y: 40, z: -40), 
    ],
    closed: false,
    stroke: 20,
    color: Color(0xff663366),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
     src="https://z.flutter.gallery/examples/#/demo/z_3d">
</iframe>
</div>
</div>
 ---
### ZMove
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZShape(
    path: [
        ZMove.only(x: -32, y: -40), // start at top left
        ZLine.only(x: 32, y: -40), // line to top right
        ZMove.only(x: -32, y: 40), // line to bottom left
        ZLine.only(x: 32, y: 40), // line to bottom right
    ],
    closed: false,
    stroke: 20,
    color: Color(0xff663366),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/parallel_lines">
</iframe>
</div>
</div>
 ---
### ZArc
Renders an elliptical curve. The ellipse of the curve fits within a rectangle formed by the previous, corner, and end points.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZShape(
    path: [
        ZMove.only(x: -60, y: -60)), // start
        ZArc(
          corner:  ZVector.only(x: 20, y: -60), // corner
          end:  ZVector.only(x: 20, y: 20) // end point
        ), 
        ZArc(  // start next arc from last end point
         corner: ZVector.only(x: 20, y: 60), // corner
         end:  ZVector.only(x: 60, y: 60) // end point
        ),
    ],
    closed: false,
    stroke: 20,
    color: Color(0xff663366),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
        src="https://z.flutter.gallery/examples/#/demo/arc">
</iframe>
</div>
</div>

 ---
### ZBezier
Renders a bezier curve.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZShape(
    path: [
        ZMove.only(x: -60, y: -60),
        ZBezier([
            ZVector.only(x: 20, y: -60),
            ZVector.only(x: 20, y: 60),
            ZVector.only(x: 60, y: 60)
        ]),
    ],
    closed: false,
    stroke: 20,
    color: Color(0xff663366),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
        src="https://z.flutter.gallery/examples/#/demo/bezier">
</iframe>
</div>
</div> 

---
### closed
Closes the path from the last point back to the first. Enabled by default `closed: true`.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZShape(
    path: [
        ZMove.only(x: 0, y: -40),
        ZLine.only(x: 40, y: 40),
        ZLine.only(x: -40, y: 40),
    ],
    // closed by default
    stroke: 20,
    color: Color(0xff663366),
),
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/closedTriangle">
</iframe>
</div>
</div>

<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZShape(
    path: [
        ZMove.only(x: 0, y: -40),
        ZLine.only(x: 40, y: 40),
        ZLine.only(x: -40, y: 40),
    ],
    closed: false, // unclosed
    stroke: 20,
    color: Color(0xff663366),
),
```
</div>
<div class="code-demo">  

 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/open_triangle">
</iframe>
</div>
</div>

---
## ZHemisphere
A spherical hemisphere. Set size with `diameter`. Set the color of the base ellipse with `backfaceColor`. Defaults: `diameter: 1, fill: true`. The origin of the hemisphere is the center of the base. The dome faces front toward positive z-axis.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZHemisphere(
    diameter: 120,
    color: Color(0xffCC2255),
    backfaceColor: Color(0xffEEAA00),
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/hemisphere">
</iframe>
</div>
</div>

---
## ZCone
A square cylinder with circular bases. Set size with `diameter` and `length`. Default `diameter: 1, length: 1, fill: true`. Set the color of the base ellipse with `backfaceColor`. The origin of the hemisphere is the center of the base. The dome faces front toward positive z-axis.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZCone(
    diameter: 30,
    length: 40,
    color: Color(0xffCC2255),
    backfaceColor: Color(0xffEEAA00)
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
    src="https://z.flutter.gallery/examples/#/demo/cone">
    
</iframe>
</div>
</div>
---
## ZCylinder
A square cylinder with circular bases. Set size with `diameter` and `length`. Default `diameter: 1, length: 1, fill: true`. Set the color of the base ellipse with `backfaceColor`. The origin of the hemisphere is the center of the base. The dome faces front toward positive z-axis.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZCylinder(
    diameter: 80,
    length: 120,
    frontface: Colors.red,
    color: Colors.orange,
    backface: Colors.green,
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
     src="https://z.flutter.gallery/examples/#/demo/cylinder">
</iframe>
</div>
</div>
---
## ZBox
A rectangular prism. Set size with `width`, `height`, and `depth`. Set face colors with face options: frontFaceColor, rearFaceColor, leftFaceColor, rightFaceColor, topFaceColor, and bottomFaceColor. Defaults `width: 1, height: 1, depth: 1, fill: true`
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
ZBox(
    height: 100,
    width: 100,
    depth: 100,
    color: Color(0xffCC2255),
    frontColor: Color(0xffCC2255),
    topColor: Colors.yellow,
    leftColor: Colors.green,
    rightColor: Colors.blue,
    bottomColor: Colors.orange,
    rearColor: Colors.red,
)
```
</div>
<div class="code-demo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="200" 
    height="200" 
     src="https://z.flutter.gallery/examples/#/demo/box">
</iframe>
</div>
</div>
