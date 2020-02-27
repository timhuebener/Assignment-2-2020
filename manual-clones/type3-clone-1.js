function fibonacci(num) {
  var a = 1, b = 0, temp;

  for (let i = 0; i < num; i++) {
    temp = a + b;
    b = a;
    a = temp;
    console.log(a);
  }

  return b;
}

fibonacci(78)
