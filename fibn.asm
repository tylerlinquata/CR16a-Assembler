
// Fibn.s - compute the nth Fibonacci number
//
// C-code that this assembly code came from
//
// int fibn(void)
// {
//  int n = 8;		/* Compute nth Fibonacci number */
//  int f1 = 1, f2 = -1	/* last two Fibonacci numbers   */
//
//  while (n != 0) {	/* count down to n = 0          */
//    f1 = f1 + f2;
//    f2 = f1 - f2;
//     n = n - 1;
//  }
//   return f1;
// }
//
//
// Register usage: $3=n, $4=f1, $5=f2
// return value written to address 255
.fibn
// initialize n = 8
MOVI $8, R3
// initialize f1 = 1
MOVI $1, R4
// initialize f2 = -1
MOVI $-1, R5
.loop
CMPI $0, R3
// Done with loop if n = 0
BEQ .end
// f1 = f1 + f2
ADD R4, R5
// f2 = f1 - f2
SUB R5, R4
//n = n - 1
ADDI $-1, R3
juc .loop
.end
// place storage address in R6
MOVI $255, R6
// store result in R6
STOR R4, R6
