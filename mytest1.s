	.section	.rodata
	.LC2:	.string	"Enter the element a: "
	.LC3:	.string	"Enter the element b: "
	.LC1:	.string	"The value of Computation is : "
	.LC4:	.string	"\n"
	.LC0:	.string	"\nEnter 1 to add \n 2 to subtract\n 3 to multiply \n 4 to divide \n 5 for modulo \n 6 for exit\n"
	.text
	.globl add
	.type add, @function
add:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)
	subq $48, %rsp
	movq -8(%rbp), %rax
	addq -16(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -48(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -32(%rbp),%rax
	addq $48, %rsp
	popq %rbp
	ret
	.text
	.globl sub
	.type sub, @function
sub:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)
	subq $48, %rsp
	movq -8(%rbp), %rax
	subq -16(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -48(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -32(%rbp),%rax
	addq $48, %rsp
	popq %rbp
	ret
	.text
	.globl mult
	.type mult, @function
mult:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)
	subq $48, %rsp
	movq -8(%rbp), %rax
	imulq -16(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -48(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -32(%rbp),%rax
	addq $48, %rsp
	popq %rbp
	ret
	.text
	.globl div
	.type div, @function
div:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)
	subq $48, %rsp
	movq -8(%rbp), %rax
	cqto
	idivq -16(%rbp)
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -48(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -32(%rbp),%rax
	addq $48, %rsp
	popq %rbp
	ret
	.text
	.globl mod
	.type mod, @function
mod:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)
	subq $48, %rsp
	movq -8(%rbp), %rax
	cqto
	idivq -16(%rbp)
	movq %rdx, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -48(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -32(%rbp),%rax
	addq $48, %rsp
	popq %rbp
	ret
	.text
	.globl main
	.type main, @function
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1816, %rsp
	movq $.LC0,%rax
	movq %rax, -56(%rbp)
	movq -56(%rbp), %rax
	movq %rax, -48(%rbp)
	movq $.LC1,%rax
	movq %rax, -856(%rbp)
	movq -856(%rbp), %rax
	movq %rax, -848(%rbp)
	movq $.LC2,%rax
	movq %rax, -1128(%rbp)
	movq -1128(%rbp), %rax
	movq %rax, -1120(%rbp)
	movq $.LC3,%rax
	movq %rax, -1328(%rbp)
	movq -1328(%rbp), %rax
	movq %rax, -1320(%rbp)
	movq $.LC4,%rax
	movq %rax, -1528(%rbp)
	movq -1528(%rbp), %rax
	movq %rax, -1520(%rbp)
	movq -48(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -16(%rbp)
	movq -16(%rbp), %rax
	movq %rax, -1568(%rbp)
.L29:
	movq $1, %rax
	movq %rax, -1576(%rbp)
	movq -16(%rbp), %rax
	cmpq -1576(%rbp), %rax
	jge .L0
	jmp .L4
.L0:
	movq $5, %rax
	movq %rax, -1584(%rbp)
	movq -16(%rbp), %rax
	cmpq -1584(%rbp), %rax
	jle .L2
	jmp .L4
	jmp .L4
.L2:
	movq -1120(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -24(%rbp), %rax
	movq %rax, -1592(%rbp)
	movq -1320(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -1600(%rbp)
	movq $1, %rax
	movq %rax, -1608(%rbp)
	movq -16(%rbp), %rax
	cmpq -1608(%rbp), %rax
	je .L5
	jmp .L6
	jmp .L28
.L5:
	movq -32(%rbp), %rax
	movq %rax, -1616(%rbp)
	movq -24(%rbp), %rax
	movq %rax, -1624(%rbp)
	movq -1616(%rbp), %rax
	movq %rax,0(%rsp)
	movq -1624(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	movq 0(%rsp),%rsi
	call add
	movq %rax, -1632(%rbp)
	movq -1632(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -1640(%rbp)
	jmp .L28
.L6:
	movq $2, %rax
	movq %rax, -1648(%rbp)
	movq -16(%rbp), %rax
	cmpq -1648(%rbp), %rax
	je .L9
	jmp .L10
	jmp .L11
.L9:
	movq -32(%rbp), %rax
	movq %rax, -1656(%rbp)
	movq -24(%rbp), %rax
	movq %rax, -1664(%rbp)
	movq -1656(%rbp), %rax
	movq %rax,0(%rsp)
	movq -1664(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	movq 0(%rsp),%rsi
	call sub
	movq %rax, -1672(%rbp)
	movq -1672(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -1680(%rbp)
	jmp .L28
.L10:
	movq $3, %rax
	movq %rax, -1688(%rbp)
	movq -16(%rbp), %rax
	cmpq -1688(%rbp), %rax
	je .L13
	jmp .L14
	jmp .L15
.L13:
	movq -32(%rbp), %rax
	movq %rax, -1696(%rbp)
	movq -24(%rbp), %rax
	movq %rax, -1704(%rbp)
	movq -1696(%rbp), %rax
	movq %rax,0(%rsp)
	movq -1704(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	movq 0(%rsp),%rsi
	call mult
	movq %rax, -1712(%rbp)
	movq -1712(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -1720(%rbp)
	jmp .L28
.L14:
	movq $4, %rax
	movq %rax, -1728(%rbp)
	movq -16(%rbp), %rax
	cmpq -1728(%rbp), %rax
	je .L17
	jmp .L18
	jmp .L19
.L17:
	movq -32(%rbp), %rax
	movq %rax, -1736(%rbp)
	movq -24(%rbp), %rax
	movq %rax, -1744(%rbp)
	movq -1736(%rbp), %rax
	movq %rax,0(%rsp)
	movq -1744(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	movq 0(%rsp),%rsi
	call div
	movq %rax, -1752(%rbp)
	movq -1752(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -1760(%rbp)
	jmp .L28
.L18:
	movq $5, %rax
	movq %rax, -1768(%rbp)
	movq -16(%rbp), %rax
	cmpq -1768(%rbp), %rax
	je .L21
	jmp .L28
	jmp .L23
.L21:
	movq -32(%rbp), %rax
	movq %rax, -1776(%rbp)
	movq -24(%rbp), %rax
	movq %rax, -1784(%rbp)
	movq -1776(%rbp), %rax
	movq %rax,0(%rsp)
	movq -1784(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	movq 0(%rsp),%rsi
	call mod
	movq %rax, -1792(%rbp)
	movq -1792(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -40(%rbp), %rax
	movq %rax, -1800(%rbp)
	jmp .L28
.L23:
	jmp .L28
.L19:
	jmp .L28
.L15:
	jmp .L28
.L11:
	jmp .L28
.L28:
	movq -1520(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -848(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -40(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call printi
	movq -1520(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -1520(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -48(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -16(%rbp)
	movq -16(%rbp), %rax
	movq %rax, -1808(%rbp)
	jmp .L29
.L4:
	movq $0, %rax
	movq %rax, -1816(%rbp)
	movq -1816(%rbp), %rax
	movq %rax, -8(%rbp)
	movq -1816(%rbp),%rax
	addq $1816, %rsp
	popq %rbp
	ret
