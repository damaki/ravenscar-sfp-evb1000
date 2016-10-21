# Ravenscar-sfp-evb1000

This is a port of the small footprint (SFP) Ravenscar runtime for the STM32F105 Cortex-M3
microcontroller on the [DecaWave EVB1000](http://www.decawave.com/products/evk1000-evaluation-kit) 
evaluation board. The runtime is configured as follows:
  * 12 MHz high-speed external (HSE) oscillator;
  * 72 MHz system clock (SYSCLK);
  * 48 MHz USB OTG clock is enabled.

Note: The PLLs for the I2S clocks are not enabled.

# License

This runtime is licensed under the GNU General Public License version 3.

