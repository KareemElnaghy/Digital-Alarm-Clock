`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 04:12:43 PM
// Design Name: 
// Module Name: digitalClock
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


module digitalClock(input clk, rst,left, right, up, down, center,startAlarm, output [6:0] segments,output [3:0] anode_active, output reg decimalPt,output reg LD0,buzzer, output LD12, LD13, LD14,LD15);
wire [15:0] countTime, countAlarm;
wire [7:0] countSeconds;
wire [1:0] s;
wire[3:0] muxOut1,muxOut2;
wire clk_200, clk_1,clk_buzzer_3;
wire[4:0] buttonsPressed;
reg [15:0] clockDigits, alarmDigits;
reg enableClock;
reg [1:0] enableMins_Hours;        // 2 bit enable where MSB represents whether we are pressing the increment or decrement button and LSB represents hours if 0 and minutes if 1
reg upDown;
reg clockInput;
reg adjustAlarm;

// Clock Dividers to generate the three needed frequencies
clockDivider #(250000)div1(clk, rst, clk_200);
clockDivider #(50000000)div2(clk, rst, clk_1);
clockDivider #(15000000)div3(clk, rst, clk_buzzer_3);

//push button detectors
pushButtonDetector BTNC(clk_200,rst,center,buttonsPressed[4]);
pushButtonDetector BTNL(clk_200,rst,left,buttonsPressed[3]);
pushButtonDetector BTNR(clk_200,rst,right,buttonsPressed[2]);
pushButtonDetector BTNU(clk_200,rst,up,buttonsPressed[1]);
pushButtonDetector BTND(clk_200,rst,down,buttonsPressed[0]);

//Two Counters one for the clock time and one for the alarm time    
minSecHourCount mainClock( .clk(clockInput), .rst(rst), .en(enableClock),.adjustAlarm(adjustAlarm),.enableMins_Hours(enableMins_Hours),.upDown(upDown), .displayDigits(countTime), .secondDigits(countSeconds));
alarmHourMinCounter alarm( .clk(clockInput), .rst(rst), .en(adjustAlarm),.enableMins_Hours(enableMins_Hours),.upDown(upDown), .displayDigits(countAlarm));

//FSM with 6 states, the default clock mode, alarm mode, adjusting the hours and minutes of the clock, and adjusting the alarm hour and minutes
reg [2:0] state, nextState;
parameter [2:0] clock=3'b000, timeHours=3'b001, timeMins=3'b010, alarmHours=3'b011, alarmMins=3'b100, triggerAlarm = 3'b101; // States Encoding 
always @ (buttonsPressed or state)           
case (state)                                     
clock: if (buttonsPressed == 5'b10000)
    begin
         nextState = timeHours;
         enableClock = 0;
         enableMins_Hours = 2'b00;
         upDown = 1;
         clockInput = clk_200;
    end
    
else if((countTime == countAlarm) & (startAlarm) & (countSeconds == 8'b0))
    begin
        nextState = triggerAlarm;
        enableClock = 1;
        enableMins_Hours = 2'b00;
        upDown = 1;
        adjustAlarm = 0;
        clockInput = clk_1;
    end
 else  
    begin 
        nextState = clock;
        enableClock = 1;
        enableMins_Hours = 2'b00;
        upDown = 1;
        adjustAlarm = 0;
        clockInput = clk_1;
    end
    
timeHours: if(buttonsPressed == 5'b00100) 
    begin
        nextState = alarmMins;
        enableClock = 0;
        enableMins_Hours = 2'b00;
        upDown = 1;
        clockInput = clk_200;
        adjustAlarm = 1;
    end
else if(buttonsPressed == 5'b01000)
     begin   
        nextState = timeMins;   
        enableClock = 0;
        enableMins_Hours = 2'b00;
        upDown = 0;
        clockInput = clk_200; 
        adjustAlarm = 0;
      end   
else if(buttonsPressed == 5'b10000)
    begin
         nextState = clock;
         enableClock = 1;
         enableMins_Hours = 2'b00;
         upDown = 1'bX;
         clockInput = clk_1;
         adjustAlarm = 0;
    end
 
else if (buttonsPressed == 5'b00010) 
    begin
         nextState = timeHours;
         enableClock = 0;
         enableMins_Hours = 2'b10;
         upDown = 1;
         clockInput = clk_200;
         adjustAlarm =0;
    end

else if (buttonsPressed == 5'b00001) 
    begin
         nextState = timeHours;
         enableClock = 0;
         enableMins_Hours = 2'b10;
         upDown = 0;
         clockInput = clk_200; 
         adjustAlarm = 0;
    end
else
    begin
        nextState = timeHours;
        enableClock =0;
        enableMins_Hours = 2'b00;
        upDown = 1;
        clockInput = clk_200;
        adjustAlarm = 0;
    end


timeMins: if(buttonsPressed == 5'b00100) 
    begin
        nextState = timeHours;
        enableClock = 0;
        upDown = 0;
        clockInput = clk_200;
        adjustAlarm = 0;
    end
else if(buttonsPressed == 5'b01000)
     begin   
        nextState = alarmHours;    
        enableClock = 0;
        enableMins_Hours = 2'b00;
        upDown = 0;
        clockInput = clk_200; 
        adjustAlarm = 1;

      end   
else if(buttonsPressed == 5'b10000)
    begin
         nextState = clock;
         enableClock = 1;
         enableMins_Hours = 2'b00;
         upDown = 0;
         clockInput = clk_1;
         adjustAlarm = 0;
    end
 
else if (buttonsPressed == 5'b00010) 
    begin
         nextState = timeMins;
         enableClock = 0;
         enableMins_Hours = 2'b11;
         upDown = 1;
         clockInput = clk_200;
         adjustAlarm = 0;
    end

else if (buttonsPressed == 5'b00001) 
    begin
         nextState = timeMins;
         enableClock = 0;
         enableMins_Hours = 2'b11;
         upDown = 0;
         clockInput = clk_200;
         adjustAlarm = 0;
    end
else
    begin
        nextState = timeMins;
        enableClock =0;
        enableMins_Hours = 2'b00;
        upDown = 1;
        clockInput = clk_200;
        adjustAlarm = 0;
    end

alarmHours: if(buttonsPressed == 5'b00100) 
    begin
        nextState = timeMins;
        enableClock = 0;
        upDown = 1'b1;
        clockInput = clk_200;
        adjustAlarm = 0;
    end
else if(buttonsPressed == 5'b01000)
     begin   
        nextState = alarmMins;    
        enableClock = 0;
        enableMins_Hours = 2'b01;
        adjustAlarm = 1;
        upDown = 0;
        clockInput = clk_200; 
      end   
else if(buttonsPressed == 5'b10000)
    begin
         nextState = clock;
         enableClock = 1;
         enableMins_Hours = 2'b00;
         upDown = 1;
         clockInput = clk_1;
         adjustAlarm = 0;
    end
 
else if (buttonsPressed == 5'b00010) 
    begin
         nextState = alarmHours;
         enableClock = 0;
         enableMins_Hours = 2'b10;
         upDown = 1;
         clockInput = clk_200;
         adjustAlarm = 1;
    end

else if (buttonsPressed == 5'b00001) 
    begin
         nextState = alarmHours;
         enableClock = 0;
         enableMins_Hours = 2'b10;
         upDown = 0;
         clockInput = clk_200;
         adjustAlarm = 1;
    end
else
    begin
        nextState = alarmHours;
        enableClock =0;
        enableMins_Hours = 2'b00;
        upDown = 1;
        clockInput = clk_200;
        adjustAlarm = 1;
    end

alarmMins: if(buttonsPressed == 5'b00100) 
    begin
        nextState = alarmHours;
        enableClock = 0;
        upDown = 1'b1;
        clockInput = clk_200;
        adjustAlarm = 1;
    end
else if(buttonsPressed == 5'b01000)
     begin   
        nextState = timeHours;   
        enableClock = 0;
        enableMins_Hours = 2'b00;
        adjustAlarm = 0;
        upDown = 0;
        clockInput = clk_200; 
      end   
else if(buttonsPressed == 5'b10000)
    begin
         nextState = clock;
         enableClock = 1;
         enableMins_Hours = 2'b00;
         upDown = 1;
         clockInput = clk_1;
         adjustAlarm = 0;
    end
 
else if (buttonsPressed == 5'b00010) 
    begin
         nextState = alarmMins;
         enableClock = 0;
         enableMins_Hours = 2'b11;
         upDown = 1;
         clockInput = clk_200;
         adjustAlarm = 1;
    end

else if (buttonsPressed == 5'b00001) 
    begin
         nextState = alarmMins;
         enableClock = 0;
         enableMins_Hours = 2'b11;
         upDown = 0;
         clockInput = clk_200;
         adjustAlarm = 1;
    end
else
    begin
        nextState = alarmMins;
        enableClock =0;
        enableMins_Hours = 2'b00;
        upDown = 1;
        clockInput = clk_200;
        adjustAlarm = 1;
    end

triggerAlarm: if(buttonsPressed == 5'b10000 |buttonsPressed == 5'b01000 |buttonsPressed == 5'b00100 |buttonsPressed == 5'b00010 |buttonsPressed == 5'b00001 ) 
    begin
         nextState = clock;
         enableClock = 1;
         enableMins_Hours = 2'b00;
         upDown = 1;
         clockInput = clk_1;
         adjustAlarm = 0;
    end
else
    begin
         nextState = triggerAlarm;
         enableClock = 1;
         enableMins_Hours = 2'b00;
         upDown = 1;
         clockInput = clk_1;
         adjustAlarm = 0;
    end
  
default: nextState = clock;
endcase

    
always @ (posedge clk_200 or posedge rst) begin
if(rst) state <= clock;
else state <= nextState;
end
//assignment of LEDS
assign LD12 = (state == timeHours) ? 1:0;
assign LD13 = (state == timeMins) ? 1:0;
assign LD14 = (state == alarmHours) ? 1:0;
assign LD15 = (state == alarmMins) ? 1:0;

//Logic behind LD0 which has multiple cases
always @ (*) begin
    if(state == clock) begin
        LD0 = 0;
        buzzer = 0;
        end
    else if (state == triggerAlarm) begin
        LD0 = (~clk_1);
        buzzer = (~clk_buzzer_3);
    end
    else begin
        LD0 = 1;
        buzzer = 0;
    end                                  
end


//Display Section
 
counter_x_bit #(2,4) select(.clk(clk_200), .reset(0),.en(1), .count(s));        //2-bit counter acts as selection line for mux and used for deciding which anode is active
mux4x1 Mux1(.data_in_0(countAlarm[15:12]),.data_in_1(countAlarm[11:8]),.data_in_2(countAlarm[7:4]),.data_in_3(countAlarm[3:0]),.sel(s), .data_out(muxOut1));    //4x1 Mux for Alarm Digits
mux4x1 Mux2(.data_in_0(countTime[15:12]),.data_in_1(countTime[11:8]),.data_in_2(countTime[7:4]),.data_in_3(countTime[3:0]),.sel(s), .data_out(muxOut2));    //4x1 Mux of clock digits

//2x1 Mux to select between displaying Alarm Time or Clock
reg [3:0] value;
always @(*)begin
if(adjustAlarm) value = muxOut1;
else value = muxOut2;
end

    SevenSegDecWithEn seg(.en(s),.in(value),.segments(segments), .anode_active(anode_active));  // Module which outputs the segments to activate on the 7 segment display and which anode to activate 

    always @ (*) begin    // Blinking Decimal Point in Clock mode
    if((anode_active == 4'b1011) & enableClock) decimalPt = clk_1;
    else decimalPt = 1;
end


endmodule
