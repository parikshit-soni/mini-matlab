	.section	.rodata
	.LC2:	.string	" "
	.LC3:	.string	"Enter the element a: "
	.LC5:	.string	"Enter the element b: "
	.LC4:	.string	"\n"
	.LC0:	.string	"max of a and b = "
	.LC1:	.string	"min of a and b = "
	.text
	.globl min
	.type min, @function
min:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)
	subq $48, %rsp
	movq -8(%rbp), %rax
	cmpq -16(%rbp), %rax
	jl .L0
	jmp .L1
	jmp .L4
.L0:
	movq -8(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -40(%rbp)
	jmp .L4
.L1:
	movq -16(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -48(%rbp)
	jmp .L4
.L4:
	movq -32(%rbp), %rax
	movq %rax, -24(%rbp)
	movq -32(%rbp),%rax
	addq $48, %rsp
	popq %rbp
	ret
	.text
	.globl max
	.type max, @function
max:
	pushq %rbp
	movq %rsp, %rbp
	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)
	subq $48, %rsp
	movq -8(%rbp), %rax
	cmpq -16(%rbp), %rax
	jg .L5
	jmp .L6
	jmp .L9
.L5:
	movq -8(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -40(%rbp)
	jmp .L9
.L6:
	movq -16(%rbp), %rax
	movq %rax, -32(%rbp)
	movq -32(%rbp), %rax
	movq %rax, -48(%rbp)
	jmp .L9
.L9:
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
	subq $1376, %rsp
	movq $50, %rax
	movq %rax, -416(%rbp)
	movq $.LC0,%rax
	movq %rax, -480(%rbp)
	movq -480(%rbp), %rax
	movq %rax, -472(%rbp)
	movq $.LC1,%rax
	movq %rax, -648(%rbp)
	movq -648(%rbp), %rax
	movq %rax, -640(%rbp)
	movq $.LC2,%rax
	movq %rax, -816(%rbp)
	movq -816(%rbp), %rax
	movq %rax, -808(%rbp)
	movq $.LC3,%rax
	movq %rax, -856(%rbp)
	movq -856(%rbp), %rax
	movq %rax, -848(%rbp)
	movq $.LC4,%rax
	movq %rax, -1056(%rbp)
	movq -1056(%rbp), %rax
	movq %rax, -1048(%rbp)
	movq $.LC5,%rax
	movq %rax, -1104(%rbp)
	movq -1104(%rbp), %rax
	movq %rax, -1096(%rbp)
	movq -848(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -440(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1296(%rbp)
	movq -1096(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	call readi
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	movq %rax, -448(%rbp)
	movq -448(%rbp), %rax
	movq %rax, -1304(%rbp)
	movq -448(%rbp), %rax
	movq %rax, -1312(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1320(%rbp)
	movq -1312(%rbp), %rax
	movq %rax,0(%rsp)
	movq -1320(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rsi
	movq 0(%rsp),%rdi
	call max
	movq %rax, -1328(%rbp)
	movq -1328(%rbp), %rax
	movq %rax, -456(%rbp)
	movq -456(%rbp), %rax
	movq %rax, -1336(%rbp)
	movq -448(%rbp), %rax
	movq %rax, -1344(%rbp)
	movq -440(%rbp), %rax
	movq %rax, -1352(%rbp)
	movq -1344(%rbp), %rax
	movq %rax,0(%rsp)
	movq -1352(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rsi
	movq 0(%rsp),%rdi
	call min
	movq %rax, -1360(%rbp)
	movq -1360(%rbp), %rax
	movq %rax, -464(%rbp)
	movq -464(%rbp), %rax
	movq %rax, -1368(%rbp)
	movq -472(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -456(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call printi
	movq -1048(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -640(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq -464(%rbp), %rax
	movq %rax,0(%rsp)
	movq 0(%rsp),%rdi
	call printi
	movq -1048(%rbp), %rax
	movq %rax,-8(%rsp)
	movq -8(%rsp),%rdi
	call prints
	movq $0, %rax
	movq %rax, -1376(%rbp)
	movq -1376(%rbp), %rax
	movq %rax, -8(%rbp)
	movq -1376(%rbp),%rax
	addq $1376, %rsp
	popq %rbp
	ret
