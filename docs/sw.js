// Simple Showcase Service Worker
// Version updated automatically by site generator
const CACHE_VERSION = '202512050735';
const CACHE_NAME = 'ssc-v' + CACHE_VERSION;
const PAGES = [
  '/simple_showcase/',
  '/simple_showcase/index.html',
  '/simple_showcase/get-started/',
  '/simple_showcase/portfolio/',
  '/simple_showcase/design-by-contract/',
  '/simple_showcase/workflow/',
  '/simple_showcase/analysis/',
  '/simple_showcase/business-case/',
  '/simple_showcase/why-eiffel/',
  '/simple_showcase/probable-to-provable/',
  '/simple_showcase/old-way/',
  '/simple_showcase/ai-changes/',
  '/simple_showcase/contact/',
  '/simple_showcase/manifest.json',
  '/simple_showcase/icon-192.png',
  '/simple_showcase/icon-512.png'
];

// Install - cache all pages
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(PAGES))
      .then(() => self.skipWaiting())
  );
});

// Activate - clean old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME)
            .map(key => caches.delete(key))
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch - serve from cache, fallback to network
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        if (response) {
          return response;
        }
        return fetch(event.request).then(response => {
          // Don't cache non-successful responses or non-GET
          if (!response || response.status !== 200 || event.request.method !== 'GET') {
            return response;
          }
          // Clone and cache
          const responseToCache = response.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, responseToCache);
          });
          return response;
        });
      })
  );
});
