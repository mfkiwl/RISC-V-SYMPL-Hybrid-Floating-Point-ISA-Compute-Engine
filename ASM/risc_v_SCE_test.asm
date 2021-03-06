;-------------------------------------------------------------------------------------------
; RISC-V/SYMPL Compute Engine demo program 
; Version 1.01  December 30, 2019
; Author:  Jerry D. Harthcock
; Assembled using Cross-32 Universal Cross-Assembler and custom instruction table
; The RSIC-V (RV-32I) Hybrid instruction table is included in the non-commercial distribution package.
; Copyright (c) 2019. All rights reserved.
;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;//                                                                                                                    //
;//                                                    Open-Source                                                     //
;//                            SYMPL 64-Bit Universal Floating-point ISA Compute Engine and                            //
;//                                   Fused Universal Neural Network (FuNN) eNNgine                                    //
;//                                    Evaluation and Product Development License                                      //
;//                                                                                                                    //
;//                                                                                                                    //
;// Open-source means:  this source code and this instruction set ("this IP") may be freely downloaded, copied,        //
;// modified, distributed and used in accordance with the terms and conditons of the licenses provided herein.         //
;//                                                                                                                    //
;// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"),      //
;// the original author and exclusive copyright owner of this SYMPL 64-Bit Universal Floating-point ISA Compute Engine //
;// and Fused Universal Neural Network (FuNN) eNNgine, including related development software ("this IP"), hereby      //
;// grants recipient of this IP ("licensee"), a world-wide, paid-up, non-exclusive license to implement this IP        //
;// within the programmable fabric of Xilinx Kintex Ultra and Kintex Ultra+ brand FPGAs--only--and used only for the   //
;// purposes of evaluation, education, and development of end products and related development tools.  Furthermore,    //
;// limited to the purposes of prototyping, evaluation, characterization and testing of implementations in a hard,     //
;// custom or semi-custom ASIC, any university or institution of higher education may have their implementation of     //
;// this IP produced for said limited purposes at any foundary of their choosing provided that such prototypes do      //
;// not ever wind up in commercial circulation, with this license extending to such foundary and is in connection      //
;// with said academic pursuit and under the supervision of said university or institution of higher education.        //
;//                                                                                                                    //
;// Any copying, distribution, customization, modification, or derivative work of this IP must include an exact copy   //
;// of this license and original copyright notice at the very top of each source file and any derived netlist, and,    //
;// in the case of binaries, a printed copy of this license and/or a text format copy in a separate file distributed   //
;// with said netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to      //
;// remove any copyright notices from any source file covered or distributed under this Evaluation and Product         //
;// Development License.                                                                                               //
;//                                                                                                                    //
;// LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT INFRINGE THE RIGHTS OF OTHERS OR          //
;// THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE TO HOLD LICENSOR HARMLESS FROM        //
;// ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                                                     //
;//                                                                                                                    //
;// Licensor reserves all his rights, including, but in no way limited to, the right to change or modify the terms     //
;// and conditions of this Evaluation and Product Development License anytime without notice of any kind to anyone.    //
;// By using this IP for any purpose, licensee agrees to all the terms and conditions set forth in this Evaluation     //
;// and Product Development License.                                                                                   //
;//                                                                                                                    //
;// This Evaluation and Product Development License does not include the right to sell products that incorporate       //
;// this IP or any IP derived from this IP. If you would like to obtain such a license, please contact Licensor.       //
;//                                                                                                                    //
;// Licensor can be contacted at:  SYMPL.gpu@gmail.com or Jerry.Harthcock@gmail.com                                    //
;//                                                                                                                    //
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
; A copy of Cross-32 can be purchased from:
; Data-Sync Engineering at: http://www.cdadapter.com/cross32.htm  sales@datasynceng.com
; A copy of the Cross-32 manual can be viewed online here:  
;          http://www.cdadapter.com/download/cross32.pdf
;
; DESCRIPTION
;
;The following program demonstrates usage of the new RISC-V/SCE hybrid instructions.  The exemplary Verilog RTL model of the 
;RISC-V/SCE hybrid Instruction Set Architecture Compute Engine depicted in the first Page of this Preliminary Information sheet
;comprises a RISC-V (RV32I) core gene-spliced to qty. (2) SYMPL Compute Engine cores, SCE(0) and SCE(1), forming a RISC-V/SCE 
;hybrid Compute Engine, with such cores being able execute the same hybrid instructions.
;
;SCE(0) and SCE(1) are identical in all respects, except SCE(1) does not include the SYMPL Fused Universal Neural Network (FuNN)
;operator or the human-readable Pseudo-Random Number Generator that SCE(1) has.  The purpose of SCE(1) being included in the instant
;implementation is to demonstrate the RISC-V hybrid core's ability to push programs and/or data into two or more SCEs, set or clear 
;hardware breakpoints, single-step, launch and multiple SCE cores simultaneously.  The Verilog test bench that is included with the 
;distribution package available for free download at the SYMPL Compute Engine repository here: www.github.com/jerry-D
;begins by first loading the RISC-V hybrid's program memory that the RISC-V executes to orchestrate the processing that the SCEs are 
;to perform.  Next, the test bench loads the RISC-V hybrid's data memory with the program that the SCEs are to execute, followed by the 
;test bench loading the data file that SCE(0) is to process.  While SCE(1) does not include a FuNN operator, this same data file is 
;simultaneously pushed into it as well, mainly for the purpose of demonstrating simultaneous loads by the RISC-V hybrid.
;
;The program that is to be pushed into both SCEs simultaneously the RISC-V hybrid is a simple neural network classification routine
;that SCE(0) executes to classify qty. (16) objects using SCE(0)'s on-board FuNN operator.  SCE(1) executes the same program, 
;but since it has no FuNN operator with which to perform the required operations, SCE(1) will eventually get trapped in a loop that 
;attempts to read a result when there is none.
;
;Once the test bench pushes both the program and the data files into the SCEs, it releases RESET, allowing the RISC-V hybrid core to run 
;its program.  Once those things are accomplished, the test bench will sit and wait for an indication that the RISC-V/SCE hybrid Compute Engine
;has completed processing, at which point the test bench writes formats and writes the results to two files in the Vivado simulation directory
;for that project.  The two file names are �assayPullForm.txt� and �randomNumbers.txt�. 
; 
;The file assayPullForm.txt� is a formatted, human-readable report showing the results of the neural network routine that SCE(0) computed
;using its on-board FuNN operator.  The file �randomNumbers.txt� is an unformatted, is a list of qty. (256) human-readable floating-point 
;pseudo-random floating-point numbers in decimal character sequence format that the RISC-V hybrid pulled directly from SCE(0)'s on-board PRNG.
;RISC-V Launching SCEs.  During RESET active, the SCE's force-break bit is automatically set to active, thus when RESET is released, 
;the force-break in each SCE remains set, forcing each SCE to enter a continuous hardware break state.  The main purpose of this is to allow 
;an opportunity for the RISC-V hybrid to push a program and data into the SCEs, in that upon power-on reset, the SCE program memories have 
;nothing in them for the SCEs to execute.  Once programs and data have been pushed into the SCE's, the RISC-V hybrid then simultaneously 
;clears both SCEs' force-break bit by executing the XCLRBRK hybrid instruction immediately followed by the XSSTEP hybrid instruction. 
; 
;This short sequence clears both SCEs' force-break bits, thereby allowing both SCEs begin executing their own programs now residing in 
;their own program memories.  The XSSTEP instruction following the XCLRBRK instruction is necessary because, while XCLRBRK does clear the SCE's 
;force-break bit, the SCE will remain in a hardware break state until it is explicitly �stepped� out of that state by the RISC-V hybrid using the 
;XSSTEP instruction.
;
;The first part of the SCE neural network classification program initializes various SCE registers, which in this case, is necessary because
;the SCE just came out of RESET state.  Once these few registers have been initialized, the SCEs then encounter a software breakpoint 
;residing at location 0x0000010A in the SCEs' program memory.  The RISC-V hybrid's routine anticipates this and therefor waits for this to 
;happen by polling SCE(0)'s status bits using the XSTATUS hybrid instruction.  
;
;Once the RISC-V hybrid detects that the software breakpoint has been encountered, it then simultaneously modifies both SCE program counters
;to point to the entry point of the SCEs' neural network classification routine, which is location 0x0000010C in SCE program memory.  
;The RISC-V hybrid also simultaneously pushes into both SCEs' Auxillary Register r (AR4), the number of objects SCE(0) is to classify, which, 
;in the case is �16�, in that SCE(0) classification program expects that its AR4 contain the number of objects to classify.
;
;After the RISC-V hybrid simultaneously modifies both SCE's program counter, the SCEs immediately begin executing the neural network 
;classification program using the data that the RISC-V simultaneously pushed into their data memories.  While the SCEs are busy performing 
;the classification routine, the RISC-V is continually polling SCE(0) status bits for a �Done� condition.  When the classification routine 
;is completed by SCE(0), it sets is �Done� bit to signal this fact, at which point the RISC-V detects this and begins pulling results from 
;SCE(0)'s output buffer located within SCE(0)'s data memory and storing it in RISC-V data memory space using the XPULL hybrid instruction.
;
;Finally, after the RISC-V has pulled the results from SCE(0) output buffer, the RISC-V enters a �forever� loop of NOPs, which the test bench detects.


           CPU  "RISC_V_SCE.tbl"
           HOF "BIN32"
           WDLN 1

