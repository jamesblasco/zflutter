'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "493d6c782d3c64061c1a8387b509aac0",
"/": "493d6c782d3c64061c1a8387b509aac0",
"main.dart.js": "24a28449086b41a21a83aa9025f0122f",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/share.jpg": "2a81cfdde38eb75144e5447c07e935c9",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "cb1c0f5a19cb5a65697122ba0cfe653c",
"assets/LICENSE": "a33c49e9313319ca363f52d6820925ef",
"assets/AssetManifest.json": "adb913eb952e6810ec9738ed7cd96625",
"assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/assets/flutter_original.png": "cf171b29e3b2c0cb9a12223f952da7c6",
"assets/assets/github_app.png": "1fbf1eeb622038a1ea2e62036d33788a",
"assets/assets/flutter_logo.png": "b5b8556ea9f48ca7cf794f52525d7cf7",
"assets/assets/person1.jpeg": "1d93c1b598e0378af0ce618fa39b2f19",
"assets/assets/flutter_white.png": "91cbceb6f4b8345f509ba4cde4bdcee5",
"assets/assets/mail.png": "dc55662a996e5617957530fe4d32d06a",
"assets/assets/flutter.png": "d21f1eecaeaab081ba7efec1721c0712",
"assets/assets/jaimeblasco.jpeg": "52e200d3b4ec4978617490d949f90d0e",
"assets/assets/github.png": "3e54ed15b9cd877c5223f5ecf64579df",
"assets/assets/lock_screen.PNG": "77a98351f2824e452db4e0e994ca585f",
"assets/assets/sound.mp3": "69a78caa8dedaf49a637af3119cfa1cd",
"assets/assets/slack.png": "efd8727d64d49659d14eee20476f8de7",
"assets/assets/flutter_black.png": "3e4d716d500f9d0b927f55c48379289a",
"assets/assets/twitter.png": "4907a786377fe693a9aa563792728683",
"assets/assets/person4.jpeg": "a3f68db6e589dfc5cc41a995916573eb",
"assets/assets/MacBook.jpg": "3d3f92faf14d52e12c8a8583a2cf30c2",
"assets/assets/person3.jpeg": "68f7f58edb11830b0525a4c65cc3a845",
"assets/assets/person2.jpeg": "94bd58214363da080f5c92298a4cb1ef",
"assets/assets/message.png": "4ab37fd9235ee454ef36d904f80502ff",
"assets/assets/demo_image.jpeg": "4129427d4b3d8ffbfda70b0bae61400b",
"assets/assets/brand_logo.png": "67310892c76ee9ab0e88441c0671a699"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
