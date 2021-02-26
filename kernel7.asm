format binary as 'img'

BASE = $3F000000  ; base address for 2.
org $0000
mov sp,$1000

GPIO_OFFSET = $200000
mov r10,BASE
orr r10,GPIO_OFFSET            ; Base address of GPIOs
ldr r8,[r10,#4]                ; Reads the register or GPIO 10-19
bic r8,r8,#27                  ; Bit clear 27=9*3
str r8,[r10,#4]                ; Store r8 at r10 offset by 4 bytes

mov r0,BASE
bl FB_Init                     ; Moves address of screen into r0.
and r0,$3FFFFFFF               ; Converts Mail Box Frame Buffer Pointer from BUS to Physical Address
str r0,[FB_POINTER]            ; Store Frame Buffer Pointer Physical Address

mov r7,r0                      ; Backup copy of frame buffer pointer address

mov r5,#100                    ; X Coordinate of top-left edge of square
mov r11,#300                   ; Y Coordinate of top-left edge of square

loop$:                         ; Loop that draws to the screen
  mov r4,$AA00                 ;
  orr r4,$000E                 ; Moves square colour into r4.
  ldr r9,[r10,#52]             ; Loads the value from r10 offset by 52 bytes (state of GPIO pin)
  tst r9,$10000                ; Tests that the 16th bit is set (button pressed)
  bne ker_up                   ; Move to ker_up label and execute from there
  add r11,#15                  ; If the button is not pressed, add 15 to the Y coordinate (move square down)
  push{r0,r1}                  ; Push the values of r0 and r1 to the stack
   bl redLight                 ; Turn red light on and green light off.
  pop{r0,r1}                   ; Restore the values of r0 and r1 by popping them from the stack
  b ker_render                 ; Move to the ker_render label and execute from there.


ker_up:                        ; Button is pressed
 sub r11,#15                   ; Subtract 15 from r11 (move square up)
 push{r0,r1}                   ; Push the values of r0 and r1 to the stack
 bl greenLight                 ; Turn green light on and red light off.
 pop{r0,r1}                    ; Restore the values of r0 and r1.

ker_render:
mov r12,r11                    ; Copy Y Coordinate into r12.
add r12,#80                    ; Add 80 to Y coordinate (determine end point)
square_outer:                  ; Draws many rows of pixels between y and y+80
 square_inner:                 ; Draws a row of pixels between x and x+80
  push{r0-r3}                  ; Push the values of r0-r3 to stack
  mov r0,r7                    ; Frame Buffer Pointer
  mov r1,r5                    ; current X
  mov r2,r11                   ; current Y
  mov r3,r4                    ; Colour
   bl drawpixel                ; Draw pixel to screen
  pop{r0-r3}                   ; Restore values of r0 - r3
  add r5,#1                    ; Add one to current X
 cmp r5,#180                   ; Compare current X to 180 (endpoint)
 bls square_inner              ; If X is less than or equal to 180, repeat inner loop
 add r11,#1                    ; Add one to current Y
 mov r5,#100                   ; Reset X back to start of row (100)
cmp r11,r12                    ; Compare current Y to Y end point (Y+80)
bls square_outer               ; If Y is less than or equal to Y end point, repeat outer loop
sub r11,#80                    ; Subtract 80 from Y - reset to start of square.

 push{r0-r12}                  ; Push r0-12 to stack
  mov r0,BASE                  ; Move value at BASE into register 0
  mov r1,$20000                ; Build time delay
  orr r1,$00000                ;
  orr r1,$0008D                ; r1 = $BF110
  bl Delay                     ; Call delay function
 pop{r0-r12}                   ; Pop r0-r12 from stack

 mov r9,r11                    ; Move value of Y into r9
 cmp r9,#4                     ; if Y < 4
 ble ker_top                   ;  move to ker_top label and execute from there
 cmp r9,#480                   ; else if Y <= 480
 bls ker_cont2                 ;  move to ker_cont2 label and execute from there
 mov r11,#4                    ; else Y > 480 so move square back to top of screen
 b ker_cont2                   ;
 ker_top:                      ; Square is less than 4 (about to move off top of screen)
 mov r11,#480                  ; Set Y to 480 back to bottom screen
 ker_cont2:                    ; 4 < Y <= 480 (valid)


 mov r6,r11                    ; Move Y into r6
 push{r0-r12}                  ; Push r0-r12 to stack
   bl clear                    ; Call clear function - sets area to black to remove old squares
 pop{r0-r12}                   ; Pop r0-r12 from stack and restore values
 mov r11,r6                    ; Set Y equal to value from r6.

 ker_cont:
 b loop$                       ; Restart loop

include "FBInit.asm"           ; Initialises screen
include "timer.asm"            ; Holds Delay function for pausing between rendering and clearing square
include "drawPixel.asm"        ; Draws a pixel to the screen
include "clearScreen.ASM"      ; Clears the region of the square to black
include "greenLight.asm"       ; Turns on green LED and turns red LED off
include "redLight.asm"         ; Turns on red LED and turns green LED off
