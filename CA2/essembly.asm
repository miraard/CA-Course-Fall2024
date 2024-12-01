addi s7,zero,40
add s1,zero,zero
add s2,zero,zero
add s3,zero,zero
Loop:add s6,s2,s3
lw s4,s6(0)
bge s2,s7,END
sltu s5,s1,s4
beq s5,zero,ADD
add s1,s4,zero
ADD:addi s2,s2,4
jal Loop
END
