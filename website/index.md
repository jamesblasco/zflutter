---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
title: 'Home'
layout: default
nav_order: 0
---



<script type="text/javascript" src="assets/js/redirect.js" ></script>

<div class="code-demo-logo">  
 <iframe 
   frameborder="no"  
    marginwidth="0" 
    marginheight="0" 
    width="300" 
    height="300" 
     src="../../examples/#/demo/logo">
</iframe>
</div>


# ZFlutter

<a class="github-button" href="https://github.com/jamesblasco/zflutter" data-color-scheme="no-preference: light; light: dark; dark: light;" data-size="large" data-show-count="true" aria-label="jamesblasco/zflutter on GitHub">ZFlutter on Github</a>
{: .d-none .d-md-inline-block }
<!-- Place this tag in your head or just before your close body tag. -->
<script async defer src="https://buttons.github.io/buttons.js"></script>   

<a  href="https://pub.dev/packages/zflutter"><img  class="shield-button"  src="https://img.shields.io/pub/v/zflutter.svg?logo=flutter&color=blue&style=for-the-badge"/></a>
{: .d-none .d-md-inline-block }



ZFlutter is a pseudo-3D engine for Flutter. 

First we would like to give the mertits to [Zdog](https://zzz.dog), the 3D JavaScript engine that has been the base inspiration for this project. We encourage to take a look to Zdog and enjoy their awesome examples and documentation.

Most of ZFlutter is based on this library so if you have tried Zdog before you will already find yourself familiar with the core concets. 

## What is Zdog?

Zdog is a 3D JavaScript engine for `<canvas>` and `SVG`. With Zdog, you can design and render simple 3D models on the Web. Zdog is a pseudo-3D engine. Its geometries exist in 3D space, but are rendered as flat shapes. This makes Zdog special.

- Zdog is small. 2,100 lines of code for the entire library. 28KB minified.
- Zdog is round. All circular shapes are rendered as proper circles with rounded edges. No polygonal jaggies.
- Zdog is friendly. Modeling is done with a straight-forward declarative API.
- Zdog was designed to bring the simplicity of vector illustration into 3D. Drawing circles and squares is easy and fun. Zdog just adds another dimension.

## What makes ZFlutter different?

We like to do things the Flutter way.

This library uses the core concepts of ZDog to build a serie of Widgets, that combined, allow you to create 3D shapes.

Let's see some differences:

 - ZFlutter uses widgets, that are inmmutable.
 - We can animate them as normal widgets with methods like AnimationController
 - While ZDog creates their tree of shapes by refering the parent to the child, in Flutter we will nest children inside their parents as normal  widgets.
 - You can use your own widgets in a 3D space. Even a full app!
 - With the power of Flutter you can run ZFlutter on iOS, Android, Mac, Windows, Linux and Web.

Interested? 
Read the next section to [Get Started]({% link getting_started.md %})

