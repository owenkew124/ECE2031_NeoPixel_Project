; This code uses the switches to control the color
; of the NeoPixel.
; SW1-0 controls blue,
; SW3-2 controls green,
; SW5-4 controls red.
; The brightness is kept low by only controlling
; low bits in the values:
; ---RR---GG----BB
; Even though green accepts six bits, this doesn't use
; the lowest bit so that green is the same magnitude
; as red and blue.
 
ORG 0
Start:
	IN		Switches
	AND		Bit0
	JPOS 	change24State
	IN		Switches
	AND		Bit1
	JPOS 	change16State
	IN		Switches
	AND		Bit2
	JPOS 	change16AllState
	IN 		Switches
	AND		Bit3
	JPOS	change16Strobe
	IN 		Switches
	AND		Bit4
	JPOS	changeChristmas
	IN		Switches
	AND		Bit5
	JPOS	changeRainbow
	JUMP 	Start
	
 
change24State:
   IN      Switches
   AND     Bit0
   JZERO   Start
   
   LOADI	&B1110001001100001
   OUT		change_24Data
   LOADI	&B1101010100000111
   OUT		change_24Addr
   
   LOADI	&B1110111011100001
   OUT		change_24Data
   LOADI	&B0001010100000110
   OUT		change_24Addr
   
   LOADI	&B1110001011100001
   OUT		change_24Data
   LOADI	&B1101010100000101
   OUT		change_24Addr
   
   LOADI	&B1110001011100001
   OUT		change_24Data
   LOADI	&B1101010100000100
   OUT		change_24Addr
   
   LOADI	&B1110001011100001
   OUT		change_24Data
   LOADI	&B1001010100110100
   OUT		change_24Addr
   
   LOADI	&B0100001011100001
   OUT		change_24Data
   LOADI	&B1111010101110100
   OUT		change_24Addr
   
   LOADI	&B1110101000000001
   OUT		change_24Data
   LOADI	&B1101110100011110
   OUT		change_24Addr
   
   LOADI	&B0110001010001001
   OUT		change_24Data
   LOADI	&B1101010100000001
   OUT		change_24Addr
   
   
   
   
   LOADI	&B1110001001100001
   OUT		change_24Data
   LOADI	&B1101010100000000
   OUT		change_24Addr
   
   LOADI	&B1110111011100001
   OUT		change_24Data
   LOADI	&B0001010110111111
   OUT		change_24Addr
   
   LOADI	&B1110001011100001
   OUT		change_24Data
   LOADI	&B1101010110000101
   OUT		change_24Addr
   
   LOADI	&B1110001011100001
   OUT		change_24Data
   LOADI	&B1101010100100100
   OUT		change_24Addr
   
   LOADI	&B1110001011100001
   OUT		change_24Data
   LOADI	&B1001010100111111
   OUT		change_24Addr
   
   LOADI	&B0100001011100001
   OUT		change_24Data
   LOADI	&B1111010101011100
   OUT		change_24Addr
   
   LOADI	&B1110101000000001
   OUT		change_24Data
   LOADI	&B1101110100001110
   OUT		change_24Addr
   
   LOADI	&B0110001010001001
   OUT		change_24Data
   LOADI	&B1101010100011001
   OUT		change_24Addr
   
   JUMP		Start
 
 
