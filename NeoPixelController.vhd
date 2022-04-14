-- WS2812 communication interface.
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity NeoPixelController is
 
   port(
       clk_10M          : in   std_logic;
       resetn           : in   std_logic;
       latch            : in   std_logic;
       data             : in   std_logic_vector(15 downto 0);
       sda              : out  std_logic;
       change_24Data    : in   std_logic;
       change_24Addr    : in   std_logic;
       change_16Data    : in   std_logic;
       change_16Addr    : in   std_logic;
       change_all       : in   std_logic;
		 change_wave		: in   std_logic;
		 christmas			: in   std_logic
		 );
 
end entity;
 
architecture internals of NeoPixelController is
 
   -- Signal to store the pixel's color data
   signal led_buffer : std_logic_vector(23 downto 0);

   signal index      : integer;
   type double_array is array (0 to 255) of std_logic_vector(23 downto 0);
   signal all_leds: double_array;
	signal counter_s : integer range 0 to 255 := 0;
	signal counter_r : integer := 0;

 
 
begin
 
   process (clk_10M, resetn, change_24Data, change_24Addr, change_16Data, change_16Addr, change_all, change_wave, christmas)
       -- protocol timing values (in 100s of ns)
       constant t1h : integer := 8;
       constant t1l : integer := 4;
       constant t0h : integer := 3;
       constant t0l : integer := 9;
 
       -- which bit in the 24 bits is being sent
       variable bit_count   : integer range 0 to 23;
       -- counter to count through the bit encoding
       variable enc_count   : integer range 0 to 31;
       -- counter for the reset pulse
       variable reset_count : integer range 0 to 1000;
       -- counter for the LED array
       variable led_count : integer range 0 to 255;
        -- current LED info
        variable led_info : std_logic_vector(23 downto 0);


        variable    led_buff : std_logic_vector(23 downto 0);
        variable    temp : std_logic_vector(23 downto 0);
        variable    color: integer := 1;
        variable    led_buff2 : std_logic_vector(23 downto 0);
     
     
   begin
       if resetn = '0' then
           -- reset all counters
           bit_count := 23;
           enc_count := 0;
           reset_count := 1000; -- Fine to keep at 1000 b/c thats double the 50us minimum 
           led_count := 0;
           led_info := all_leds(0);
			  for i in 0 to 255 loop
                all_leds(i) <= "000000000000000000000000";
           end loop;
           -- set sda inactive
           sda <= '0';
 
       elsif (rising_edge(clk_10M)) then
 
           -- This IF block controls the various counters
           if reset_count > 0 then
               -- during reset period, ensure other counters are reset
               bit_count := 23;
               enc_count := 0;
               led_count := 0;
               led_info := all_leds(0);
               -- decrement the reset count
               reset_count := reset_count - 1;
             
           else -- not in reset period (i.e. currently sending data)
               -- handle reaching end of a bit
               if led_info(bit_count) = '1' then -- current bit is 1
                   if enc_count = (t1h+t1l-1) then -- is end of the bit?
                       enc_count := 0;
                       if bit_count = 0 then -- is end of the LED's data?         
                            if led_count = 255 then -- end of LED array?
                                -- begin the reset period
                                reset_count := 1000;
                            else
                                led_count := led_count + 1;
                                bit_count := 23;
                                led_info := all_leds(led_count);
                            end if;
                       else
                           -- if not end of data, decrement count
                           bit_count := bit_count - 1;
                       end if;
                   else
                       -- within a bit, count to achieve correct pulse widths
                       enc_count := enc_count + 1;
                   end if;
               else -- current bit is 0
                   if enc_count = (t0h+t0l-1) then -- is end of the bit?
                       enc_count := 0;
                       if bit_count = 0 then -- is end of the LED's data?         
                            if led_count = 255 then -- end of LED array?
                                -- begin the reset period
                                reset_count := 1000;
                            else
                                led_count := led_count + 1;
                                bit_count := 23;
                                led_info := all_leds(led_count);
                            end if;
                       else
                           bit_count := bit_count - 1;
                       end if;
                   else
                       -- within a bit, count to achieve correct pulse widths
                       enc_count := enc_count + 1;
                   end if;
               end if;
           end if;
         
           -- This IF block controls sda
           if reset_count > 0 then
               -- sda is 0 during reset/latch
               sda <= '0';
           elsif
               -- sda is 1 if it's the first part of a bit, which depends on if it's 1 or 0
               ( ((led_info(bit_count) = '1') and (enc_count < t1h))
               or
               ((led_info(bit_count) = '0') and (enc_count < t0h)) )
               then sda <= '1';
           else
               sda <= '0';
           end if;
         
       

        if change_24Data = '1' then
            led_buffer(15 downto 0) <= data;
    
        end if;
    
        if change_24Addr = '1' then
            all_leds(to_integer(unsigned(data(7 downto 0)))) <= data(15 downto 8) & led_buffer(15 downto 0);

        end if;

        if change_16Data = '1' then
            led_buffer <= data(10 downto 5) & "00" & data(15 downto 11) & "000" & data(4 downto 0) & "000" ;
        end if;
    
        if (change_16Addr='1') then
            all_leds(to_integer(unsigned(data(7 downto 0)))) <= led_buffer;
        end if;

    

        if change_all = '1' then
            for i in 0 to 255 loop
                all_leds(i) <= data(10 downto 5) & "00" & data(15 downto 11) & "000" & data(4 downto 0) & "000";
            end loop;

        end if;
		  
		  if change_wave = '1' then
				if (counter_s = 255) then
					counter_s <= 0;
					counter_r <= 0;
				else 
					if (counter_r = 0) then
						all_leds(counter_s) <= "000000001111111100000000";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 1) then
						all_leds(counter_s) <= "010101111111111100000000";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 2) then
						all_leds(counter_s) <= "111111111010101100000000";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 3) then
						all_leds(counter_s) <= "111111110000000000000000";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 4) then
						all_leds(counter_s) <= "111111110000000010101011";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 5) then
						all_leds(counter_s) <= "101010110000000011111111";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 6) then
						all_leds(counter_s) <= "000000000000000011111111";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 7) then
						all_leds(counter_s) <= "000000001010101111111111";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 8) then
						all_leds(counter_s) <= "000000001111111110101011";
						counter_s <= counter_s + 1;
						counter_r <= counter_r + 1;
					elsif (counter_r = 9) then
						counter_r <= 0;
					end if;
			end if;
		end if;

		  
		  
		  if christmas = '1' then
				for i in 0 to 255 loop
					if i mod 2 = 0 then
						all_leds(i) <= "111111110000000000000000";
					else
						all_leds(i) <= "000000001111111100000000";
					end if;
				end loop;
			end if;
			
		  
			
			
    end if;
 
    end process;    
 
end internals;
 
 
 
 




