import * as fs from "fs";
import * as path from "path";

const args = process.argv.slice(2);
const outputFileName = args[0];

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

// jsinspect output cases for duplicate blocks:
// duplicates1: {v1, v2}, duplicates2{v1, v1, .., v2, v2, ..}, duplicates3{v1, v1, ..}, duplicates4{v2, v2, ..}
// We have to filter the duplicates3 and duplicates4 cases because they does not mean similarity between versions
const filteredInput = input.filter(diffItem => {
  let v = diffItem.instances[0].path.split("/")[1];
  let sameVersion = true;
  diffItem.instances.forEach(instance => {
    if (instance.path.split("/")[1] !== v) {
      sameVersion = false;
    }
  });
  return !sameVersion;
});
const instances = filteredInput.flatMap(item => item.instances);

let codeDuplicateCharCount = 0;
instances.forEach(item => (codeDuplicateCharCount += item.code.length));
// Char count of code duplicates based on the jsinspect output file:
console.log(codeDuplicateCharCount);
