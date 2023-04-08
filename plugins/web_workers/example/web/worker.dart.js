// worker.dart.js

// A simple worker that just sends back the message it receives.

const worker = self;

worker.onmessage = function (event) {
    console.log('Worker received message: ' + event.data);
    worker.postMessage(event.data);
}

