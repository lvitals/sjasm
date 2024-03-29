	output "hello.com"

BDOS: equ 0005h	; Set the address 0005h into label BDOS.
		; We can call several routines under MSX-DOS at address 0005h.

	org 100h	; Compilation start address.
			; MSX-DOS commands start always at address 0100h.

	ld de,Hello_TXT	; Load the address of the label "Hello_TXT" into DE.
	ld c,9		; C must contain function number of the MSX-DOS.
	call BDOS	; Call the function 9 (Print function).
	ret		; Back to the MSX-DOS environment.

Hello_TXT:			; Set the current address into label Hello_TXT. (text pointer)
	db "Hello world!$"	; The character $ (24h) indicates the end of text for function 9.
