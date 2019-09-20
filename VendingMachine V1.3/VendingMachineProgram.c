/*
 * VendingMachineProgram.c
 *
 * Created: 11/27/2018 12:22:52 PM
 * Author: Batman
 */

#include <io.h>
#include <alcd.h>
#include <interrupt.h>
#include <delay.h>

//unsigned char i = 0;
unsigned char price;
unsigned char counter=0;

char itemNumber;
char get_key();
void EE_WriteC(char adr, char data);
char EE_ReadC(char adr);

interrupt [2] void external_int0(void) 
{
    lcd_clear();
    lcd_puts("coins:");
    lcd_gotoxy(0,1);
    counter++;
    lcd_putchar(counter + 48);
    if(counter == price){
      lcd_clear();
      lcd_puts("Take Your Item");
      delay_ms(1000);
      switch (itemNumber)
             {
             case 1:
                PORTB.0 = 1;
                delay_ms(1000);
                PORTB.0 = 0;
                break;

             case 2:
                 PORTB.1 = 1;
                  delay_ms(1000);
                  PORTB.1 = 0;
                  break;
             case 3:
                 PORTB.2 = 1;
                  delay_ms(1000); 
                   PORTB.2 = 0;
                 break;

             case 4:
                 PORTB.3 = 1;
                  delay_ms(1000);
                   PORTB.3 = 0;
                 break;
             }
      counter = 0;
      lcd_clear();
      lcd_puts("Chose 1:4");  
    }  
}

void main(void)
{ 
    DDRC = 0b00000111; // For KeyPad
    PORTC = 0b11111000; // Enable internal pull-up for 4 rows.
    
    DDRB = 0xff;
    #asm("sei");
    
    GICR   =0b01000000;
    MCUCR |=0b00000010;
    MCUCR &=0b11111110;
    EE_WriteC(1, 2);
	EE_WriteC(2, 3);
	EE_WriteC(3, 2);
    EE_WriteC(4, 3);
    lcd_init(16);
    lcd_puts("Welcome^_^");
    delay_ms(500);
    lcd_clear();
    lcd_puts("Chose 1:4");
      /*
       while (1){
        lcd_puts("0 Start");
        itemNumber = get_key();
        if(itemNumber == 0)
        break;} 
        */
while (1)
    {   
        
        itemNumber = get_key();
        if(itemNumber >0 && itemNumber <5){
        price = EE_ReadC(itemNumber);
        lcd_clear();
        lcd_puts("price :");
        lcd_gotoxy(0, 1);
        lcd_putchar(price + 48);
        delay_ms(1000);
         }    
        else if(itemNumber == 11){
       
        while(get_key() != 10){
        lcd_clear();
        lcd_puts("item number");
        itemNumber = get_key();
        lcd_clear();
        lcd_puts("item price");
        EE_WriteC(itemNumber, get_key());
        lcd_clear();
        lcd_puts("done");
        delay_ms(700);
        lcd_clear();
        lcd_puts("item number");
        }
        }
        else{
             lcd_clear();
             lcd_puts("Chose 1:4");
        }

    }
}
char get_key()
{
    while (1)
        {

            PORTC.0 = 0;  //Activate C1 by "Low"
            PORTC.1 = 1;  //Deactivate C2 by High
            PORTC.2 = 1;  //Deactivate C3 by High
            
            switch (PINC)
                   {
                   case 0b11110110 :
                   while (PINC.3==0) ;   // Hang execution untill switch is released
                   return 1;
                   break;

                   case 0b11101110 :
                   while (PINC.4==0) ;   // Hang execution untill switch is released
                   return 4;
                   break;
                   
                   case 0b11011110 :
                   while (PINC.5==0) ;   // Hang execution untill switch is released
                   return 7;
                   break;
                   
                   case 0b10111110 :
                   while (PINC.6==0) ;   // Hang execution untill switch is released
                   return 10;
                   break;
                   }
                   
            PORTC.0 = 1;  //Deactivate C1 by High
            PORTC.1 = 0;  //Activate C2 by low
            PORTC.2 = 1;  //Deactivate C3 by High
            
            switch (PINC)
                   {
                   case 0b11110101 :
                   while (PINC.3==0) ;   // Hang execution untill switch is released
                   return 2;
                   break;

                   case 0b11101101 :
                   while (PINC.4==0) ;   // Hang execution untill switch is released
                   return 5;
                   break;
                   
                   case 0b11011101 :
                   while (PINC.5==0) ;   // Hang execution untill switch is released
                   return 8;
                   break;
                   
                   case 0b10111101 :
                   while (PINC.6==0) ;   // Hang execution untill switch is released
                   return 0;
                   break;
                   }
                   
            PORTC.0 = 1;  //Deactivate C1 by High
            PORTC.1 = 1;  //Deactivate C2 by High
            PORTC.2 = 0;  //Activate C3 by Low
            
            switch (PINC)
                   {
                   case 0b11110011 :
                   while (PINC.3==0) ;   // Hang execution untill switch is released
                   return 3;
                   break;

                   case 0b11101011 :
                   while (PINC.4==0) ;   // Hang execution untill switch is released
                   return 6;
                   break;
                   
                   case 0b11011011 :
                   while (PINC.5==0) ;   // Hang execution untill switch is released
                   return 9;
                   break;
                   
                   case 0b10111011 :
                   while (PINC.6==0) ;   // Hang execution untill switch is released
                   return 11;
                   break;
                   }
		}
}

void EE_WriteC(char adr, char data)
{
while (EECR.1==1);
EEDR= data;
EEAR= adr;
EECR.2=1;    //Enable Master Write;
EECR.1=1;    // Begin writing;
}

char EE_ReadC(char adr)
{
 while (EECR.1==1);
 EEAR= adr;
 EECR.0=1;   //Begin Reading
 return EEDR;
}