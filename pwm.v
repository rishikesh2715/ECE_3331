//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2024 09:23:33 PM
// Design Name: 
// Module Name: pwm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//`timescale 1ns / 1ps

//module PWMGeneratorWithLED(
//    input CLK100MHZ,      // onboard 100MHz clock
//    input sw0,            // switch 0 input
//    output reg pwm_out = 0, // PWM output signal
//    output reg led_feedback = 0, // LED that lights up when SW0 is on
//    output reg blink_led = 0    // Slow blinking LED for clock verification
//    );
    
//    // Parameters for PWM and blinking LED
//    parameter PWM_PERIOD = 20_000; // PWM period - 5kHz
//    parameter BLINK_PERIOD = 50_000_000; // Blink period (about 1 second)
//    parameter DUTY_CYCLE = 25; // Duty cycle percentage
    
//    // Internal registers for PWM generation and LED blinking
//    reg [15:0] pwm_counter = 0; // Counter for PWM period
//    reg [25:0] blink_counter = 0; // Counter for blink period
    
//    // Calculate the threshold for the duty cycle
//    wire [15:0] pwm_threshold = (PWM_PERIOD * DUTY_CYCLE) / 100;
    
//    // PWM signal generation logic
//    always @(posedge CLK100MHZ) begin
//        if (sw0) begin 
//            // When switch is on, generate PWM signal
//            pwm_counter <= (pwm_counter >= PWM_PERIOD - 1) ? 0 : pwm_counter + 1;
//            pwm_out <= (pwm_counter < pwm_threshold) ? 1 : 0;
//            led_feedback <= 1; // Turn on feedback LED immediately when SW0 is on
//        end
//        else begin
//            pwm_out <= 0; // Turn off PWM output if switch is off
//            pwm_counter <= 0;
//            led_feedback <= 0; // Turn off feedback LED immediately when SW0 is off
//        end
//    end
    
//    // Blinking LED logic
//    always @(posedge CLK100MHZ) begin
//        blink_counter <= (blink_counter >= BLINK_PERIOD - 1) ? 0 : blink_counter + 1;
//        // Toggle the blink_led state for every BLINK_PERIOD cycles to achieve blinking
//        if(blink_counter == 0) begin
//            blink_led <= ~blink_led;
//        end
//    end
//endmodule



`timescale 1ns / 1ps

module MotorControlModule(
    input CLK100MHZ,             // Onboard 100MHz clock
    input sw0, sw1, sw2, sw3, sw4, sw5, // Switch inputs
    output reg pwm_out1 = 0,     // PWM output signal for motor 1
    output reg pwm_out2 = 0,     // PWM output signal for motor 2
    output motor1_dirA,          // Motor 1 direction pin A
    output motor1_dirB,          // Motor 1 direction pin B
    output motor2_dirA,          // Motor 2 direction pin A
    output motor2_dirB,          // Motor 2 direction pin B
    // Individual feedback LEDs for each switch
    output led_feedback_sw0,
    output led_feedback_sw1,
//    output led_feedback_sw2,
    output led_feedback_sw3,
    output led_feedback_sw4,
    output led_feedback_sw5,
    output reg blink_led         // Heartbeat LED
);

    // Parameters for PWM and Blinking LED
    parameter PWM_PERIOD = 20_000; // PWM period - 5kHz
    parameter BLINK_PERIOD = 100_000_000; // Blink period - about 1 second
    parameter DUTY_CYCLE = 25; // Duty cycle percentage

    // Internal registers for PWM generation and LED blinking
    reg [15:0] counter1 = 0; // Counter for PWM period of PWM1
    reg [15:0] counter2 = 0; // Counter for PWM period of PWM2
    reg [31:0] blink_counter = 0; // Counter for blink LED

    // Map switches to LEDs and direction control
    // Map switches directly to feedback LEDs
    assign led_feedback_sw0 = sw0;
    assign led_feedback_sw1 = sw1;
//    assign led_feedback_sw2 = sw2;
    assign led_feedback_sw3 = sw3;
    assign led_feedback_sw4 = sw4;
    assign led_feedback_sw5 = sw5;
    
    assign motor1_dirA = sw2;
    assign motor1_dirB = sw3;
    assign motor2_dirA = sw4;
    assign motor2_dirB = sw5;
    
    // PWM Generation logic for PWM1
    always @(posedge CLK100MHZ) begin
        if (sw0) begin
            counter1 <= (counter1 >= PWM_PERIOD - 1) ? 0 : counter1 + 1;
            pwm_out1 <= (counter1 < (PWM_PERIOD * DUTY_CYCLE) / 100) ? 1 : 0;
        end
        else begin
            pwm_out1 <= 0;
            counter1 <= 0;
        end
    end
    
    // PWM Generation logic for PWM2
    always @(posedge CLK100MHZ) begin
        if (sw1) begin
            counter2 <= (counter2 >= PWM_PERIOD - 1) ? 0 : counter2 + 1;
            pwm_out2 <= (counter2 < (PWM_PERIOD * DUTY_CYCLE) / 100) ? 1 : 0;
        end
        else begin
            pwm_out2 <= 0;
            counter2 <= 0;
        end
    end

    // Blinking LED logic
    always @(posedge CLK100MHZ) begin
        blink_counter <= (blink_counter >= BLINK_PERIOD - 1) ? 0 : blink_counter + 1;
        // Toggle the blink_led state for every BLINK_PERIOD cycles to achieve blinking
        if(blink_counter == 0) begin
            blink_led <= ~blink_led;
        end
    end
    
endmodule