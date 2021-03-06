#INCLUDE <P16F628A.INC>		;ARQUIVO PADR�O MICROCHIP PARA 16F628A
;RADIX DEC
;__CONFIG _CP_OFF & _LVP_OFF & _BOREN_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT
__CONFIG H'3F10'

; O BOTAO SER� CONECTADO NO TERCEIRO BIT DE PORTA
#DEFINE BTN PORTA, 2
#DEFINE LED_C PORTB, 5 ; LED CONTROLE
#DEFINE LED_A4 PORTB, 4 ; LED ANDAR 4
#DEFINE LED_A3 PORTB, 3 ; LED ANDAR 3
#DEFINE LED_A2 PORTB, 2 ; LED ANDAR 2
#DEFINE LED_A1 PORTB, 1 ; LED ANDAR 1
#DEFINE LED_T PORTB, 0 ; LED T�RREO
#DEFINE BIT_STATUS_MOVIMENTO STATUS_MOVIMENTO, 0 ; bit 0 do status

	; AS VARI�VEIS ABAIXO SER�O RESERVADAS A
	; PARTIR DO ENDERE�O 0X20, QUE � UM ENDERE�O
	; DO BANCO ZERO DO PIC
	CBLOCK	0x20
	CONTADOR1
	CONTADOR2
	CONTADOR3
	CONTADOR_DE_DELAYS
	STATUS_MOVIMENTO
	ENDC	;FIM DO BLOCO DE MEM�RIA
	
	; AS INSTRU��ES ABAIXO SER�O COLOCADAS A
	; PARTIR DO ENDERE�O DE MEM�RIA 0X00. �
	; IMPORTANTE NOTAR QUE A ARQUITETURA DO PIC
	; � DE HARVARD, OU SEJA, O ENDERE�O 0X20 DA
	; DIRETIVA CBLOCK SE REFERE A UMA MEM�RIA
	; DIFERENTE DO ENDERE�O 0X00 DA DIRETIVA ORG.
	ORG	0x00
	; ESTA INSTRU��O FICAR� NO PRIMEIRO ENDERE�O
	; DA MEM�RIA PARA PROGRAMA. CASO QUEIRA
	; VISUALIZAR A MEM�RIA PARA PROGRAMA DO PIC:
	; (View -> Program Memory -> Symbolic)
	GOTO	INICIO

	; LINKS �TEIS:
	; https://en.wikipedia.org/wiki/PIC_instruction_listings
	; https://pictutorials.com/The_Status_Register.htm
	; DATASHEET:
	; http://web.mit.edu/6.115/www/document/16f628.pdf

INICIO
	CLRF	PORTA		; LIMPA O PORTA
	CLRF	PORTB		; LIMPA O PORTB
	; RP0 = REGISTER PAGE Bit 0
	; RP0 � UM BIT DE SELE��O DE BANCO DE MEM�RIA
	; RP0 � O SEXTO BIT DO REGISTRADOR STATUS
	; "BSF STATUS, RP0" � IGUAL A "BSF, STATUS, 5"
	; QUE EQUIVALE A COLOCAR O SEXTO BIT DE STATUS
	; COMO 1 (BSF = BIT SET FILE)
	;          B7	B6	B5	B4	B3	B2	B1	B0
	; STATUS = IRP	RP1	RP0	TO	PD	Z	DC	C
	; B6 E B5 SERVEM PARA SELECIONAR UM DOS 4
	; BANCOS DE MEM�RIA.
	; Z = ZERO FLAG
	; DC = DIGIT CARRY
	; C = CARRY
	BSF STATUS, RP0
	; AGORA, OS BITS DE SELE��O DO BANCO DE
	; MEM�RIA FORMAM O NUMERO 01, POIS
	; RP1 = 0 (ESSE � O BIT 6 DO STATUS)
	; RP0 = 1 (BSF LIGOU O BIT RP0 (BIT 5))
	; QUE EQUIVALE A ACESSAR O BANCO DE MEM�RIA 01

	; CLRF LIMPA O REGISTRADOR TRISB.
	; O REGISTRADOR TRISB EST� NO BANCO 1
	CLRF TRISB
	CLRF TRISA
	BSF TRISA, 2
	CLRF INTCON ; TODAS AS INTERRUP��ES DESLIGADAS

	; BCF LIMPA O BIT RP0(5) DO REGISTRADOR STATUS,
	; OU SEJA, VOLTAMOS AO BANCO DE MEM�RIA 00.
	BCF STATUS, RP0

	MOVLW B'00000111'
	MOVWF CMCON ; DESATIVA O COMPARADOR ANAL�GICO
	
	CLRF CONTADOR_DE_DELAYS ; Atribui zero
	CLRF STATUS_MOVIMENTO ; Atribui zero
	

;CICLO_NORMAL
;
;	CALL LIGAR_LED_T
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_T
;
;	CALL LIGAR_LED_A1
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_A1
;
;	CALL LIGAR_LED_A2
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_A2
;
;	CALL LIGAR_LED_A3
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_A3
;
;	CALL LIGAR_LED_A4
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_A4
;
;	CALL LIGAR_LED_A4
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_A4
;
;	CALL LIGAR_LED_A3
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_A3
;
;	CALL LIGAR_LED_A2
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_A2
;
;	CALL LIGAR_LED_A1
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_A1
;
;	CALL LIGAR_LED_T
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DELAY_1SEC ; 1 second delay with event trigger
;	CALL DESLIGAR_LED_T
;
;GOTO CICLO_NORMAL

LOOP_MOVIMENTO_NORMAL
	; skip if bit = 1. -> (up = 0, down = 1)
	BTFSS BIT_STATUS_MOVIMENTO
	GOTO LOOP_SUBIDA
	GOTO LOOP_DESCIDA
GOTO LOOP_MOVIMENTO_NORMAL

; ------------------ SUBIDA

LOOP_SUBIDA
	BTFSC LED_A4 ; skip next line if LED_A4 = 0
	GOTO CICLO_NORMAL_A4
	
	BTFSC LED_A3 ; skip next line if LED_A3 = 0
	GOTO CICLO_NORMAL_A3
	
	BTFSC LED_A2 ; skip next line if LED_A2 = 0
	GOTO CICLO_NORMAL_A2
	
	BTFSC LED_A1 ; skip next line if LED_A1 = 0
	GOTO CICLO_NORMAL_A1
	
	BTFSC LED_T ; skip next line if LED_T = 0
	GOTO CICLO_NORMAL_T

	CALL LOOP_SUBIDA_LEDS
GOTO LOOP_MOVIMENTO_NORMAL

LOOP_SUBIDA_LEDS
	BTFSC LED_A4 ; skip next line if LED_A4 = 0
	CALL LIGAR_LED_T_SUBIDA
	
	BTFSC LED_A3 ; skip next line if LED_A3 = 0
	CALL LIGAR_LED_A4_SUBIDA
	
	BTFSC LED_A2 ; skip next line if LED_A2 = 0
	CALL LIGAR_LED_A3_SUBIDA
	
	BTFSC LED_A1 ; skip next line if LED_A1 = 0
	CALL LIGAR_LED_A2_SUBIDA
	
	BTFSC LED_T ; skip next line if LED_T = 0
	CALL LIGAR_LED_A1_SUBIDA
RETURN

; ----------------- DESCIDA

LOOP_DESCIDA
	BTFSC LED_A4 ; skip next line if LED_A4 = 0
	GOTO CICLO_NORMAL_A4
	
	BTFSC LED_A3 ; skip next line if LED_A3 = 0
	GOTO CICLO_NORMAL_A3
	
	BTFSC LED_A2 ; skip next line if LED_A2 = 0
	GOTO CICLO_NORMAL_A2
	
	BTFSC LED_A1 ; skip next line if LED_A1 = 0
	GOTO CICLO_NORMAL_A1
	
	BTFSC LED_T ; skip next line if LED_T = 0
	GOTO CICLO_NORMAL_T
	
	CALL LOOP_DESCIDA_LEDS
GOTO LOOP_MOVIMENTO_NORMAL

LOOP_DESCIDA_LEDS
	BTFSC LED_A4 ; skip next line if LED_A4 = 0
	CALL LIGAR_LED_A3_DESCIDA
	
	BTFSC LED_A3 ; skip next line if LED_A3 = 0
	CALL LIGAR_LED_A2_DESCIDA
	
	BTFSC LED_A2 ; skip next line if LED_A2 = 0
	CALL LIGAR_LED_A1_DESCIDA
	
	BTFSC LED_A1 ; skip next line if LED_A1 = 0
	CALL LIGAR_LED_T_DESCIDA
	
	BTFSC LED_T ; skip next line if LED_T = 0
	CALL LIGAR_LED_A4_DESCIDA
RETURN

; ---------------- CICLO DE DELAYS PARA CADA ANDAR

CICLO_NORMAL_A4
	MOVLW 0x0A
	MOVWF CONTADOR_DE_DELAYS
	GOTO DELAY_WITH_TRIGGER
    
CICLO_NORMAL_A3
	MOVLW 0x08
	MOVWF CONTADOR_DE_DELAYS
	GOTO DELAY_WITH_TRIGGER
    
CICLO_NORMAL_A2
	MOVLW 0x06
	MOVWF CONTADOR_DE_DELAYS
	GOTO DELAY_WITH_TRIGGER
    
CICLO_NORMAL_A1
	MOVLW 0x04
	MOVWF CONTADOR_DE_DELAYS
	GOTO DELAY_WITH_TRIGGER
    
CICLO_NORMAL_T
	MOVLW 0x02
	MOVWF CONTADOR_DE_DELAYS
	GOTO DELAY_WITH_TRIGGER

; --------------------- DELAY COM GATILHO DE EVENTO

DELAY_WITH_TRIGGER
ATRASO1_HEADER_FOR1 ; header of for1
	MOVLW	21			; Move literal to accumulator
	MOVWF	CONTADOR1	; Move accumulator value to file
	
ATRASO1_BODY_FOR1 ; body of for1
	
	ATRASO1_HEADER_FOR2 ; header of for2
		BTFSS	BTN ; Skip next line if BTN = 1
		GOTO	CICLO_EMERGENCIA ; Goto if BTN = 1
		MOVLW	20			; Move literal to accumulator
		MOVWF	CONTADOR2	; Move accumulator value to file

	ATRASO1_BODY_FOR2 ; body of for2
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		ATRASO1_HEADER_FOR3 ; header of for3
			MOVLW	255			; Move literal to accumulator
			MOVWF	CONTADOR3	; Move accumulator value to file
			
		ATRASO1_BODY_FOR3 ; body of for3
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			DECFSZ	CONTADOR3	; Decrement file, skip next line if 0
			GOTO	ATRASO1_BODY_FOR3
		
		DECFSZ	CONTADOR2	; Decrement file, skip next line if 0
		GOTO	ATRASO1_BODY_FOR2
		
	DECFSZ	CONTADOR1	; Decrement file, skip next line if 0
	GOTO	ATRASO1_BODY_FOR1
	
	BTFSS LED_C ; skip next line if LED_C = 1
	GOTO LIGAR_LED_C_ATRASO1
	GOTO DESLIGAR_LED_C_ATRASO1

MYRETURN_ATRASO1
	DECFSZ CONTADOR_DE_DELAYS ; skip next if 0
	GOTO DELAY_WITH_TRIGGER ; faz a mesma coisa de novo
GOTO LOOP_MOVIMENTO_NORMAL ; vai para o "menu" dos loopings

LIGAR_LED_C_ATRASO1
	BSF LED_C
	GOTO MYRETURN_ATRASO1

DESLIGAR_LED_C_ATRASO1
	BCF LED_C
	GOTO MYRETURN_ATRASO1

; -------------- LEDS

LIGAR_LED_A4
	BSF LED_A4
RETURN

DESLIGAR_LED_A4
	BCF LED_A4
RETURN

LIGAR_LED_A3
	BSF LED_A3
RETURN

DESLIGAR_LED_A3
	BCF LED_A3
RETURN

LIGAR_LED_A2
	BSF LED_A2
RETURN

DESLIGAR_LED_A2
	BCF LED_A2
RETURN

LIGAR_LED_A1
	BSF LED_A1
RETURN

DESLIGAR_LED_A1
	BCF LED_A1
RETURN

LIGAR_LED_T
	BSF LED_T
RETURN

DESLIGAR_LED_T
	BCF LED_T
RETURN

; -------------- LEDS SUBIDA

LIGAR_LED_A4_SUBIDA
	CALL DESLIGAR_LED_A3
	CALL LIGAR_LED_A4
RETURN

LIGAR_LED_A3_SUBIDA
	CALL DESLIGAR_LED_A2
	CALL LIGAR_LED_A3
RETURN

LIGAR_LED_A2_SUBIDA
	CALL DESLIGAR_LED_A1
	CALL LIGAR_LED_A2
RETURN

LIGAR_LED_A1_SUBIDA
	CALL DESLIGAR_LED_T
	CALL LIGAR_LED_A1
RETURN

LIGAR_LED_T_SUBIDA
	CALL DESLIGAR_LED_A4
	CALL LIGAR_LED_T
RETURN

; -------------- LEDS DESCIDA

LIGAR_LED_A4_DESCIDA
	CALL DESLIGAR_LED_T
	CALL LIGAR_LED_A4
RETURN

LIGAR_LED_A3_DESCIDA
	CALL DESLIGAR_LED_A4
	CALL LIGAR_LED_A3
RETURN

LIGAR_LED_A2_DESCIDA
	CALL DESLIGAR_LED_A3
	CALL LIGAR_LED_A2
RETURN

LIGAR_LED_A1_DESCIDA
	CALL DESLIGAR_LED_A2
	CALL LIGAR_LED_A1
RETURN

LIGAR_LED_T_DESCIDA
	CALL DESLIGAR_LED_A1
	CALL LIGAR_LED_T
RETURN

; --------------------- DELAY SEM GATILHO DE EVENTO

DELAY_1SEC_NO_TRIGGER
ATRASO2_HEADER_FOR1 ; header of for1
	MOVLW	21			; Move literal to accumulator
	MOVWF	CONTADOR1	; Move accumulator value to file
	
ATRASO2_BODY_FOR1 ; body of for1
	
	ATRASO2_HEADER_FOR2 ; header of for2
		MOVLW	20			; Move literal to accumulator
		MOVWF	CONTADOR2	; Move accumulator value to file

	ATRASO2_BODY_FOR2 ; body of for2
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		ATRASO2_HEADER_FOR3 ; header of for3
			MOVLW	255			; Move literal to accumulator
			MOVWF	CONTADOR3	; Move accumulator value to file
			
		ATRASO2_BODY_FOR3 ; body of for3
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			DECFSZ	CONTADOR3	; Decrement file, skip next line if 0
			GOTO	ATRASO2_BODY_FOR3
		
		DECFSZ	CONTADOR2	; Decrement file, skip next line if 0
		GOTO	ATRASO2_BODY_FOR2
		
	DECFSZ	CONTADOR1	; Decrement file, skip next line if 0
	GOTO	ATRASO2_BODY_FOR1
	
	BTFSS LED_C ; skip next line if LED_C = 1
	GOTO LIGAR_LED_C_ATRASO2
	GOTO DESLIGAR_LED_C_ATRASO2
MYRETURN_ATRASO2
RETURN

LIGAR_LED_C_ATRASO2
	BSF LED_C
	GOTO MYRETURN_ATRASO2

DESLIGAR_LED_C_ATRASO2
	BCF LED_C
	GOTO MYRETURN_ATRASO2

CICLO_EMERGENCIA
	BTFSC LED_A4 ; skip next line if LED_A4 = 0
	CALL CICLO_EMERGENCIA_A4
	
	BTFSC LED_A3 ; skip next line if LED_A3 = 0
	CALL CICLO_EMERGENCIA_A3
	
	BTFSC LED_A2 ; skip next line if LED_A2 = 0
	CALL CICLO_EMERGENCIA_A2
	
	BTFSC LED_A1 ; skip next line if LED_A1 = 0
	CALL CICLO_EMERGENCIA_A1
	
	BTFSC LED_T ; skip next line if LED_T = 0
	CALL CICLO_EMERGENCIA_T
	
GOTO LOOP_MOVIMENTO_NORMAL

CICLO_EMERGENCIA_A4
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DESLIGAR_LED_A4
	CALL LIGAR_LED_A3
RETURN

CICLO_EMERGENCIA_A3
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DESLIGAR_LED_A3
	CALL LIGAR_LED_A2
RETURN

CICLO_EMERGENCIA_A2
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DESLIGAR_LED_A2
	CALL LIGAR_LED_A1
RETURN

CICLO_EMERGENCIA_A1
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DESLIGAR_LED_A1
	CALL LIGAR_LED_T
RETURN

CICLO_EMERGENCIA_T
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
	CALL DELAY_1SEC_NO_TRIGGER
RETURN

END
