---
layout: default
title: Modeling
nav_order: 2
permalink: /docs/modeling/
---

# Modeling

Modeling in ZFlutter is a bit different of the way of the libary this project is inspired: [Zdog](https://zzz.dog/modeling).

We like it to do the Flutter way: Nesting widgets inside another.

We build ZFlutter models by using shape widgets and transforming them with ZPositioned widgets.

```dart
ZPositioned(
    translate: ZVector.only(x: 20),
    rotate: ZVector.only(tau/4),
    scale: ZVector.scale(1.1),
    child: ZCircle(    
        diameter: 80,
        stroke: 20,
        color: Color(0xFFCC2255),
    )
) 

```

The `ZPositioned` are relative to the previous origin reference. So if we add another ZPositioned child this will inherit the transformation of his parent.

```dart
ZPositioned(
    translate: ZVector.only(x: 20),
    child: ZPositioned(
        rotate: ZVector.only(tau/4),
        scale: ZVector.scale(1.1),
        child: ZCircle(    
            diameter: 80,
            stroke: 20,
            color: Color(0xFFCC2255),
        )
    ),
) 
```


# ZVector

Properties like translate, rotation, and scale are `ZVector`. 
This class can be initialized with different constructorr

```dart
 final vector  = ZVector(x, y, z);
 final vector1 = ZVector.only(x: x); // y and z will be set to 0
 final vector1 = ZVector.all(a); // x, y and z will be set to a

```


# Stroke volume

Whereas polygonal 3D engines rely on meshes of polygons to depict volume, Zflutter shapes can show volume with stroke.

[To be more detailed]

We really like this quote of ZDog:

> Using `stroke` for volume is what makes Zdog special. Let go of your earthly polygons and become one with the round thickness.



# Groups

The widget ZGroup allows you to group multiple shapes inside a single widgets. Notice that ZPositioned transformation will still be iniherited.

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

# Updating render order

ZGroup allows you to control the render order of the widget inside itself. You can control this with the param sortMode
that is SortMode.inherit by the default. There are three modes

- **SortMode.inherit**: Renders the children in the same order as if they were children of the previous group or root illustration
- **SortMode.stack:** Paints the children in the order they are added to the list
- **SortMode.update**: Creates a new order for the children according to their transformation and paints the group according to the transformation of the group centroid


Learn more in detail the different pre-built shapes here

[Shape]({% link shapes.md %}){: .btn }