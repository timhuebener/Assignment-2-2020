import * as fs from "fs";
import * as path from "path";

const args = process.argv.slice(2);
const outputFileName = args[0];
const version = args[1];
// console.log("outputFileName: ", outputFileName, "\nversion:", version);

interface Instance {
  path: string;
  lines: number[];
  code: string;
}

interface DiffItem {
  id: string;
  instances: Instance[];
}

const input: DiffItem[] = JSON.parse(
  fs.readFileSync(
    path.join(__dirname, `../../jsinspect-out/${outputFileName}`),
    "utf8"
  )
);
// console.log(input);

// Maybe the filtering should work another way: from every instance (array of duplicates) filter so that
// the first of the first version and all of the second version remain in the array
// (Now all the other versions are included)
const instances = input
  .flatMap(item => item.instances)
  .filter(instance => instance.path.includes(version));
// console.log(instances);

let codeDuplicateCharCount = 0;
instances.forEach(item => (codeDuplicateCharCount += item.code.length));
console.log(
  // `Char count for code duplicates in version ${version}:`,
  codeDuplicateCharCount
);
