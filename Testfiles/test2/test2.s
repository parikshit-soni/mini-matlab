	.section	.rodata
	.LC0:	.string	"Enter number of elements\n"
	.LC1:	.string	"Enter the elements: "
	.LC2:	.string	"The sum of array is: "
	.LC3:	.string	"\n"
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
	.globl main
	.type main, @function
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $840, %rsp
	movq $.LC0,%rax
	movq %rax, -72(%rbp)
	movq -72(%rbp), %rax
	movq %rax, -64(%rbp)
	movq $.LC1,%rax
	movq %rax, -312(%rbp)
	movq -312(%rbp), %rax
	movq %rax, -304(%rbp)
	movq $.LC2,%rax
	movq %rax, -504(%rbp)
	movq -504(%rbp), %rax
	movq %rax, -496(%rbp)
	movq $.LC3,%rax
	movq %rax, -704(%rbp)
	movq -704(%rbp), %rax
	movq %rax, -696(%rbp)
	movq -64(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -24(%rbp), %rax
	movq %rax, -744(%rbp)
	movq $0, %rax
	movq %rax, -752(%rbp)
	movq -752(%rbp), %rax
	movq %rax, -48(%rbp)
	movq -48(%rbp), %rax
	movq %rax, -760(%rbp)
	movq $0, %rax
	movq %rax, -768(%rbp)
	movq -768(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -776(%rbp)
.L3:
	movq -32(%rbp), %rax
	cmpq -24(%rbp), %rax
	jl .L0
	jmp .L2
	jmp .L2
.L4:
	movq -32(%rbp), %rax
	movq %rax, -784(%rbp)
	movq -784(%rbp), %rax
	movq %rax, -792(%rbp)
	movq -784(%rbp), %rax
	addq $1, %rax
	movq %rax, -784(%rbp)
	movq -784(%rbp), %rax
	movq %rax, -32(%rbp)
	jmp .L3
.L0:
	movq -304(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -56(%rbp)
	movq -56(%rbp), %rax
	movq %rax, -800(%rbp)
	movq -56(%rbp), %rax
	movq %rax, -808(%rbp)
	movq -48(%rbp), %rax
	movq %rax, -816(%rbp)
	movq -808(%rbp), %rax
	movq %rax,0(%rsp)
	movq -816(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rsi
	movq 0(%rsp),%rdi
	call add
	movq %rax, -824(%rbp)
	movq -824(%rbp), %rax
	movq %rax, -48(%rbp)
	movq -48(%rbp), %rax
	movq %rax, -832(%rbp)
	jmp .L4
.L2:
	movq -496(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -48(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call printi
	movq -696(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq $0, %rax
	movq %rax, -840(%rbp)
	movq -840(%rbp), %rax
	movq %rax, -8(%rbp)
	movq -840(%rbp),%rax
	addq $840, %rsp
	popq %rbp
	ret
