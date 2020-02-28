function fibonacci(num) {
  var a = 1, b = 0, temp;

  for (let i = 0; i < num; i++) {
    temp = a + b;
    b = a;
    a = temp;
  }

  return b;
}

console.log(fibonacci(78));
