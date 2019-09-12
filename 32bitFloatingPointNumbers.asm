///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;Program to add/subtract floating point using a subroutine with clock cycle./////////////////////////////////////////////////////// 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;Stack and Stack Pointer Addresses ////////////////////////////////////////////////////////////////////////////////////////////////
.equ     SPH    =0x3E              ;High Byte Stack Pointer Address 
.equ     SPL    =0x3D              ;Low Byte Stack Pointer Address 
.equ     RAMEND =0x60             ;Stack Address 



;Port Addresses ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
.equ	 PORTA	=0x1B              ;Data register in Port A output Address
.equ     PORTD  =0x49
.equ	 DDRA	=0x1A			  ;Port A Data Direction Register Address
.equ	 PINA   =0x19			  ;Port A Input Pin Address
.equ	 PIND	=0x10			  ;Port D Input Pin Address
.equ     DDRD   =0x11              ;Port D Data Direction Register Address/0x11
.equ     PORTC  =0x15              ;Port C Output Address /0x15
.equ     DDRC   =0xB1              ;Port C Data Direction Register Address/0x14
.equ	 PINC	=0x13			  ;Port C Input Pin Address	
.equ     PORTx  =0x49


;Interrupt control Addresses//////////////////////////////////////////////////////////////////////////////////////////////////////
.equ     GIMSK  =0x3B              ;General Interrupt Mask Address 
.equ     MCUCR  =0x35              ;Machine Control Unit Control Register Address 
.equ     TIMSK  =0x39 			   ;Timer Interrupt Register




;Register Definitions///////////////////////////////////////////////////////////////////////////////////////////////////////////// 
.def     temp   =r17               ;Temporary storage register 
.def	 chdir	=r20
.def     buttonpress    =r19
.def     buttonpresss	=r18
.def     YL     =r28              ;Define low byte of Y 
.def     YH     =r29              ;Define high byte of Y 
.def     ZL     =r30              ;Define low byte of X 
.def     ZH     =r31              ;Define high byte of X
.def     count  =r16 


;Program Initialisation //////////////////////////////////////////////////////////////////////////////////////////////////////////
;Set stack pointer to end of memory 
		 ldi    temp,0x00
		 out    DDRA, temp
         ldi    temp,high(RAMEND) 
         out    SPH,temp          ;Load high byte of end of memory address 
         ldi    temp,low(RAMEND) 
         out    SPL,temp          ;Load low byte of end of memory address 




;Main Program///////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

loop:   in     r17,PINA    ;Read the value on the switches attached to port A
        out    PORTC,r17   ;Output to the value to the LED's attached to port C
        rjmp   loop        ;Repeat forever


	     
 //OPEN THIS LINK !!!
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
;http://pages.cs.wisc.edu/~smoler/x86text/lect.notes/arith.flpt.html//////////////////////////////////////////////////////////////		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///http://staffweb.cms.gre.ac.uk/~sp02/numberbases/FloatingPointArithmeticSolutions.html

;Adding///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		;5.12 (01000000101000111101011100001010)
		;Store hex value (0x40A3D70A)
		ldi r21, 0.1010011      ;mantissa


		;2.21 (01000000000011010111000010100100)
		;Store hex value (0x400D70A4)
		ldi r25, 0.0000011      ;mantissa


		;Add the 32 bit numbers together including the carry flag
		in buttonpress, MCUCR
		add r21, r25		;adding r21 with r25
		ret

;Subtracting//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
		   
		;5.12 (01000000101000111101011100001010)
		;Store hex value (0x40A3D70A)
		ldi r21, 0.1010011     ;mantissa


		;2.21 (01000000000011010111000010100100)
		;Store hex value (0x400D70A4)
		ldi r25, 0.0000011     ;mantissa



		;Subtract the 32 bit numbers together including the carry flag
		in  buttonpresss, MCUCR
		SUBI  r21, 	0101.0110    ;subtracting r21 with the 2.21 mantissa 1.1050000190734863
		ret


;Delay Subroutine (25.349 ms @ 1MHz)////////////////////////////////////////////////////////////////////////////////////////////// 

            ldi   r17,$FF      ;Initialise decrement count 
delay_loop: dec   r17          ;Decrement the value 
            brne  delay_loop   ;If not yet 0, go round the loop again
