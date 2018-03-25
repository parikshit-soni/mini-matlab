	.section	.rodata
	.LC2:	.string	" "
	.LC0:	.string	"Enter number of elements\n"
	.LC3:	.string	"Enter the elements: "
	.LC1:	.string	"Sorted list in ascending order:\n"
	.LC4:	.string	"The array is: "
	.LC5:	.string	"\n"
	.text
	.globl main
	.type main, @function
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1832, %rsp
	movq $50, %rax
	movq %rax, -416(%rbp)
	movq $.LC0,%rax
	movq %rax, -472(%rbp)
	movq -472(%rbp), %rax
	movq %rax, -464(%rbp)
	movq $.LC1,%rax
	movq %rax, -712(%rbp)
	movq -712(%rbp), %rax
	movq %rax, -704(%rbp)
	movq $.LC2,%rax
	movq %rax, -1008(%rbp)
	movq -1008(%rbp), %rax
	movq %rax, -1000(%rbp)
	movq $.LC3,%rax
	movq %rax, -1048(%rbp)
	movq -1048(%rbp), %rax
	movq %rax, -1040(%rbp)
	movq $.LC4,%rax
	movq %rax, -1240(%rbp)
	movq -1240(%rbp), %rax
	movq %rax, -1232(%rbp)
	movq $.LC5,%rax
	movq %rax, -1384(%rbp)
	movq -1384(%rbp), %rax
	movq %rax, -1376(%rbp)
	movq -464(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -424(%rbp)
	movq -424(%rbp), %rax
	movq %rax, -1424(%rbp)
	movq $0, %rax
	movq %rax, -1432(%rbp)
	movq -1432(%rbp), %rax
	movq %rax, -440(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1440(%rbp)
.L3:
	movq -440(%rbp), %rax
	cmpq -424(%rbp), %rax
	jl .L0
	jmp .L2
	jmp .L2
.L4:
	movq -440(%rbp), %rax
	movq %rax, -1448(%rbp)
	movq -1448(%rbp), %rax
	movq %rax, -1456(%rbp)
	movq -1448(%rbp), %rax
	addq $1, %rax
	movq %rax, -1448(%rbp)
	movq -1448(%rbp), %rax
	movq %rax, -440(%rbp)
	jmp .L3
.L0:
	movq -1040(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -440(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1464(%rbp)
	call readi
	movq %rax, -8(%rbp)
	movq $-16, %rax
	subq -1464(%rbp), %rax
	movq -8(%rbp), %rdx
	movq %rdx, 0(%rbp,%rax,1)
	movq $-16, %rax
	subq -1464(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1472(%rbp)
	jmp .L4
.L2:
	movq -1232(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq $0, %rax
	movq %rax, -1480(%rbp)
	movq -1480(%rbp), %rax
	movq %rax, -440(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1488(%rbp)
.L8:
	movq -440(%rbp), %rax
	cmpq -424(%rbp), %rax
	jl .L5
	jmp .L7
	jmp .L7
.L9:
	movq -440(%rbp), %rax
	movq %rax, -1496(%rbp)
	movq -1496(%rbp), %rax
	movq %rax, -1504(%rbp)
	movq -1496(%rbp), %rax
	addq $1, %rax
	movq %rax, -1496(%rbp)
	movq -1496(%rbp), %rax
	movq %rax, -440(%rbp)
	jmp .L8
.L5:
	movq -440(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1512(%rbp)
	movq $-16, %rax
	subq -1512(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1520(%rbp)
	movq -1520(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call printi
	movq -1000(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	jmp .L9
.L7:
	movq -1376(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq $0, %rax
	movq %rax, -1528(%rbp)
	movq -1528(%rbp), %rax
	movq %rax, -440(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1536(%rbp)
.L13:
	movq $1, %rax
	movq %rax, -1544(%rbp)
	movq -424(%rbp), %rax
	subq -1544(%rbp), %rax
	movq %rax, -1552(%rbp)
	movq -440(%rbp), %rax
	cmpq -1552(%rbp), %rax
	jl .L10
	jmp .L12
	jmp .L12
.L23:
	movq -440(%rbp), %rax
	movq %rax, -1560(%rbp)
	movq -1560(%rbp), %rax
	movq %rax, -1568(%rbp)
	movq -1560(%rbp), %rax
	addq $1, %rax
	movq %rax, -1560(%rbp)
	movq -1560(%rbp), %rax
	movq %rax, -440(%rbp)
	jmp .L13
.L10:
	movq $0, %rax
	movq %rax, -1576(%rbp)
	movq -1576(%rbp), %rax
	movq %rax, -432(%rbp)
	movq -432(%rbp), %rax
	movq %rax, -1584(%rbp)
.L17:
	movq -424(%rbp), %rax
	subq -440(%rbp), %rax
	movq %rax, -1592(%rbp)
	movq $1, %rax
	movq %rax, -1600(%rbp)
	movq -1592(%rbp), %rax
	subq -1600(%rbp), %rax
	movq %rax, -1608(%rbp)
	movq -432(%rbp), %rax
	cmpq -1608(%rbp), %rax
	jl .L14
	jmp .L23
	jmp .L16
.L22:
	movq -432(%rbp), %rax
	movq %rax, -1616(%rbp)
	movq -1616(%rbp), %rax
	movq %rax, -1624(%rbp)
	movq -1616(%rbp), %rax
	addq $1, %rax
	movq %rax, -1616(%rbp)
	movq -1616(%rbp), %rax
	movq %rax, -432(%rbp)
	jmp .L17
.L14:
	movq -432(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1632(%rbp)
	movq $-16, %rax
	subq -1632(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1640(%rbp)
	movq $1, %rax
	movq %rax, -1648(%rbp)
	movq -432(%rbp), %rax
	addq -1648(%rbp), %rax
	movq %rax, -1656(%rbp)
	movq -1656(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1664(%rbp)
	movq $-16, %rax
	subq -1664(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1672(%rbp)
	movq -1640(%rbp), %rax
	cmpq -1672(%rbp), %rax
	jg .L18
	jmp .L22
	jmp .L20
.L18:
	movq -432(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1680(%rbp)
	movq $-16, %rax
	subq -1680(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1688(%rbp)
	movq -1688(%rbp), %rax
	movq %rax, -456(%rbp)
	movq -456(%rbp), %rax
	movq %rax, -1696(%rbp)
	movq -432(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1704(%rbp)
	movq $1, %rax
	movq %rax, -1712(%rbp)
	movq -432(%rbp), %rax
	addq -1712(%rbp), %rax
	movq %rax, -1720(%rbp)
	movq -1720(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1728(%rbp)
	movq $-16, %rax
	subq -1728(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1736(%rbp)
	movq $-16, %rax
	subq -1704(%rbp), %rax
	movq -1736(%rbp), %rdx
	movq %rdx, 0(%rbp,%rax,1)
	movq $-16, %rax
	subq -1704(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1744(%rbp)
	movq $1, %rax
	movq %rax, -1752(%rbp)
	movq -432(%rbp), %rax
	addq -1752(%rbp), %rax
	movq %rax, -1760(%rbp)
	movq -1760(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1768(%rbp)
	movq $-16, %rax
	subq -1768(%rbp), %rax
	movq -456(%rbp), %rdx
	movq %rdx, 0(%rbp,%rax,1)
	movq $-16, %rax
	subq -1768(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1776(%rbp)
	jmp .L22
.L20:
	jmp .L22
.L16:
	jmp .L23
.L12:
	movq -704(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq $0, %rax
	movq %rax, -1784(%rbp)
	movq -1784(%rbp), %rax
	movq %rax, -440(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1792(%rbp)
.L27:
	movq -440(%rbp), %rax
	cmpq -424(%rbp), %rax
	jl .L24
	jmp .L26
	jmp .L26
.L28:
	movq -440(%rbp), %rax
	movq %rax, -1800(%rbp)
	movq -1800(%rbp), %rax
	movq %rax, -1808(%rbp)
	movq -1800(%rbp), %rax
	addq $1, %rax
	movq %rax, -1800(%rbp)
	movq -1800(%rbp), %rax
	movq %rax, -440(%rbp)
	jmp .L27
.L24:
	movq -440(%rbp), %rax
	imulq  $8,%rax
	movq %rax, -1816(%rbp)
	movq $-16, %rax
	subq -1816(%rbp), %rax
	movq 0(%rbp,%rax,1), %rdx
	movq %rdx, -1824(%rbp)
	movq -1824(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call printi
	movq -1000(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	jmp .L28
.L26:
	movq -1376(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq $0, %rax
	movq %rax, -1832(%rbp)
	movq -1832(%rbp), %rax
	movq %rax, -8(%rbp)
	movq -1832(%rbp),%rax
	addq $1832, %rsp
	popq %rbp
	ret
