codedumpster 1.0
ADD R5, R6
ADDI $29, R8
ADDI $-5, R13
// comment? idk?
ADDU R4, R15
ADDC R0, R11
.labelsarefun
MUL R1, R10
MULI $19, R2
SUB R3, R9
SUBI $-16, R8
SUBC R4, R7
SUBCI $14, R6
CMP R5, R6
CMPI $3, R5
AND R6, R5
ANDI $0, R4
OR R7, R3
ORI $6, R2
XOR R8, R1
XORI $20, R0
MOV R0, R4
MOVI $10, R6
LSH R6, R4
LSHI $-7, R9
LOAD R1, R2
STOR R1, R2
BEQ .labelsarefun
BEQ .jumpbeforelabel
JEQ .labelsarefun
JEQ .jumpbeforelabel
.jumpbeforelabel
ANDI $0, R4
end
