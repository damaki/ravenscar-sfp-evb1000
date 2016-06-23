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

pragma Ada_2012; -- To work around pre-commit check?
pragma Restrictions (No_Elaboration_Code);
pragma Suppress (All_Checks);

--  This initialization procedure mainly initializes the PLLs and
--  all derived clocks.

with Interfaces.Bit_Types;     use Interfaces, Interfaces.Bit_Types;
with Interfaces.STM32.FLASH;   use Interfaces.STM32.FLASH;
with Interfaces.STM32.PWR;     use Interfaces.STM32.PWR;
with Interfaces.STM32.RCC;     use Interfaces.STM32.RCC;
with Interfaces.STM32.GPIO;    use Interfaces.STM32.GPIO;

with System.BB.Parameters;     use System.BB.Parameters;
with System.STM32;             use System.STM32;

procedure Setup_Pll is

   procedure Initialize_Clocks;
   procedure Reset_Clocks;

   ------------------------------
   -- Clock Tree Configuration --
   ------------------------------

   HSE_Enabled     : constant Boolean := True;  -- use high-speed ext. clock
   HSE_Bypass      : constant Boolean := False; -- don't bypass ext. resonator
   LSI_Enabled     : constant Boolean := False; -- no low-speed int. clock

   Activate_PLL       : constant Boolean := True;
   Activate_PLLI2S    : constant Boolean := False;

   pragma Assert (not Activate_PLLI2S, "not yet implemented");

   -----------------------
   -- Initialize_Clocks --
   -----------------------

   procedure Initialize_Clocks
   is
      PREDIV1  : constant PREDIV1_Range := 1;
      --  Fixed to an arbitrary convenient value

      PLLMUL   : constant Integer :=
                   (if not Activate_PLL
                    then 4
                    else (if HSE_Enabled
                      then Clock_Frequency / (HSE_Clock / PREDIV1)
                      else Clock_Frequency / (HSI_Clock / 2)));

      PLLCLK   : constant Integer :=
                         (if HSE_Enabled
                          then (HSE_Clock / PREDIV1) * PLLMUL
                          else (HSI_Clock / 2) * PLLMUL);

      SYSCLK   : constant Integer := (if Activate_PLL
                                      then PLLCLK
                                      else (if HSE_Enabled
                                        then HSE_Clock
                                        else HSI_Clock));

      SYSCLK_SRC : constant SYSCLK_Source :=
                     (if Activate_PLL then SYSCLK_SRC_PLL
                      elsif HSE_Enabled then SYSCLK_SRC_HSE
                      else SYSCLK_SRC_HSI);

      HCLK        : constant Integer :=
                      (if not AHB_PRE.Enabled
                       then SYSCLK
                       else
                         (case AHB_PRE.Value is
                             when DIV2   => SYSCLK / 2,
                             when DIV4   => SYSCLK / 4,
                             when DIV8   => SYSCLK / 8,
                             when DIV16  => SYSCLK / 16,
                             when DIV64  => SYSCLK / 64,
                             when DIV128 => SYSCLK / 128,
                             when DIV256 => SYSCLK / 256,
                             when DIV512 => SYSCLK / 512));

      PCLK1       : constant Integer :=
                      (if not APB1_PRE.Enabled
                       then HCLK
                       else
                         (case APB1_PRE.Value is
                             when DIV2  => HCLK / 2,
                             when DIV4  => HCLK / 4,
                             when DIV8  => HCLK / 8,
                             when DIV16 => HCLK / 16));

      PCLK2       : constant Integer :=
                      (if not APB2_PRE.Enabled
                       then HCLK
                       else
                         (case APB2_PRE.Value is
                             when DIV2  => HCLK / 2,
                             when DIV4  => HCLK / 4,
                             when DIV8  => HCLK / 8,
                             when DIV16 => HCLK / 16));

      function To_HPRE (Value : AHB_Prescaler) return UInt4
      is (if not Value.Enabled
          then 2#0000#
          else (case Value.Value is
                   when DIV2   => 2#1000#,
                   when DIV4   => 2#1001#,
                   when DIV8   => 2#1010#,
                   when DIV16  => 2#1011#,
                   when DIV64  => 2#1100#,
                   when DIV128 => 2#1101#,
                   when DIV256 => 2#1110#,
                   when DIV512 => 2#1111#));

      function To_ADCPRE (Value : ADC_Prescaler) return UInt2
      is (UInt2 (ADC_Prescaler'Pos (Value)));

      function To_PPRE (Value : APB_Prescaler) return UInt6
      is (if not Value.Enabled
          then 2#000#
          else (case Value.Value is
                   when DIV2  => 2#100#,
                   when DIV4  => 2#101#,
                   when DIV8  => 2#110#,
                   when DIV16 => 2#111#));

      function To_PLLMUL (Value : PLLMUL_Range) return UInt4
      is (case Value is
             when 4 => 2#0010#,
             when 5 => 2#0011#,
             when 6 => 2#0100#,
             when 7 => 2#0101#,
             when 8 => 2#0110#,
             when 9 => 2#0111#);

      function To_OTGFSPRE (Value : USB_Prescaler) return Bit
      is (Bit (USB_Prescaler'Pos (Value)));

      function To_PREDIV1 (Value : PREDIV1_Range) return UInt4
      is (UInt4 (Value - 1));

   begin

      --  Check configuration
      pragma Warnings (Off, "condition is always False");
      if PLLMUL not in PLLMUL_Range then
         raise Program_Error with "Invalid clock configuration";
      end if;

      if SYSCLK /= Clock_Frequency then
         raise Program_Error with "Cannot generate requested clock";
      end if;

      if HCLK not in HCLK_Range
        or else
         PCLK1 not in PCLK1_Range
        or else
         PCLK2 not in PCLK2_Range
      then
         raise Program_Error with "Invalid AHB/APB prescalers configuration";
      end if;
      pragma Warnings (On, "condition is always False");

      if not HSE_Enabled then
         --  Enable HSI clock and wait for stabilization
         RCC_Periph.CR.HSION := 1;

         loop
            exit when RCC_Periph.CR.HSIRDY = 1;
         end loop;

      else
         --  Enable HSE clock and wait for stabilization
         RCC_Periph.CR.HSEON  := 1;
         RCC_Periph.CR.HSEBYP := (if HSE_Bypass then 1 else 0);

         loop
            exit when RCC_Periph.CR.HSERDY = 1;
         end loop;

      end if;

      --  Configure flash
      --  Must be done before increasing the frequency, otherwise the CPU
      --  won't be able to fetch new instructions.

      FLASH_Periph.ACR.PRFTBE  := 1;
      FLASH_Periph.ACR.LATENCY := 2#010#;
      --  Two wait states (48 MHz < SYSCLK <= 72 MHz)

      --  Configure derived clocks

      RCC_Periph.CFGR.HPRE     := To_HPRE (AHB_PRE);
      RCC_Periph.CFGR.PPRE     := CFGR_PPRE_Field'
        (As_Array => False,
         Val      => To_PPRE (APB1_PRE) or (To_PPRE (APB2_PRE) * 2**3));
      RCC_Periph.CFGR.ADCPRE   := To_ADCPRE (ADC_PRE);
      RCC_Periph.CFGR.OTGFSPRE := To_OTGFSPRE (USB_PRE);

      --  Configure low-speed internal clock if enabled

      if LSI_Enabled then
         RCC_Periph.CSR.LSION := 1;

         loop
            exit when RCC_Periph.CSR.LSIRDY = 1;
         end loop;
      end if;

      --  Activate PLL if enabled
      if Activate_PLL then
         --  Disable the main PLL before configuring it (if enabled)
         RCC_Periph.CR.PLLON := 0;

         RCC_Periph.CFGR2.PREDIV1SRC := 0;
         RCC_Periph.CFGR2.PREDIV     :=
           CFGR2_PREDIV_Field'
             (As_Array => False,
              Val      => Byte (To_PREDIV1 (PREDIV1)));

         RCC_Periph.CFGR.PLLMUL   := To_PLLMUL (PLLMUL);
         RCC_Periph.CFGR.PLLSRC   := (if HSE_Enabled then 1 else 0);

         RCC_Periph.CR.PLLON := 1;

         loop
            exit when RCC_Periph.CR.PLLRDY = 1;
         end loop;
      end if;

      --  Switch clock source

      RCC_Periph.CFGR.SW := UInt2 (SYSCLK_Source'Pos (SYSCLK_SRC));

      loop
         exit when RCC_Periph.CFGR.SWS =
           UInt2 (SYSCLK_Source'Pos (SYSCLK_SRC));
      end loop;

   end Initialize_Clocks;

   ------------------
   -- Reset_Clocks --
   ------------------

   procedure Reset_Clocks is
   begin
      --  Switch on high speed internal clock
      RCC_Periph.CR.HSION := 1;

      --  Reset CFGR regiser
      RCC_Periph.CFGR  := (others => <>);
      RCC_Periph.CFGR2 := (others => <>);

      --  Reset HSEON, CSSON and PLLON bits
      RCC_Periph.CR.HSEON := 0;
      RCC_Periph.CR.CSSON := 0;
      RCC_Periph.CR.PLLON := 0;

      --  Reset HSE bypass bit
      RCC_Periph.CR.HSEBYP := 0;

      --  Disable all interrupts
      RCC_Periph.CIR := (others => <>);
   end Reset_Clocks;

begin
   Reset_Clocks;
   Initialize_Clocks;
end Setup_Pll;
