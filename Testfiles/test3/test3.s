	.section	.rodata
	.LC2:	.string	" "
	.LC3:	.string	"Enter the element a: "
	.LC5:	.string	"Enter the element b: "
	.LC4:	.string	"\n"
	.LC0:	.string	"suma = "
	.LC1:	.string	"sumb = "
	.text
	.globl multiply
	.type multiply, @function
multiply:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, -8(%rbp)
	subq $40, %rsp
	movq $2, %rax
	movq %rax, -24(%rbp)
	movq -8(%rbp), %rax
	imulq -24(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -40(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -16(%rbp)
	movq -8(%rbp),%rax
	addq $40, %rsp
	popq %rbp
	ret
	.text
	.globl main
	.type main, @function
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $1280, %rsp
	movq $50, %rax
	movq %rax, -416(%rbp)
	movq $.LC0,%rax
	movq %rax, -480(%rbp)
	movq -480(%rbp), %rax
	movq %rax, -472(%rbp)
	movq $.LC1,%rax
	movq %rax, -568(%rbp)
	movq -568(%rbp), %rax
	movq %rax, -560(%rbp)
	movq $.LC2,%rax
	movq %rax, -656(%rbp)
	movq -656(%rbp), %rax
	movq %rax, -648(%rbp)
	movq $.LC3,%rax
	movq %rax, -696(%rbp)
	movq -696(%rbp), %rax
	movq %rax, -688(%rbp)
	movq $.LC4,%rax
	movq %rax, -896(%rbp)
	movq -896(%rbp), %rax
	movq %rax, -888(%rbp)
	movq $.LC5,%rax
	movq %rax, -944(%rbp)
	movq -944(%rbp), %rax
	movq %rax, -936(%rbp)
	movq -688(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -440(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1136(%rbp)
	movq -936(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -448(%rbp)
	movq -448(%rbp), %rax
	movq %rax, -1144(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -456(%rbp)
	movq -456(%rbp), %rax
	movq %rax, -1152(%rbp)
	movq -448(%rbp), %rax
	movq %rax, -464(%rbp)
	movq -464(%rbp), %rax
	movq %rax, -1160(%rbp)
.L10:
	movq $0, %rax
	movq %rax, -1168(%rbp)
	movq -440(%rbp), %rax
	cmpq -1168(%rbp), %rax
	jg .L2
	jmp .L1
.L1:
	movq $0, %rax
	movq %rax, -1176(%rbp)
	movq -448(%rbp), %rax
	cmpq -1176(%rbp), %rax
	jg .L2
	jmp .L4
	jmp .L4
.L2:
	movq -440(%rbp), %rax
	cmpq -448(%rbp), %rax
	jl .L5
	jmp .L6
	jmp .L7
.L5:
	movq -464(%rbp), %rax
	movq %rax, -1184(%rbp)
	movq -1184(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call multiply
	movq %rax, -1192(%rbp)
	movq -1192(%rbp), %rax
	movq %rax, -464(%rbp)
	movq -464(%rbp), %rax
	movq %rax, -1200(%rbp)
	movq $1, %rax
	movq %rax, -1208(%rbp)
	movq -448(%rbp), %rax
	subq -1208(%rbp), %rax
	movq %rax, -1216(%rbp)
	movq -1216(%rbp), %rax
	movq %rax, -448(%rbp)
	movq -448(%rbp), %rax
	movq %rax, -1224(%rbp)
	jmp .L10
.L6:
	movq -456(%rbp), %rax
	movq %rax, -1232(%rbp)
	movq -1232(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call multiply
	movq %rax, -1240(%rbp)
	movq -1240(%rbp), %rax
	movq %rax, -456(%rbp)
	movq -456(%rbp), %rax
	movq %rax, -1248(%rbp)
	movq $1, %rax
	movq %rax, -1256(%rbp)
	movq -440(%rbp), %rax
	subq -1256(%rbp), %rax
	movq %rax, -1264(%rbp)
	movq -1264(%rbp), %rax
	movq %rax, -440(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1272(%rbp)
	jmp .L10
.L7:
	jmp .L10
.L4:
	movq -472(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -456(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call printi
	movq -888(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -560(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -464(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call printi
	movq -888(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq $0, %rax
	movq %rax, -1280(%rbp)
	movq -1280(%rbp), %rax
	movq %rax, -8(%rbp)
	movq -1280(%rbp),%rax
	addq $1280, %rsp
	popq %rbp
	ret
