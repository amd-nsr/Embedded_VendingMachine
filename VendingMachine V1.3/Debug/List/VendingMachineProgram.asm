
;CodeVisionAVR C Compiler V3.31 Evaluation
;(C) Copyright 1998-2017 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _price=R5
	.DEF _counter=R4
	.DEF _itemNumber=R7
	.DEF __lcd_x=R6
	.DEF __lcd_y=R9
	.DEF __lcd_maxx=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _external_int0
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x0:
	.DB  0x63,0x6F,0x69,0x6E,0x73,0x3A,0x0,0x54
	.DB  0x61,0x6B,0x65,0x20,0x59,0x6F,0x75,0x72
	.DB  0x20,0x49,0x74,0x65,0x6D,0x0,0x43,0x68
	.DB  0x6F,0x73,0x65,0x20,0x31,0x3A,0x34,0x0
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x5E
	.DB  0x5F,0x5E,0x0,0x70,0x72,0x69,0x63,0x65
	.DB  0x20,0x3A,0x0,0x69,0x74,0x65,0x6D,0x20
	.DB  0x6E,0x75,0x6D,0x62,0x65,0x72,0x0,0x69
	.DB  0x74,0x65,0x6D,0x20,0x70,0x72,0x69,0x63
	.DB  0x65,0x0,0x64,0x6F,0x6E,0x65,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x07
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x4+7
	.DW  _0x0*2+7

	.DW  0x0A
	.DW  _0x4+22
	.DW  _0x0*2+22

	.DW  0x0B
	.DW  _0x1D
	.DW  _0x0*2+32

	.DW  0x0A
	.DW  _0x1D+11
	.DW  _0x0*2+22

	.DW  0x08
	.DW  _0x1D+21
	.DW  _0x0*2+43

	.DW  0x0C
	.DW  _0x1D+29
	.DW  _0x0*2+51

	.DW  0x0B
	.DW  _0x1D+41
	.DW  _0x0*2+63

	.DW  0x05
	.DW  _0x1D+52
	.DW  _0x0*2+74

	.DW  0x0C
	.DW  _0x1D+57
	.DW  _0x0*2+51

	.DW  0x0A
	.DW  _0x1D+69
	.DW  _0x0*2+22

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
;/*
; * VendingMachineProgram.c
; *
; * Created: 11/27/2018 12:22:52 PM
; * Author: Batman
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <interrupt.h>
;	flags -> R17
;#include <delay.h>
;
;//unsigned char i = 0;
;unsigned char price;
;unsigned char counter=0;
;
;char itemNumber;
;char get_key();
;void EE_WriteC(char adr, char data);
;char EE_ReadC(char adr);
;
;interrupt [2] void external_int0(void)
; 0000 0017 {

	.CSEG
_external_int0:
; .FSTART _external_int0
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0018     lcd_clear();
	RCALL _lcd_clear
; 0000 0019     lcd_puts("coins:");
	__POINTW2MN _0x4,0
	RCALL SUBOPT_0x0
; 0000 001A     lcd_gotoxy(0,1);
; 0000 001B     counter++;
	INC  R4
; 0000 001C     lcd_putchar(counter + 48);
	MOV  R26,R4
	SUBI R26,-LOW(48)
	RCALL _lcd_putchar
; 0000 001D     if(counter == price){
	CP   R5,R4
	BRNE _0x5
; 0000 001E       lcd_clear();
	RCALL _lcd_clear
; 0000 001F       lcd_puts("Take Your Item");
	__POINTW2MN _0x4,7
	RCALL _lcd_puts
; 0000 0020       delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0021       switch (itemNumber)
	MOV  R30,R7
	LDI  R31,0
; 0000 0022              {
; 0000 0023              case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x9
; 0000 0024                 PORTB.0 = 1;
	SBI  0x18,0
; 0000 0025                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0026                 PORTB.0 = 0;
	CBI  0x18,0
; 0000 0027                 break;
	RJMP _0x8
; 0000 0028 
; 0000 0029              case 2:
_0x9:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xE
; 0000 002A                  PORTB.1 = 1;
	SBI  0x18,1
; 0000 002B                   delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 002C                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 002D                   break;
	RJMP _0x8
; 0000 002E              case 3:
_0xE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x13
; 0000 002F                  PORTB.2 = 1;
	SBI  0x18,2
; 0000 0030                   delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0031                    PORTB.2 = 0;
	CBI  0x18,2
; 0000 0032                  break;
	RJMP _0x8
; 0000 0033 
; 0000 0034              case 4:
_0x13:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8
; 0000 0035                  PORTB.3 = 1;
	SBI  0x18,3
; 0000 0036                   delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0037                    PORTB.3 = 0;
	CBI  0x18,3
; 0000 0038                  break;
; 0000 0039              }
_0x8:
; 0000 003A       counter = 0;
	CLR  R4
; 0000 003B       lcd_clear();
	RCALL _lcd_clear
; 0000 003C       lcd_puts("Chose 1:4");
	__POINTW2MN _0x4,22
	RCALL _lcd_puts
; 0000 003D     }
; 0000 003E }
_0x5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x4:
	.BYTE 0x20
;
;void main(void)
; 0000 0041 {

	.CSEG
_main:
; .FSTART _main
; 0000 0042     DDRC = 0b00000111; // For KeyPad
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 0043     PORTC = 0b11111000; // Enable internal pull-up for 4 rows.
	LDI  R30,LOW(248)
	OUT  0x15,R30
; 0000 0044 
; 0000 0045     DDRB = 0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0046     #asm("sei");
	SEI
; 0000 0047 
; 0000 0048     GICR   =0b01000000;
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0049     MCUCR |=0b00000010;
	IN   R30,0x35
	ORI  R30,2
	OUT  0x35,R30
; 0000 004A     MCUCR &=0b11111110;
	IN   R30,0x35
	ANDI R30,0xFE
	OUT  0x35,R30
; 0000 004B     EE_WriteC(1, 2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _EE_WriteC
; 0000 004C 	EE_WriteC(2, 3);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _EE_WriteC
; 0000 004D 	EE_WriteC(3, 2);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _EE_WriteC
; 0000 004E     EE_WriteC(4, 3);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _EE_WriteC
; 0000 004F     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0050     lcd_puts("Welcome^_^");
	__POINTW2MN _0x1D,0
	RCALL _lcd_puts
; 0000 0051     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0052     lcd_clear();
	RCALL _lcd_clear
; 0000 0053     lcd_puts("Chose 1:4");
	__POINTW2MN _0x1D,11
	RCALL _lcd_puts
; 0000 0054       /*
; 0000 0055        while (1){
; 0000 0056         lcd_puts("0 Start");
; 0000 0057         itemNumber = get_key();
; 0000 0058         if(itemNumber == 0)
; 0000 0059         break;}
; 0000 005A         */
; 0000 005B while (1)
_0x1E:
; 0000 005C     {
; 0000 005D 
; 0000 005E         itemNumber = get_key();
	RCALL _get_key
	MOV  R7,R30
; 0000 005F         if(itemNumber >0 && itemNumber <5){
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x22
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0x23
_0x22:
	RJMP _0x21
_0x23:
; 0000 0060         price = EE_ReadC(itemNumber);
	MOV  R26,R7
	RCALL _EE_ReadC
	MOV  R5,R30
; 0000 0061         lcd_clear();
	RCALL _lcd_clear
; 0000 0062         lcd_puts("price :");
	__POINTW2MN _0x1D,21
	RCALL SUBOPT_0x0
; 0000 0063         lcd_gotoxy(0, 1);
; 0000 0064         lcd_putchar(price + 48);
	MOV  R26,R5
	SUBI R26,-LOW(48)
	RCALL _lcd_putchar
; 0000 0065         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0066          }
; 0000 0067         else if(itemNumber == 11){
	RJMP _0x24
_0x21:
	LDI  R30,LOW(11)
	CP   R30,R7
	BRNE _0x25
; 0000 0068 
; 0000 0069         while(get_key() != 10){
_0x26:
	RCALL _get_key
	CPI  R30,LOW(0xA)
	BREQ _0x28
; 0000 006A         lcd_clear();
	RCALL _lcd_clear
; 0000 006B         lcd_puts("item number");
	__POINTW2MN _0x1D,29
	RCALL _lcd_puts
; 0000 006C         itemNumber = get_key();
	RCALL _get_key
	MOV  R7,R30
; 0000 006D         lcd_clear();
	RCALL _lcd_clear
; 0000 006E         lcd_puts("item price");
	__POINTW2MN _0x1D,41
	RCALL _lcd_puts
; 0000 006F         EE_WriteC(itemNumber, get_key());
	ST   -Y,R7
	RCALL _get_key
	MOV  R26,R30
	RCALL _EE_WriteC
; 0000 0070         lcd_clear();
	RCALL _lcd_clear
; 0000 0071         lcd_puts("done");
	__POINTW2MN _0x1D,52
	RCALL _lcd_puts
; 0000 0072         delay_ms(700);
	LDI  R26,LOW(700)
	LDI  R27,HIGH(700)
	RCALL _delay_ms
; 0000 0073         lcd_clear();
	RCALL _lcd_clear
; 0000 0074         lcd_puts("item number");
	__POINTW2MN _0x1D,57
	RCALL _lcd_puts
; 0000 0075         }
	RJMP _0x26
_0x28:
; 0000 0076         }
; 0000 0077         else{
	RJMP _0x29
_0x25:
; 0000 0078              lcd_clear();
	RCALL _lcd_clear
; 0000 0079              lcd_puts("Chose 1:4");
	__POINTW2MN _0x1D,69
	RCALL _lcd_puts
; 0000 007A         }
_0x29:
_0x24:
; 0000 007B 
; 0000 007C     }
	RJMP _0x1E
