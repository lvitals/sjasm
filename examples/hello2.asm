; Print "Hello world!" under MSX-BASIC using BIOS function.
;
; Save the assembled file with the name HELLO.BIN then
; Load from MSX-BASIC with: BLOAD "HELLO.BIN",R

	output "hello.bin"

CHPUT: equ 000A2h	; Set the address of character output routine of main Rom BIOS
        		; Main Rom is already selected (0000h ~ 7FFFh) under MSX-Basic

; --> BLOAD header, before the ORG so that the header isn’t counted

	db 0FEh		; Binary file ID
	dw Begin	; begin address
	dw End - 1	; end address
	dw Execute	; program execution address (for ,R option)
	org 0C000h	; Some assemblers do not support anything other than the EQU statement above.
			; In this cas, move ORG before the header and add -7 behind.
Begin:
; Program code entry point
Execute:
	ld hl,Hello_TXT ; Load the address from the label Hello_TXT into HL.
	call Print      ; Call the routine Print below.
	ret             ; Back to MSX-BASIC environment.

Print:
	ld a,(hl)	; Load the byte from memory at address indicated by HL into A.
	and a		; Same as CP 0 but faster.
	ret z		; Back behind the call print if A = 0
	call CHPUT	; Call the routine to display a character.
	inc hl		; Increment the HL value.
	jr Print	; Relative jump to the address in the label Print.

Hello_TXT:			; Set the current address into label Hello_TXT. (text pointer)
	db "Hello world!",0	; Zero indicates the end of text.

End:
