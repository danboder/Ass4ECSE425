LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity registers is

	port(
   
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
  signal reg_write : STD_LOGIC;
  signal IR6_10, IR11_15, IR_WB : STD_LOGIC_VECTOR(4 downto 0);
  signal result_data, data_1, data_2 : STD_LOGIC_VECTOR(31 downto 0);
BEGIN
  registers_process : PROCESS(reg_1, reg_2, write_reg, write_data, regwrite) IS
	BEGIN
      reg_write <= regwrite;
      IR6_10 <= reg_1;
      IR11_15 <= reg_2;
      IR_WB <= write_reg;
      result_data <= write_data;
	END PROCESS;
	data_reg_1 <= data_1;
	data_reg_2 <= data_2;
END behavior;
	