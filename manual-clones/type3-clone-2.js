function fibonacci(num) {
  var a = 1, b = 0, temp;
  var i = 0;

  for (i; i < num; i++) {
    temp = a + b;
    b = a;
    a = temp;
    console.log(a);
  }

  return b;
}

console.log(fibonacci(78));