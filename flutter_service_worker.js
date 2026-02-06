'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "50938e83d42f332eecfff6c08211a09d",
"index.html": "a4510c6431d9fe68df51a0c0273bcc2b",
"/": "a4510c6431d9fe68df51a0c0273bcc2b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "22afaff620232667a0174c7529e12d95",
"assets/assets/res/about.jpg": "f13cff91a5a1f25582b2904ee97447ee",
"assets/assets/res/beforeAfter/3.webp": "902650382deb461ff97e82eddc590fa4",
"assets/assets/res/beforeAfter/2.webp": "caf01cb5818515f98f685da5423ef0b7",
"assets/assets/res/beforeAfter/6.webp": "d8c107ed3889d1e1d4dd5a370093112f",
"assets/assets/res/beforeAfter/4.webp": "7d349a27fd0e0eaa0acabe064e2c8d37",
"assets/assets/res/beforeAfter/1.webp": "47da21433a97be02612c6618e8842889",
"assets/assets/res/beforeAfter/rename_image_to_number_jpg.bat": "c5e7e952faae238382daf7043d048a14",
"assets/assets/res/beforeAfter/5.webp": "724911c737858fd6b20a0d9368209b52",
"assets/assets/res/work/8.webp": "86cfadfa6b14c78eb5e99dc130ce6ea5",
"assets/assets/res/work/17.webp": "6844aab0fcdd875e51ae5064de488aea",
"assets/assets/res/work/20.webp": "5051f4ecaa0e3add397a04e347b47df8",
"assets/assets/res/work/7.webp": "3c82c6c85c8637bcf89d29fb5fd498a7",
"assets/assets/res/work/12.webp": "3ffc34bfacf28ecac0e24493de4638f3",
"assets/assets/res/work/11.webp": "b83baf4a13cf2ac9254133265e0865c0",
"assets/assets/res/work/19.webp": "4d8e79fa07f982af5f1b1ee5073589aa",
"assets/assets/res/work/15.webp": "381b0613a986df5aa1fb635f9ea5447f",
"assets/assets/res/work/3.webp": "a6cd8549afef57710dc53aeebb2d3bab",
"assets/assets/res/work/2.webp": "3d60f051e28c102cb2bd839d72199532",
"assets/assets/res/work/6.webp": "506a5af8a55b2842f7f2d99ff27403f2",
"assets/assets/res/work/4.webp": "56f531b55be5ebd9033933e0090702d1",
"assets/assets/res/work/13.webp": "1d70dda82bc1aac2ab7ebee8c25896c2",
"assets/assets/res/work/1.webp": "5e1ddc007da28f96e7e7fd1080743c05",
"assets/assets/res/work/9.webp": "93edaa41e2b2f0b73af3407a121f5552",
"assets/assets/res/work/rename_image_to_number_jpg.bat": "c5e7e952faae238382daf7043d048a14",
"assets/assets/res/work/names.json": "cacd2b38165db69995909a04b6288c99",
"assets/assets/res/work/5.webp": "9d5151e6acf3e08e34e6e9268cdb6dec",
"assets/assets/res/work/16.webp": "895f2b6ededccd5f5f6e85e603a9465e",
"assets/assets/res/work/18.webp": "1f42352ef1e3cb4b67a17c5ce03162ba",
"assets/assets/res/work/14.webp": "7edf8bf06e29f3f1cba92a461c7aeb80",
"assets/assets/res/work/10.webp": "7079b035b36fe1ce7895df2cf9cb00ba",
"assets/assets/fonts/Italiana-Regular.ttf": "74b49c9a4458212601a5f2276d348ed3",
"assets/fonts/MaterialIcons-Regular.otf": "dbff3a864f390b096df91182b8af7f71",
"assets/NOTICES": "1ecd1125284da1362b6c6e089ecf2b0a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "0857b495dce9b3727b15feca91eefe9d",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "262525e2081311609d1fdab966c82bfc",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "269f971cec0d5dc864fe9ae080b19e23",
"assets/FontManifest.json": "4804c2b3502ccec14d5840b1cd60bcca",
"assets/AssetManifest.bin": "72ff183b0cae4e13b7020aea81bdeb2b",
"assets/AssetManifest.json": "f5e31938fb9d927016d5a9b3ee61cf4b",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "f146c2ba18f1a20ca25a8576493a58a5",
"version.json": "490e3e85e938a7e9048321d7aeab37f8",
"main.dart.js": "8ef0cc52006a4d7966736ad8673ac9ff"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
