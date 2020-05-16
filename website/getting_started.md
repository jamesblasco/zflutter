---
layout: default
title: Getting Started
nav_order: 1
permalink: /docs/getting-started/
---

# Getting started
{: .no_toc }
This page will walk you through how to design, display, and animate a basic 3D model with ZFlutter.



# Table of contents
{: .no_toc .text-delta }


1. TOC
{:toc}

## Add to project
Add zflutter to your package's pubspec.yaml file:

```yaml
dependencies:
  zflutter: //Add last version
```

And install it with 
```s
$ flutter pub get
```

## Initial static demo
Let’s jump in with a basic non-animated demo.

<div  class="code-box">
<div class="code-md" markdown="1">
```dart
MaterialApp(
  home: ZIllustriation(
    child: ZCircle(    
      diameter: 80,
      stroke: 20,
      color: Color(0xFFCC2255),
    )
  )    
)
```
</div>
</div>


Let’s break it down. The Zflutter API mostly consists by nesting ZWidgets.

`ZIllustration` is the top-level class that handles the pseudo 3D-engine, holding all the shapes in the scene, and displaying those shapes. 

ZCircle is a shape widget. We add it as a child of `ZIllustration` and we set other properties for the circle to set its size, shape, and color: `diameter: 80, stroke: 20, color: Color(0xFFCC2255)`.

And we get ... a 80px wide purple circle. Exciting!


## Translate, Rotate and Scale
To transform a ZWidget in a three dimension we use ZPositioned widget.

<div  class="code-box">
<div class="code-md" markdown="1">

```dart
MaterialApp(
  home: ZIllustriation(
    child: ZPositioned(
      translate: ZVector.only(x: 20),
      rotate: ZVector.only(tau/4),
      scale: ZVector.scale(1.1),
      child: ZCircle(    
        diameter: 80,
        stroke: 20,
        color: Color(0xFFCC2255),
      )
    ) 
  )    
)
```
</div>
</div>

`ZPositioned` transforms his child in this order, first is scale its points, then rotate them and finally translate them.

The constant `tau` it represents one round and equals to `2 * pi`. So if you want to rotate a quarter of round you can use `tau/8`

It is posible to use nested ZPositioned and they will be combined.


<div  class="code-box">
<div class="code-md" markdown="1">

```dart
MaterialApp(
  home: ZIllustriation(
    child: ZPositioned(
      translate: ZVector.only(x: 20),
       child: ZPositioned(
        rotate: ZVector.only(tau/2),
        scale: ZVector.scale(1.1),
        child: ZCircle(    
          diameter: 80,
          stroke: 20,
          color: Color(0xFFCC2255),
        ),
      ),
    ) 
  )    
)
```
</div>

</div>


## Zoom
Setting zoom will scale the whole scene proportionally. This helps to make the calculation numbers smaller and to make it responsive to different screen sizes. Notice while zoom will scale all proportionally, the ZPositioned scale vector will transform the path commands but won't affect to the stroke of the paths.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
MaterialApp(
  home: ZIllustriation(
    zoom: 4,
    child: ZPositioned(
       ZCircle(    
        diameter: 80,
        stroke: 20,
        color: Color(0xFFCC2255),
      )
    ) 
  )    
)
```
</div>

</div>


## Animate 
Animations are driven by Flutter animation. There is different ways to animate a widget.
In this example we will be passing an `Animation` variable to an `AnimatedBuilder` widget
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
AnimatedBuilder(
    animation: animation,
    builder: (context, _ ) => 
    ZIllustriation(
      zoom: 4,
      child: ZCircle(    
          diameter: 80,
          stroke: 20,
          color: Color(0xFFCC2255),
      
      ), 
  ),    
)
```
</div>

</div>



## Drag rotate 
You can use a custom GestureDetector or ZDragDetector, a widget that calculates rotation according to the drag offset
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZDragDetector(
    builder: (context, controller) {
    ZIllustriation(
      zoom: 4,
      child: ZPositioned(
        rotate: controller.rotate,
        child: ZCircle(    
          diameter: 80,
          stroke: 20,
          color: Color(0xFFCC2255),
        ),
      ), 
  ),    
)
```
</div>

</div>


## ZToBoxAdapter
ZToBoxAdapter lets you add any widget to your 3D playground.  `height` and a `width` are required.
<div  class="code-box">
<div class="code-md" markdown="1">

```dart
 ZDragDetector(
    builder: (context, controller) {(
    ZIllustriation(
      zoom: 4,
      child: ZPositioned(
        rotate: controller.rotate,
        child: ZToBoxAdapter(    
          height: 80,
          width: 80,
          child: Container(color: Color(0xFFCC2255)),
        ),
      ), 
  ),    
)
```
</div>

</div>



To learn more on how to model your 3D object go to next section

[Modeling]({% link modeling.md %}){: .btn }