function fibonacci(num) {
  var n2 = 1, n1 = 0, tmp;

  for (let j = 0; j < num; j++) {
    tmp = n2 + n1;
    n1 = n2;
    n2 = tmp;
  }

  return n1;
}

console.log(fibonacci(78));