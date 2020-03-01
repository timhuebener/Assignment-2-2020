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

// TODO: check this filtering part -> is it needed, how should we filter?
// jsinspect output cases:
// duplicates1: {v1, v2}, duplicates2{v1, v1, .., v2, v2, ..}, duplicates3{v1, v1, ..}, duplicates4{v2, v2, ..}
// Probably we should filter at least the case duplicates3 and duplicates4 because it does not mean similarity between versions at all

const instances = input.flatMap(item => item.instances);
// .filter(instance => instance.path.includes(version));
// console.log(instances);

let codeDuplicateCharCount = 0;
instances.forEach(item => (codeDuplicateCharCount += item.code.length));
// Char count for code duplicates in version ${version},
console.log(codeDuplicateCharCount);
