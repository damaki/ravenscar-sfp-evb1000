------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--          Copyright (C) 2012-2016, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  This file provides register definitions for the STM32F10xx (ARM Cortex M3)
--  microcontrollers from ST Microelectronics.

pragma Restrictions (No_Elaboration_Code);

with Interfaces.Bit_Types;

package System.STM32 is
   pragma Preelaborate (System.STM32);

   subtype Frequency is Interfaces.Bit_Types.Word;

   type RCC_System_Clocks is record
      SYSCLK  : Frequency;
      HCLK    : Frequency;
      PCLK1   : Frequency;
      PCLK2   : Frequency;
      TIMCLK1 : Frequency;
      TIMCLK2 : Frequency;
   end record;

   function System_Clocks return RCC_System_Clocks;

   --  CRL/CRH constants (MODEy subfields)
   subtype GPIO_MODE_Values is Interfaces.Bit_Types.UInt2;
   Mode_IN        : constant GPIO_MODE_Values := 0;
   Mode_OUT_10MHz : constant GPIO_MODE_Values := 1;
   Mode_OUT_2MHz  : constant GPIO_MODE_Values := 2;
   Mode_OUT_50MHz : constant GPIO_MODE_Values := 3;

   --  CRL/CRH constants (CNFy subfields)
   subtype GPIO_CNF_Values is Interfaces.Bit_Types.UInt2;
   --  When operating in input mode
   Input_Analog           : constant GPIO_CNF_Values := 0;
   Input_Floating         : constant GPIO_CNF_Values := 1;
   Input_PuPd             : constant GPIO_CNF_Values := 2;
   --  When operating in output mode
   GPIO_Output_Push_Pull  : constant GPIO_CNF_Values := 0;
   GPIO_Output_Open_Drain : constant GPIO_CNF_Values := 1;
   GPIO_AF_Push_Pull      : constant GPIO_CNF_Values := 2;
   GPIO_AF_Open_Drain     : constant GPIO_CNF_Values := 3;

   --  ODR constants (when operating in input mode)
   subtype GPIO_ODR_Values is Interfaces.Bit_Types.Bit;
   Pull_Down : constant GPIO_ODR_Values := 0;
   Pull_Up   : constant GPIO_ODR_Values := 1;

   --  RCC constants

   type PLL_Source is
     (PLL_SRC_HSI,
      PLL_SRC_HSE)
     with Size => 1;

   type SYSCLK_Source is
     (SYSCLK_SRC_HSI,
      SYSCLK_SRC_HSE,
      SYSCLK_SRC_PLL)
     with Size => 2;

   type AHB_Prescaler_Enum is
     (DIV2,  DIV4,   DIV8,   DIV16,
      DIV64, DIV128, DIV256, DIV512)
     with Size => 3;

   type AHB_Prescaler is record
      Enabled : Boolean := False;
      Value   : AHB_Prescaler_Enum := AHB_Prescaler_Enum'First;
   end record with Size => 4;

   for AHB_Prescaler use record
      Enabled at 0 range 3 .. 3;
      Value   at 0 range 0 .. 2;
   end record;

   AHBPRE_DIV1 : constant AHB_Prescaler := (Enabled => False, Value => DIV2);

   type APB_Prescaler_Enum is
     (DIV2, DIV4, DIV8, DIV16)
     with Size => 2;

   type APB_Prescaler is record
      Enabled : Boolean;
      Value   : APB_Prescaler_Enum;
   end record with Size => 3;

   for APB_Prescaler use record
      Enabled at 0 range 2 .. 2;
      Value   at 0 range 0 .. 1;
   end record;

   type ADC_Prescaler is
     (DIV2, DIV4, DIV6, DIV8)
     with Size => 2;

   type USB_Prescaler is
     (DIV3, DIV2)
     with Size => 1;

   --  Constants for RCC CR register

   subtype PREDIV1_Range is Integer range           1 ..          16;
   subtype PLLMUL_Range  is Integer range           4 ..           9;
   subtype HSECLK_Range  is Integer range   3_000_000 ..  25_000_000;
   subtype PLLOUT_Range  is Integer range           1 ..  72_000_000;
   subtype SYSCLK_Range  is Integer range           1 ..  72_000_000;
   subtype HCLK_Range    is Integer range           1 ..  72_000_000;
   subtype PCLK1_Range   is Integer range           1 ..  36_000_000;
   subtype PCLK2_Range   is Integer range           1 ..  72_000_000;

   --  These internal low and high speed clocks are fixed (do not modify)

   HSICLK : constant := 8_000_000;
   LSICLK : constant :=    40_000;

end System.STM32;
