#! /usr/bin/env -S bun run

import { parseArgs } from "util";

const { values, positionals } = parseArgs({
  args: Bun.argv,
  options: {
    opt: {
      type: 'string',
    },
  },
  strict: true,
  allowPositionals: true,
})

const stdin = process.openStdin();

let data = "";

stdin.on('data', function(chunk) {
  data += chunk;
});

stdin.on('end', function() {
  console.log("DATA:\n" + data + "\nEND DATA");
});

console.log(values);
console.log(positionals);