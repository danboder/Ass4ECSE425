LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use std.textio.all;

entity registers is

   port(
		
    reset       : in std_logic;		
    clk         : in std_logic;
    regwrite	: in std_logic;
    reg_1	: in std_logic_vector(4 downto 0);
    reg_2	: in std_logic_vector(4 downto 0);
    write_reg	: in std_logic_vector(4 downto 0);
    write_data	: in std_logic_vector(31 downto 0);
    data_reg_1	: out std_logic_vector(31 downto 0);
    data_reg_2	: out std_logic_vector(31 downto 0);
    done        : in std_logic

	);
end registers;

ARCHITECTURE behavior OF registers IS

    type reg_type is array(31 downto 0) OF std_logic_vector(31 downto 0);
    signal reg_s: reg_type;
	
BEGIN
  registers_process : process(clk, reset) IS
   
   begin
      if reset = '1' then
        for i in 0 to 31 loop
          reg_s(i) <= (others => '1'); 
        end loop;
      elsif rising_edge(clk) then
        if regwrite = '1' then  
            reg_s(to_integer(unsigned(write_reg))) <= write_data;
        end if;
	    reg_s(0) <= (others => '0');
      end if;
    end process;
   
    data_reg_1 <= reg_s(to_integer(unsigned(reg_1)));
    data_reg_2 <= reg_s(to_integer(unsigned(reg_2)));

    export: process (clk)
		file file_pointer : text;
        	variable line_content : string(1 to 32);
        	variable current_value  : std_logic_vector(31 downto 0);
        	variable line_num : line;
       		variable i : integer := 0;
			--variable temp : STD_LOGIC;
	begin
	--temp := done;
	if (done = '1') then -- export datamemory to memory.txt
		file_open(file_pointer, "register_file.txt", write_mode);
		for i in 0 to 31 loop
			current_value := reg_s(i);
			for x in 0 to 31 loop
				if(current_value(x) = '0') then
					line_content(32-x) := '0';
				else
					line_content(32-x) := '1';
				end if;
			end loop;
			--REPORT "hehe";
			write(line_num, line_content);
			writeline(file_pointer, line_num);
			--wait for 1* ns;

		end loop;
		file_close(file_pointer);
		--wait;
	end if;
	end process;



	
END behavior;
