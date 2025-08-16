// Firebase messaging service worker
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

// Firebase configuration - replace with your actual config
firebase.initializeApp({
  apiKey: "demo-api-key",
  authDomain: "moodthread-demo.firebaseapp.com",
  projectId: "moodthread-demo",
  storageBucket: "moodthread-demo.appspot.com",
  messagingSenderId: "123456789",
  appId: "demo-app-id"
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('Received background message:', payload);
  
  const notificationTitle = payload.notification.title || 'MoodThread';
  const notificationOptions = {
    body: payload.notification.body || 'You have a new message',
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
