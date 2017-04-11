library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity predictor is

	 port (
  
     reset: in std_logic;
     clk  : in std_logic;
     taken: in std_logic;
     predicted_outcome: out std_logic
		
      	);

end predictor;

architecture behaviour of predictor is
	TYPE states is (s00,s01,s10,s11);
    signal current_s,next_s: states;
	signal state   : states;

	
	-- 00, 01, 10, 11
    --signal predicted_result : std_logic;
	
 begin

	predictor: process (reset, clk)
  
  begin
  
     if reset = '1' then
        current_s <= s00;
     elsif (clk'event and clk = '1') then
        current_s <= next_s;
     end if;
    
   end process;

 process (current_s, taken)

 	begin
			
		case current_s is
        
					when s00 =>
						predicted_outcome <= '0';
          
						if (taken = '1') then
							next_s <= s01;
						else
							next_s <= s00;
						end if;
            
					when s01 =>
						predicted_outcome <= '0';
          
						if (taken = '1') then
							next_s <= s11;
                                             
						else
							next_s <= s00;
						end if;
            
					when s10 =>
						predicted_outcome <= '1';
          
						if (taken = '1') then
							next_s <= s11;
                                             
						else
							next_s <= s00;
						end if;
            
					when s11 =>
						predicted_outcome <= '1';

						if (taken = '0') then
							next_s <= s10;
                        else
							next_s <= s11;
						end if;			
            
					
				
          
				end case;
            
      end process;

	  end behaviour;