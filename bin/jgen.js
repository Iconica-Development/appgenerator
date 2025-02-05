#!/usr/bin/env node
import JGen from '../build/index.js'
let [,,command, args,...options] = process.argv

let file = args
if (!command) command = "build"
if (!file || file.startsWith("--")) {
    file = "./app.json"
    options = [args, ...options]
}

if (["build", "run" ].indexOf(command) == -1) console.log("invalid command")
else 
    new JGen().start(command, file, options.join(" ").indexOf("--watch") > -1)