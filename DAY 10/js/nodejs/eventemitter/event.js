import EventEmitter from "events";

const emitter = new EventEmitter();

//Listener
emitter.on("greet", (name) => {
    console.log(`Hello ${name}`);
});

//Emitting an event
emitter.emit("greet", "John");v
