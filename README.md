# Ravenscar-sfp-stm32f105

This is a port of the small footprint (SFP) Ravenscar runtime for the STM32F105
Cortex-M3 microcontroller. The runtime is configured for a 12 MHz high speed
external (HSE) oscillator, and configures the SYSCLK to run at 72 MHz. The 
48 MHz USB OTG clock is also enabled, but the PLLs for the I2S clocks are not
enabled.

# License

This runtime is licensed under the GNU General Public License version 3.