; 0000 007D }
_0x2A:
	RJMP _0x2A
; .FEND

	.DSEG
_0x1D:
	.BYTE 0x4F
;char get_key()
; 0000 007F {

	.CSEG
_get_key:
; .FSTART _get_key
; 0000 0080     while (1)
_0x2B:
; 0000 0081         {
; 0000 0082 
; 0000 0083             PORTC.0 = 0;  //Activate C1 by "Low"
	CBI  0x15,0
; 0000 0084             PORTC.1 = 1;  //Deactivate C2 by High
	SBI  0x15,1
; 0000 0085             PORTC.2 = 1;  //Deactivate C3 by High
	SBI  0x15,2
; 0000 0086 
; 0000 0087             switch (PINC)
	IN   R30,0x13
; 0000 0088                    {
; 0000 0089                    case 0b11110110 :
	CPI  R30,LOW(0xF6)
	BRNE _0x37
; 0000 008A                    while (PINC.3==0) ;   // Hang execution untill switch is released
_0x38:
	SBIS 0x13,3
	RJMP _0x38
; 0000 008B                    return 1;
	LDI  R30,LOW(1)
	RET
; 0000 008C                    break;
	RJMP _0x36
; 0000 008D 
; 0000 008E                    case 0b11101110 :
_0x37:
	CPI  R30,LOW(0xEE)
	BRNE _0x3B
; 0000 008F                    while (PINC.4==0) ;   // Hang execution untill switch is released
_0x3C:
	SBIS 0x13,4
	RJMP _0x3C
; 0000 0090                    return 4;
	LDI  R30,LOW(4)
	RET
; 0000 0091                    break;
	RJMP _0x36
; 0000 0092 
; 0000 0093                    case 0b11011110 :
_0x3B:
	CPI  R30,LOW(0xDE)
	BRNE _0x3F
; 0000 0094                    while (PINC.5==0) ;   // Hang execution untill switch is released
_0x40:
	SBIS 0x13,5
	RJMP _0x40
; 0000 0095                    return 7;
	LDI  R30,LOW(7)
	RET
; 0000 0096                    break;
	RJMP _0x36
; 0000 0097 
; 0000 0098                    case 0b10111110 :
_0x3F:
	CPI  R30,LOW(0xBE)
	BRNE _0x36
; 0000 0099                    while (PINC.6==0) ;   // Hang execution untill switch is released
_0x44:
	SBIS 0x13,6
	RJMP _0x44
; 0000 009A                    return 10;
	LDI  R30,LOW(10)
	RET
; 0000 009B                    break;
; 0000 009C                    }
_0x36:
; 0000 009D 
; 0000 009E             PORTC.0 = 1;  //Deactivate C1 by High
	SBI  0x15,0
; 0000 009F             PORTC.1 = 0;  //Activate C2 by low
	CBI  0x15,1
; 0000 00A0             PORTC.2 = 1;  //Deactivate C3 by High
	SBI  0x15,2
; 0000 00A1 
; 0000 00A2             switch (PINC)
	IN   R30,0x13
; 0000 00A3                    {
; 0000 00A4                    case 0b11110101 :
	CPI  R30,LOW(0xF5)
	BRNE _0x50
; 0000 00A5                    while (PINC.3==0) ;   // Hang execution untill switch is released
_0x51:
	SBIS 0x13,3
	RJMP _0x51
; 0000 00A6                    return 2;
	LDI  R30,LOW(2)
	RET
; 0000 00A7                    break;
	RJMP _0x4F
; 0000 00A8 
; 0000 00A9                    case 0b11101101 :
_0x50:
	CPI  R30,LOW(0xED)
	BRNE _0x54
; 0000 00AA                    while (PINC.4==0) ;   // Hang execution untill switch is released
_0x55:
	SBIS 0x13,4
	RJMP _0x55
; 0000 00AB                    return 5;
	LDI  R30,LOW(5)
	RET
; 0000 00AC                    break;
	RJMP _0x4F
; 0000 00AD 
; 0000 00AE                    case 0b11011101 :
_0x54:
	CPI  R30,LOW(0xDD)
	BRNE _0x58
; 0000 00AF                    while (PINC.5==0) ;   // Hang execution untill switch is released
_0x59:
	SBIS 0x13,5
	RJMP _0x59
; 0000 00B0                    return 8;
	LDI  R30,LOW(8)
	RET
; 0000 00B1                    break;
	RJMP _0x4F
; 0000 00B2 
; 0000 00B3                    case 0b10111101 :
_0x58:
	CPI  R30,LOW(0xBD)
	BRNE _0x4F
; 0000 00B4                    while (PINC.6==0) ;   // Hang execution untill switch is released
_0x5D:
	SBIS 0x13,6
	RJMP _0x5D
; 0000 00B5                    return 0;
	LDI  R30,LOW(0)
	RET
; 0000 00B6                    break;
; 0000 00B7                    }
_0x4F:
; 0000 00B8 
; 0000 00B9             PORTC.0 = 1;  //Deactivate C1 by High
	SBI  0x15,0
; 0000 00BA             PORTC.1 = 1;  //Deactivate C2 by High
	SBI  0x15,1
; 0000 00BB             PORTC.2 = 0;  //Activate C3 by Low
	CBI  0x15,2
; 0000 00BC 
; 0000 00BD             switch (PINC)
	IN   R30,0x13
; 0000 00BE                    {
; 0000 00BF                    case 0b11110011 :
	CPI  R30,LOW(0xF3)
	BRNE _0x69
; 0000 00C0                    while (PINC.3==0) ;   // Hang execution untill switch is released
_0x6A:
	SBIS 0x13,3
	RJMP _0x6A
; 0000 00C1                    return 3;
	LDI  R30,LOW(3)
	RET
; 0000 00C2                    break;
	RJMP _0x68
; 0000 00C3 
; 0000 00C4                    case 0b11101011 :
_0x69:
	CPI  R30,LOW(0xEB)
	BRNE _0x6D
; 0000 00C5                    while (PINC.4==0) ;   // Hang execution untill switch is released
_0x6E:
	SBIS 0x13,4
	RJMP _0x6E
; 0000 00C6                    return 6;
	LDI  R30,LOW(6)
	RET
; 0000 00C7                    break;
	RJMP _0x68
; 0000 00C8 
; 0000 00C9                    case 0b11011011 :
_0x6D:
	CPI  R30,LOW(0xDB)
	BRNE _0x71
; 0000 00CA                    while (PINC.5==0) ;   // Hang execution untill switch is released
_0x72:
	SBIS 0x13,5
	RJMP _0x72
; 0000 00CB                    return 9;
	LDI  R30,LOW(9)
	RET
; 0000 00CC                    break;
	RJMP _0x68
; 0000 00CD 
; 0000 00CE                    case 0b10111011 :
_0x71:
	CPI  R30,LOW(0xBB)
	BRNE _0x68
; 0000 00CF                    while (PINC.6==0) ;   // Hang execution untill switch is released
_0x76:
	SBIS 0x13,6
	RJMP _0x76
; 0000 00D0                    return 11;
	LDI  R30,LOW(11)
	RET
; 0000 00D1                    break;
; 0000 00D2                    }
_0x68:
; 0000 00D3 		}
	RJMP _0x2B
; 0000 00D4 }
; .FEND
;
;void EE_WriteC(char adr, char data)
; 0000 00D7 {
_EE_WriteC:
; .FSTART _EE_WriteC
; 0000 00D8 while (EECR.1==1);
	RCALL SUBOPT_0x1
;	adr -> R16
;	data -> R17
_0x79:
	SBIC 0x1C,1
	RJMP _0x79
; 0000 00D9 EEDR= data;
	OUT  0x1D,R17
; 0000 00DA EEAR= adr;
	MOV  R30,R16
	LDI  R31,0
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 00DB EECR.2=1;    //Enable Master Write;
	SBI  0x1C,2
; 0000 00DC EECR.1=1;    // Begin writing;
	SBI  0x1C,1
; 0000 00DD }
	RJMP _0x2080002
; .FEND
;
;char EE_ReadC(char adr)
; 0000 00E0 {
_EE_ReadC:
; .FSTART _EE_ReadC
; 0000 00E1  while (EECR.1==1);
	ST   -Y,R17
	MOV  R17,R26
;	adr -> R17
_0x80:
	SBIC 0x1C,1
	RJMP _0x80
; 0000 00E2  EEAR= adr;
	MOV  R30,R17
	LDI  R31,0
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 00E3  EECR.0=1;   //Begin Reading
	SBI  0x1C,0
; 0000 00E4  return EEDR;
	IN   R30,0x1D
	RJMP _0x2080001
; 0000 00E5 }
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	RCALL SUBOPT_0x1
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R6,R16
	MOV  R9,R17
_0x2080002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	MOV  R9,R30
	MOV  R6,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	CP   R6,R8
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R9
	MOV  R26,R9
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x2080001
_0x2000004:
	INC  R6
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	MOV  R8,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	RCALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
