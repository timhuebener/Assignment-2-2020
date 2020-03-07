function fibonacci(num) {
  var a = 1, b = 0, temp;
  var i = 0;

  while (i < num) {
    temp = a + b;
    b = a;
    a = temp;
    i++;
  }

  return b;
}

console.log(fibonacci(78));