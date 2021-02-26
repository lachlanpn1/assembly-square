clear:
push{lr}
  mov r4,$0000           ; black colour

  mov r12,r5
  add r12,#80

  mov r5,#100
  mov r11,#0

  clear_outer:            ; Iterates from top left corner of square area (100,0) to
  push{r0-r3}             ; bottom right corner of square area (180,480) and sets all pixels
    clear_inner:          ; to black to remove previous squares before new square is drawn
     mov r0,r7
     mov r1,r5
     mov r2,r11
     mov r3,r4
      bl drawpixel
     add r5,#1
    cmp r5,#180
    bls clear_inner
  pop{r0-r3}
  mov r5,#100
  add r11,#1
  cmp r11,#480
  bls clear_outer
pop{pc}
bx lr