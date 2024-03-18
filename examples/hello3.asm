; Print "Hello world!" from cartridge environment.
;
; Save the assembled file with the name HELLO.ROM then
; you can run it on emulator

	output "hello.rom"

CHPUT: equ 0A2h	; Set the address of character output routine of main Rom BIOS
		; Main Rom is already selected (0000h ~ 3FFFh/7FFFh) when a
		; Rom is being executed.

RomSize: equ 4000h	; For 16kB Rom size.

; Compilation address
	 org 4000h	; 8000h can be also used here if Rom size is 16kB or less.

; ROM header (Put 0000h as address when unused)
	 db "AB"	; ID for auto-executable Rom at MSX start
	 dw Execute	; Main program execution address.

; Program code entry point
Execute:
	call ClearScreen	; Call routine to clear the screen.
	ld hl,Hello_TXT	; Load the address from the label Hello_TXT into HL.
	call Print	; Call the routine Print below.

; Halt program execution. Change to "ret" to return to MSX-BASIC.
Finished:
	jr Finished	; Jump to itself endlessly.

Print:
	ld a,(hl)	; Load the byte from memory at address indicated by HL to A.
	and a	; Same as CP 0 but faster.
	ret z	; Back behind the call print if A = 0
	call CHPUT	; Call the routine to display a character.
	inc hl	; Increment the HL value.
	jr Print	; Relative jump to the address in the label Print.

ClearScreen:
	ld a, 12	; ASCII code for clear screen
	call CHPUT	; Call the routine to display the character
	ret

; Message data
Hello_TXT:	; Set the current address into label Hello_TXT. (text pointer)
	db "Hello world!",0	; Zero indicates the end of text.
End:
