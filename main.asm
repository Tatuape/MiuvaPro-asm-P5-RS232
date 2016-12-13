; ***********************************************************
;   INTESC electronics & embedded
;
;   Curso b�sico de microcontroladores en ensamblador	    
;
;   Pr�ctica 5: Uso del m�dulo EUSART
;   Objetivo: Conocer el funcionamiento del m�dulo EUSART
;
;   Fecha: 05/Jun/16
;   Creado por: Daniel Hern�ndez Rodr�guez
;************************************************************

LIST    P = 18F87J50	;PIC a utilizar
INCLUDE <P18F87J50.INC>

;************************************************************
;Configuraci�n de fusibles
CONFIG  FOSC = HS   
CONFIG  DEBUG = OFF
CONFIG  XINST = OFF

;***********************************************************
;C�digo
CBLOCK  0x000
    recibido
ENDC
    
ORG 0x00    ;Iniciar el programa en el registro 0x00
    goto INICIO

INICIO
    movlw   0x00
    movwf   TRISJ	;Puerto B como salida
    movlw   0xFF
    movwf   TRISC	;CONF. PARA HABILITAR EUSART

;CONFIGURACI�N PARA LA RECEPCI�N DE DATOS
    movlw   D'12'
    movwf   SPBRG	;Configuraci�n de baudios adecuada (9600)
    bcf	    TXSTA,BRGH	    ;Low speed
    bcf	    BAUDCON,BRG16   ;Selecci�n de velocidad adecuada (8 bit) Solo SPBRG
    bcf	    TXSTA,SYNC	    ;Puerto serial as�ncrono
    bsf	    RCSTA,SPEN	    ;Habilita puerto serial
    bsf	    RCSTA,CREN	    ;Habilitamos la recepci�n
    
;CONFIGURACI�N PARA EL ENV�O DE DATOS
    ;movlw   D'12'
    ;movwf   SPBRG	;Configuraci�n de baudios adecuada (9600)
    ;bcf	    TXSTA,BRGH	    ;Low speed
    ;bcf	    BAUDCON,BRG16   ;Selecci�n de velocidad adecuada (8 bit) Solo SPBRG
    ;bcf	    TXSTA,SYNC	    ;Puerto serial as�ncrono
    ;bsf	    RCSTA,SPEN	    ;Habilita puerto serial
    bsf	    TXSTA,TXEN	    ;Habilitamos el env�o
    
ESPERA
    btfss   PIR1,RC1IF	    ;Esperamos a que est� lista la conversi�n
    goto    ESPERA	    ;Regresamos a espera
    movff   RCREG1,recibido  ;Almacenamos el dato recibido
    movff   recibido,PORTJ  ;Mostramos el dato recibido en el puerto B
	movff	recibido,TXREG
    bsf	    RCSTA,CREN	    ;Habilitamos la recepci�n de datos
    goto    ESPERA	    ;Regresamos a esperar la recepci�n de un dato
	
end
