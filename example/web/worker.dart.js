// worker.dart.js

// A simple worker that just sends back the message it receives.

const worker = self;

sumUpTo = function (n) {
    let sum = 0;

    for (var i = 0; i <= n; i++) {
        sum += i;
    }

    return sum;
}


function add(d) {
    console.log(JSON.parse(d));
}




// Message received in this format : 
// {"function": "functionName", "args": [arg1, arg2, arg3]} 
worker.onmessage = function (event) {
    console.log('Worker received message: ' + event.data);


    // Decode the message
    var data = JSON.parse(event.data);

    console.log("Function: " + data.function);
    console.log("Args: " + data.args);

    let functionToCall = data.function;
    let args = data.args;


    console.log(`Calling function: ${functionToCall} with args: ${args}`);


    // TODO: Find a way to call the function with the arguments without using
    //  eval or the DOM. If using eval we need to make sure that the function is
    //  not malicious.
    var result = eval(functionToCall).apply(null, args);

    console.log("Result: " + result);



    // Send the result back to the main thread
    worker.postMessage(result);

}
