# HC-SR04__FPGA

## HC-SR04
HC-SR04 is a distance measurement module. It can emmit the ultrasound wave, and use the <by>
reflection time of ultrasound wave and the velocity of sound in air to calculate <by>
the distance from obstacle.
  
<img src="https://github.com/tim8557/HC-SR04__FPGA/blob/main/images/HC-SR04_photo.jpg" width="200" ><br>
<br>
First, FPGA sends a pulse with a minimum pulse-width of 10 microsecond. When HC-SR04 module receive the trigger<br>
signal from FPGA, it will send out an 8 cycle burst of ultrasound at 40 kHz. We can calculate the distance with <br>
the formula cm = (high level time/2)/29.1 <br>
29.1 (us/cm) = 1/340 (s/m) <br>
The velocity of sound in air is about 340 (m/s) <br>
![image](https://github.com/tim8557/HC-SR04__FPGA/blob/main/images/ultrasound_TTL.JPG)<br>
  
## Time sequence of FPGA
**clk:** the clock frequency of FPGA.<br>
**trigger:** send the signal to start the HC-SR04 module.<br>
**dur:** the echo pulse-width from HC-SR04 module.<br>
**reg1:** inorder to obtain the falling edge of dur.<br>
**reg2:** inorder to obtain the falling edge of dur.<br>
**falling:** the falling become logic 1 when dur transfer from logic 1 into logic 0.<br>
**dur_cnt:** count the duration time of dur.<br>
**dur_data:** it send the duration time of dur when the falling is login 1.<br>
**cm:** calculate the distance from obstacle.<br>

![image](https://github.com/tim8557/HC-SR04__FPGA/blob/main/images/time_sequence_hc_sr04.JPG)<br>
  
## Result 
We measure the distance from HC-SR04 module to obstacle and display <br>
the result on seven-seg display
<img src="https://github.com/tim8557/HC-SR04__FPGA/blob/main/images/HC-SR04_photo.jpg" width="200" ><br>
