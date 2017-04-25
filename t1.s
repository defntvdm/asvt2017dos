	.text
	.globl 	main
main:
	mfence
	rdtscp
	pushq 	%rax
	pushq 	%rdx
#######################################
#Команды для замера

#	xorq 	$1000000, %rcx
#1:
#	decq 	%rcx
#	jne 	1b
#	#loopq 	1b

#	movq 	$100, %rcx
#2:
#	pushq 	%rax
#	popq 	%rax
#	decq 	%rcx
#	jne 	2b


	pushfq
	popfq
#######################################
	mfence
	rdtscp			 	#rax - младшая часть второго счётчика
					 	#rdx - старшая часть второго счётчика
	popq 	%r12 	 	#r12 - старшая часть первого счётчика
	popq 	%r13 	 	#r13 - младшая часть первого счётчика
	movq 	%rdx, %rcx 	
	shl 	$32, %rcx 	
	addq 	%rax, %rcx 	#rcx - полный второй счётчик

	movq 	%r12, %r14 	
	shl 	$32, %r14 	
	addq 	%r13, %r14 	#r14 - полный первый счётчик
	subq 	%r14, %rcx 	#rcx - разница
	pushq 	%rcx
	pushq 	%rax
	pushq 	%rdx
	movq 	$msg1, %rdi
	movq 	%r12, %rsi
	movq 	%r13, %rdx
	xorq 	%rax, %rax
	callq 	printf

	popq 	%rsi
	popq 	%rdx
	movq 	$msg1, %rdi
	xorq 	%rax, %rax
	callq 	printf

	popq 	%rsi
	movq 	$msg2, %rdi
	xorq 	%rax, %rax
	callq 	printf
	retq

.data
	msg1: 	.asciz 	"TSC  = %08x%08x\n"
	msg2: 	.asciz 	"Diff = %li\n"
