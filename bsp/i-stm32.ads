--
--  Copyright (C) 2016, AdaCore
--

--  This spec has been automatically generated from STM32F105xx.svd

pragma Ada_2012;

with System;

--  STM32F105xx
package Interfaces.STM32 is
   pragma Preelaborate;
   pragma No_Elaboration_Code_All;

   --------------------
   -- Base addresses --
   --------------------

   PWR_Base : constant System.Address :=
     System'To_Address (16#40007000#);
   GPIOA_Base : constant System.Address :=
     System'To_Address (16#40010800#);
   GPIOB_Base : constant System.Address :=
     System'To_Address (16#40010C00#);
   GPIOC_Base : constant System.Address :=
     System'To_Address (16#40011000#);
   GPIOD_Base : constant System.Address :=
     System'To_Address (16#40011400#);
   GPIOE_Base : constant System.Address :=
     System'To_Address (16#40011800#);
   AFIO_Base : constant System.Address :=
     System'To_Address (16#40010000#);
   EXTI_Base : constant System.Address :=
     System'To_Address (16#40010400#);
   DMA1_Base : constant System.Address :=
     System'To_Address (16#40020000#);
   DMA2_Base : constant System.Address :=
     System'To_Address (16#40020400#);
   RTC_Base : constant System.Address :=
     System'To_Address (16#40002800#);
   BKP_Base : constant System.Address :=
     System'To_Address (16#40006C04#);
   IWDG_Base : constant System.Address :=
     System'To_Address (16#40003000#);
   WWDG_Base : constant System.Address :=
     System'To_Address (16#40002C00#);
   TIM1_Base : constant System.Address :=
     System'To_Address (16#40012C00#);
   TIM2_Base : constant System.Address :=
     System'To_Address (16#40000000#);
   TIM3_Base : constant System.Address :=
     System'To_Address (16#40000400#);
   TIM4_Base : constant System.Address :=
     System'To_Address (16#40000800#);
   TIM5_Base : constant System.Address :=
     System'To_Address (16#40000C00#);
   TIM6_Base : constant System.Address :=
     System'To_Address (16#40001000#);
   TIM7_Base : constant System.Address :=
     System'To_Address (16#40001400#);
   I2C1_Base : constant System.Address :=
     System'To_Address (16#40005400#);
   I2C2_Base : constant System.Address :=
     System'To_Address (16#40005800#);
   SPI1_Base : constant System.Address :=
     System'To_Address (16#40013000#);
   SPI2_Base : constant System.Address :=
     System'To_Address (16#40003800#);
   SPI3_Base : constant System.Address :=
     System'To_Address (16#40003C00#);
   USART1_Base : constant System.Address :=
     System'To_Address (16#40013800#);
   USART2_Base : constant System.Address :=
     System'To_Address (16#40004400#);
   USART3_Base : constant System.Address :=
     System'To_Address (16#40004800#);
   ADC1_Base : constant System.Address :=
     System'To_Address (16#40012400#);
   ADC2_Base : constant System.Address :=
     System'To_Address (16#40012800#);
   CAN2_Base : constant System.Address :=
     System'To_Address (16#40006800#);
   CAN1_Base : constant System.Address :=
     System'To_Address (16#40006400#);
   USB_OTG_GLOBAL_Base : constant System.Address :=
     System'To_Address (16#50000000#);
   USB_OTG_HOST_Base : constant System.Address :=
     System'To_Address (16#50000400#);
   USB_OTG_DEVICE_Base : constant System.Address :=
     System'To_Address (16#50000800#);
   USB_OTG_PWRCLK_Base : constant System.Address :=
     System'To_Address (16#50000E00#);
   DAC_Base : constant System.Address :=
     System'To_Address (16#40007400#);
   DBG_Base : constant System.Address :=
     System'To_Address (16#E0042000#);
   UART4_Base : constant System.Address :=
     System'To_Address (16#40004C00#);
   UART5_Base : constant System.Address :=
     System'To_Address (16#40005000#);
   CRC_Base : constant System.Address :=
     System'To_Address (16#40023000#);
   FLASH_Base : constant System.Address :=
     System'To_Address (16#40022000#);
   RCC_Base : constant System.Address :=
     System'To_Address (16#40021000#);
   NVIC_Base : constant System.Address :=
     System'To_Address (16#E000E000#);

end Interfaces.STM32;
