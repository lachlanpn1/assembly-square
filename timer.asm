Delay:                         ; Uses dedicated timer register
TIMER_OFFSET=$3000             ; Offset of Timer Registers from BASE
mov r3,r0                      ; Moves BASE into r3.
orr r3,TIMER_OFFSET            ; Combines Timer Offset with BASE
mov r4,r1                      ; Moves r1 into r4 (delay time as specified in kernel)
ldrd r6,r7,[r3,#4]             ; Store the current time (64bit time)
mov r5,r6                      ; Moves r6 into r5 (start time) - We don't need the higher register (r5) so can overwrite it.
loopt1:
  ldrd r6,r7,[r3,#4]           ; Loads current time
  sub r8,r6,r5                 ; Subtracts the start time from the current time.
  cmp  r8,r4                   ;
  bls loopt1                   ; if remaining time (r8) <= delay time (r4) repeat loop
bx lr                          ; Returns to the address of the instruction after the function was called.

