LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity registers is

	port(
		
    reset       : in std logic;		
    clk         : in std_logic;
    regwrite	: in std_logic;
    reg_1	: in std_logic_vector(4 downto 0);
    reg_2	: in std_logic_vector(4 downto 0);
    write_reg	: in std_logic_vector(4 downto 0);
    write_data	: in std_logic_vector(31 downto 0);
    data_reg_1	: out std_logic_vector(31 downto 0);
    data_reg_2	: out std_logic_vector(31 downto 0)

	);
end registers;

ARCHITECTURE behavior OF registers IS

    type reg_type is array(31 downto 0) OF std_logic_vector(31 downto 0);
    SIGNAL reg_s: reg_type;
	
BEGIN
  registers_process : PROCESS(clk, reset) IS
   begin
      if reset = '0' then
        for i in 0 to 31 loop
          reg_s(i) <= (others => '0'); 
        end loop;
      elsif rising_edge(clk) then
        if regwrite = '1' then
          if to_integer(unsigned(write_reg)) /= 0 then  
            reg_s(to_integer(unsigned(write_reg))) <= write_data;
          end if;
        end if;
      end if;
    end process ;
    data_reg_1 <= reg_s(to_integer(unsigned(reg_1)));
    data_reg_2 <= register_signal(to_integer(unsigned(reg_2)));
	
END behavior;
	
