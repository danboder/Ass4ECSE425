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

    signal branch_state: std_logic_vector(1 downto 0);
    signal next_state: std_logic_vector(1 downto 0);
    signal predicted_result : std_logic;
	
 begin

	predictor: process (reset, clk)
  
  begin
  
     if reset = '1' then
        branch_state <= "00";
     elsif (clk'event and clk = '1') then
        branch_state <= next_state;
     end if;
    
   end process;

 process (branch_state, taken)

 	begin
			
		case branch_state is
        
					when "00" =>
          
						if (taken = '1') then
							next_state <= "01";
                                             predicted_result <= '0';
						end if;
            
					when "01" =>
          
						if (taken = '1') then
							next_state <= "11";
                                             predicted_result <= '1';
						else
							next_state <= "00";
                                             predicted_result <= '0';
						end if;
            
					when "10" =>
          
						if (taken = '1') then
							next_state <= "11";
                                             predicted_result <= '1';
						else
							next_state <= "00";
                                             predicted_result <= '0';
						end if;
            
					when "11" =>
          
						if (taken = '0') then
							next_state <= "10";
                                            predicted_result <= '1';
						end if;			
            
					when others =>
          
				end case;
            
      end process;

	  end behaviour;