outbuf:     equ     0x10080    ;SCE classification results output buffer start address
inbuf:      equ     0x12880    ;SCE object/weight vectors input buffer start address
PC:         equ     0x7FF5     ;SYPML Compute Engine (SCE) PC address
AR4:        equ     0x7FFB     ;SCE Auxiliary Register 4 (AR4) address
PRNG:       equ     0x7FF0     ;SCE Psuedo-Random Number Generator address


            org 0x00000000
enter:      DFL     start
prog_len:   DFL     progend 

            org 0x00000200
            
;----------------------------------------------------------------------------------------------------------------
; these 5 instructions tell SCE(0) PRNG to start generating random floating-point numbers less than 2.0 
;----------------------------------------------------------------------------------------------------------------        
start:      mvi     x28, 0x00000001    ;specify to which SCE the following operations concerns
            lui     x29, PRNG          ;point to SCE psuedo-random number generator
            srli    x29, x29, 12       ;shift x29 right by 12 bits to do this immediate address load
            mvi     x30, 37            ;load x30 with code for desired PRNG range of numbers to generate
            XSW                        ;store 37 to PRNG range control register.  
;----------------------------------------------------------------------------------------------------------------
; these 6 instructions push the SCE program into both SCEs simultaneously
;----------------------------------------------------------------------------------------------------------------
            mvi     x28, 0x00000003    ;point to both SCE(0) and SCE(1) cores
            lui     x29, 0x80000       ;point to first location of SCE program memory
            lui     x31, 0x03303       ;load x31 with size and increment amounts for each individual push
            ori     x31, x31, 0x170    ;load REPEAT counter in x31[11:0] with length of SCE program (minus 1)
            mvi     x30, 0x00000000    ;the SCE program resides starting at 0x00000000 in RISC-V data memory     
            XPUSH                      ;push specified program from RISC-V data memory into SCE(0) and (SCE(1)
;----------------------------------------------------------------------------------------------------------------
;these 6 instr push qty. 16 object X and weight vectors (total of 4096 bytes) into SCE(0) and SCE(1) at same time
;----------------------------------------------------------------------------------------------------------------
            lui     x29, inbuf         ;place 20-bit pointer to SCE input buffer in upper 20 bits of x29
            srli    x29, x29, 12       ;shift x29 right by 12 bits to do this immediate address load
            lui     x31, 0x03333       ;load x31 with size and increment amounts for each individual push
            ori     x31, x31, 511      ;load repeat counter (lower 12 bits of x31) with repeat amount (minus 1)
                                       ;at least one instruction must follow load of repeat counter before XPUSH
            lui     x30, 0x00001       ;input data resides beginning at location 0x1000 in RISC-V data memory
            XPUSH                      ;push 4096-byte data block into SCE
;----------------------------------------------------------------------------------------------------------------
;these two instr launch SCE(0) and SCE(1) simultaneously
;----------------------------------------------------------------------------------------------------------------
            XCLRBRK                    ;clear the force hardware breakpoint automatically set on power-up reset
            XSSTEP                     ;step out of the h/w breakpoint and allow SCE to initialize itself
;----------------------------------------------------------------------------------------------------------------
; these 5 instr cause RISC-V to wait for SCE(0) to hit software breakpoint at SCE location 0x0000010A
;----------------------------------------------------------------------------------------------------------------
wait0:      mvi     x28, 0x00000001    ;specify to which SCE the following operations concerns
            XSTATUS                    ;copy specified SCE status bits into x30[7:0]
            andi    x30, x30, 8        ;swbrk status bit is bit x30[3] 
            mvi     x31, 8             ;load x31 with constant 8, ie, set bit x31[3] to "1"
            bne     x30, x31, wait0    ;goto wait0 if x30[3] is not set      
;----------------------------------------------------------------------------------------------------------------
; these 8 instr initialize SCE(0) AR4 and PC prior to launch
;----------------------------------------------------------------------------------------------------------------
            lui     x29, AR4           ;get address of SCE Auxiliary Register 4 
            srli    x29, x29, 12       ;shift it right 12 bits for proper alignment
            mvi     x30, 16            ;load x30 with the number of objects to classify
            XSW                        ;store number objects directly into AR4 of SCE(s) specified by x28

            lui     x29, PC            ;get address of SCE program counter
            srli    x29, x29, 12       ;shift it right 12 bits for proper alignment
            mvi     x30, 0x10C         ;load x30 with the entry point to the routine
            XSW                        ;store entry point directly into PC of SCE(s) specified by x28
            nop                        ;do nothing for a few clocks, giving time for SCE to clear its DONE bit, 
            nop                        ;indicating it is now busy. alternatively, you can manually test the bit
            nop                        ;but in this instance I'm being too lazy to code it
            nop
            nop
;----------------------------------------------------------------------------------------------------------------
;these 4 instr wait for SCE(0) to  hit software breakpoint at location 0x0000010A in program memory
;indicating it has completed the task
;----------------------------------------------------------------------------------------------------------------
wait1:      XSTATUS                    ;copy specified SCE status bits into x30[7:0]
            andi    x30, x30, 32       ;poll swbrk status bit x30[5] 
            mvi     x31, 32            ;load x31 with constant 32, ie, set bit x31[5] to "1"
            bne     x30, x31, wait1    ;goto wait0 if x30[5] is not set, ie, SCE is still busy (ie, not done yet)
;----------------------------------------------------------------------------------------------------------------
;now pull the 4096-byte result out of SCE(0) and store it into RISC-V data memory
;----------------------------------------------------------------------------------------------------------------
            lui     x29, outbuf        ;place 20-bit pointer to SCE output buffer in upper 20 bits of x29
            srli    x29, x29, 12       ;shift x29 right by 12 bits to do this immediate address load
            lui     x31, 0x03333       ;load x31 with size and increment amounts for each individual push
            ori     x31, x31, 1279     ;there are 1280 8-byte words to pull out of SCE output buffer
            lui     x30, 0x02008       ;store result data starting at 0x2008 in RISC-V data memory
            srli    x30, x30, 12
            XPULL                      ;pull 4096-byte result data block from SCE
;----------------------------------------------------------------------------------------------------------------
;these 7 instructions demonstrate how the RISC-V has the ability to borrow any of the SCE's 
;resources, in that any resource of the SCE is also a resource of the hybrid RISC-V
;----------------------------------------------------------------------------------------------------------------
            lui     x29, PRNG          ;load RISC-V x29 with pointer to SCE(0) pseudo-random number generator
            srli    x29, x29, 12       ;shift x29 right by 12 bits to do this immediate address load
            lui     x31, 0x0338B       ;load x31 with size and increment amounts for each individual push 
                                       ;in this case signal "text" for decimal char sequence
            ori     x31, x31, 255      ;256 8-byte decimal character floating point representations please
            lui     x30, 0x04820       ;store generated numbers immediately above classification results
            srli    x30, x30, 12       ;pull the 256 random numbers from SCE(0) PRNG and store them in
            XPULL                      ;RISC-V data RAM starting at location 0x00004820 
                                         
forever:    nop
            nop
            bra forever
            nop
            nop
            nop
progend:            
            end            

        
        