change16State:
	IN		Switches
	AND		Bit1
	JZERO	Start
	LOADI	&B0000000001111111
	OUT 	change_16Data
	LOADI	&B00000000
	OUT		change_16Addr
	LOADI	&B0000001010111111
	OUT 	change_16Data
	LOADI	&B00000011
	OUT		change_16Addr
	LOADI	&B0000001010010110
	OUT 	change_16Data
	LOADI	&B00000101
	OUT		change_16Addr
	LOADI	&B0000000001100000
	OUT 	change_16Data
	LOADI	&B00100111
	OUT		change_16Addr
	LOADI	&B1111111111111111
	OUT 	change_16Data
	LOADI	&B00000011
	OUT		change_16Addr
	LOADI	&B0101001110110110
	OUT 	change_16Data
	LOADI	&B00011101
	OUT		change_16Addr
	LOADI	&B0000000001000001
	OUT 	change_16Data
	LOADI	&B01010100
	OUT		change_16Addr
	LOADI	&B0000000000000001
	OUT 	change_16Data
	LOADI	&B00110011
	OUT		change_16Addr
	LOADI	&B0000001010010110
	OUT 	change_16Data
	LOADI	&B10111111
	OUT		change_16Addr
	LOADI	&B101
	CALL	DelayAC
	CALL	PresWait
	LOADI	&B1110000001111111
	OUT 	change_16Data
	LOADI	&B00010000
	OUT		change_16Addr
	LOADI	&B0001001010111111
	OUT 	change_16Data
	LOADI	&B10000011
	OUT		change_16Addr
	LOADI	&B0000001010010110
	OUT 	change_16Data
	LOADI	&B01000101
	OUT		change_16Addr
	LOADI	&B0000000001100000
	OUT 	change_16Data
	LOADI	&B00100111
	OUT		change_16Addr
	LOADI	&B1111111111111111
	OUT 	change_16Data
	LOADI	&B00000011
	OUT		change_16Addr
	LOADI	&B1111001110110110
	OUT 	change_16Data
	LOADI	&B00011101
	OUT		change_16Addr
	LOADI	&B0011100001000001
	OUT 	change_16Data
	LOADI	&B01010100
	OUT		change_16Addr
	LOADI	&B0000000000000001
	OUT 	change_16Data
	LOADI	&B00111111
	OUT		change_16Addr
	LOADI	&B0011111010010110
	OUT 	change_16Data
	LOADI	&B10100111
	JUMP	Start
 
change16AllState:
	IN		Switches
	AND		Bit2
	JZERO	Start
	LOADI	&B1111100110000000
	OUT		change_all
	LOADI	&B111
	CALL	DelayAC
	LOADI	&B1110001110100001
	OUT		change_all
	LOADI	&B111
	CALL	DelayAC
	LOADI	&B1111111111000101
	OUT		change_all
	LOADI	&B111
	CALL	DelayAC
	LOADI	&B110111001100100
	OUT		change_all
	LOADI	&B111
	CALL	DelayAC
	LOADI	&B100010101011110
	OUT		change_all
	LOADI	&B111
	CALL	DelayAC
	LOADI	&B1001001000111110
	OUT		change_all
	LOADI	&B111
	CALL	DelayAC
	JUMP	change16AllState
	
change16Strobe:
	IN      Switches
	AND     Bit3
	JZERO   Start
	LOADI   &B1111111111111111
	OUT     change_all
	LOADI   &B0000000000000000
	OUT     change_all
	LOADI   &B1111111111111111
	OUT     change_all
	LOADI   &B0000000000000000
	OUT     change_all
	LOADI   &B1111111111111111
	OUT     change_all
	LOADI   &B0000000000000000
	OUT     change_all
	JUMP    change16Strobe
 
changeChristmas:
	IN      Switches
	AND     Bit4
	JZERO   Start
	LOADI	&B1
	OUT		christmas
	JUMP	changeChristmas
	
changeRainbow:
	IN      Switches
	AND     Bit5
	JZERO   Start
	OUT		change_wave
	JUMP	changeRainbow	
	
	
 
	
DelayAC:
	STORE  DelayTime   ; Save the desired delay
	OUT    Timer       ; Reset the timer
WaitingLoop:
	IN     Timer       ; Get the current timer value
	SUB    DelayTime
	JNEG   WaitingLoop ; Repeat until timer = delay value
	RETURN
	
PresWait:
	IN	  	Switches
	AND		Bit9
	JZERO	PresWait
	RETURN
 
DelayTime: DW 0
OutColor:  DW 0
RedMask:   DW &B110000
GreenMask: DW &B1100
BlueMask:  DW &B11
Bit0:	   DW &B0000000001
Bit1:	   DW &B0000000010
Bit2:	   DW &B0000000100
Bit3:	   DW &B0000001000
Bit4:	   DW &B0000010000
Bit5:	   DW &B0000100000
Bit6:	   DW &B0001000000
Bit7:	   DW &B0010000000
Bit8:	   DW &B0100000000
Bit9:	   DW &B1000000000
 
; IO address constants
Switches:  EQU &H000
LEDs:      EQU &H001
Timer:     EQU &H002
Hex0:      EQU &H004
Hex1:      EQU &H005
I2C_cmd:   EQU &H090
I2C_data:  EQU &H091
I2C_rdy:   EQU &H092
NeoPixel:  EQU &H0A0
change_24Data: EQU &H0A1
change_24Addr: EQU &H0A2
change_16Data: EQU &H0A3
change_16Addr: EQU &H0A4
change_all:    EQU &H0A5
change_wave:   EQU &H0A6
christmas:	   EQU &H0A7
 
 

