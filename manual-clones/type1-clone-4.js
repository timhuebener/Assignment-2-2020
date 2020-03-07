/**
 * Function to compute the n-th fibonacci number
 * @param {number} num n-th number to compute
 *
 */
function fibonacci(num) {
  // initial values
  var a = 1,
    b = 0,
    temp;

  for (let i = 0; i < num; i++) {
    temp = a + b;
    b = a;
    a = temp;
  }

    // return n-th fibonacci number
    return b;
}

// print the n-th fibunacci number
console.log(fibonacci(78));
