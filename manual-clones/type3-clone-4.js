/**
 * Function to compute the n-th fibonacci number
 * @param {number} nth_number n-th number to compute
 *
 */
function fibonacci(nth_number) {
  // initial values 
  var n2 = 1, n1 = 0, tmp;
  var j = 0;

  while (j < nth_number) {
    tmp = n2 + n1;
    n1 = n2;
    n2 = tmp;
    j++;
    console.log(n1);
  }

  // return n-th fibonacci number
  return n1;
}

fibonacci(78);