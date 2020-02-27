/**
 * Function to compute the n-th fibonacci number
 * @param {number} nth_number n-th number to compute
 *
 */
function fib(nth_number) {
  // initial values 
  var n2 = 1, n1 = 0, tmp;

  for (let j = 0; j < nth_number; j++) {
    tmp = n2 + n1;
    n1 = n2;
    n2 = tmp;
  }

  // return n-th fibonacci number
  return n1;
}

// print the n-th fibunacci number
console.log(fib(78));