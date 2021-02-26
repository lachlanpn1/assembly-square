redLight:
 GPIO_OFFSET = $200000
 mov r0,BASE
 orr r0,GPIO_OFFSET
 mov r1,#1
 lsl r1,#24
 str r1,[r0,#4]     ;set GPIO18 to output
 mov r1,#1
 lsl r1,#18
 str r1,[r0,#28]  ;turn GPIO 18 LED on
   mov r1,#1
   lsl r1,#23
   str r1,[r0,#40]  ;turn GPIO 23 LED off
bx lr