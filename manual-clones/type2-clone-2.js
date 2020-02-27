/**
 * Function to compute the n-th fibonacci number
 * @param {number} num n-th number to compute
 *
 */
function fibonacci(num) {
  // initial values 
  var n2 = 1, n1 = 0, tmp;

  for (let j = 0; j < num; j++) {
    tmp = n2 + n1;
    n1 = n2;
    n2 = tmp;
  }

  // return n-th fibonacci number
  return n1;
}

// print the n-th fibunacci number
console.log(fibonacci(78));