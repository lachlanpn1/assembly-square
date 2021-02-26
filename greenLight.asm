greenLight:
  GPIO_OFFSET = $200000
  mov r0,BASE
  orr r0,GPIO_OFFSET
  mov r1,#1
  lsl r1,#9
  str r1,[r0,#8]     ;set GPIO23 to output
  mov r1,#1
  lsl r1,#23
  str r1,[r0,#28]  ;turn GPIO 23 LED on
  mov r1,#1
  lsl r1,#18
  str r1,[r0,#40]  ;turn GPIO 18 LED off
bx lr



