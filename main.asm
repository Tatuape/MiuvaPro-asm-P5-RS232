; ***********************************************************
;   INTESC electronics & embedded
;
;   Curso básico de microcontroladores en ensamblador	    
;
;   Práctica 5: Uso del módulo EUSART
;   Objetivo: Conocer el funcionamiento del módulo EUSART
;
;   Fecha: 05/Jun/16
;   Creado por: Daniel Hernández Rodríguez
;************************************************************

LIST    P = 18F87J50	;PIC a utilizar
INCLUDE <P18F87J50.INC>

;************************************************************
;Configuración de fusibles
CONFIG  FOSC = HS   
CONFIG  DEBUG = OFF
CONFIG  XINST = OFF

;***********************************************************
;Código
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

;CONFIGURACIÓN PARA LA RECEPCIÓN DE DATOS
    movlw   D'12'
    movwf   SPBRG	;Configuración de baudios adecuada (9600)
    bcf	    TXSTA,BRGH	    ;Low speed
    bcf	    BAUDCON,BRG16   ;Selección de velocidad adecuada (8 bit) Solo SPBRG
    bcf	    TXSTA,SYNC	    ;Puerto serial asíncrono
    bsf	    RCSTA,SPEN	    ;Habilita puerto serial
    bsf	    RCSTA,CREN	    ;Habilitamos la recepción
    
;CONFIGURACIÓN PARA EL ENVÍO DE DATOS
    ;movlw   D'12'
    ;movwf   SPBRG	;Configuración de baudios adecuada (9600)
    ;bcf	    TXSTA,BRGH	    ;Low speed
    ;bcf	    BAUDCON,BRG16   ;Selección de velocidad adecuada (8 bit) Solo SPBRG
    ;bcf	    TXSTA,SYNC	    ;Puerto serial asíncrono
    ;bsf	    RCSTA,SPEN	    ;Habilita puerto serial
    bsf	    TXSTA,TXEN	    ;Habilitamos el envío
    
ESPERA
    btfss   PIR1,RC1IF	    ;Esperamos a que esté lista la conversión
    goto    ESPERA	    ;Regresamos a espera
    movff   RCREG1,recibido  ;Almacenamos el dato recibido
    movff   recibido,PORTJ  ;Mostramos el dato recibido en el puerto B
	movff	recibido,TXREG
    bsf	    RCSTA,CREN	    ;Habilitamos la recepción de datos
    goto    ESPERA	    ;Regresamos a esperar la recepción de un dato
	
end
