
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ID_EX IS
	
  PORT
	(
		clk     : IN STD_LOGIC;

                R1      : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		R2      : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		R_dest	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		data_1	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_2	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		signext	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
                address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		R1_out		: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		R2_out		: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		R_dest_out	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		data_1_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_2_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		signext_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                address_out     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);

END ID_EX;

ARCHITECTURE BEHAVIOR OF ID_EX IS


signal R_1		: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal R_2		: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal R_d		: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal data1	        : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal data2    	: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal sign_ext	        : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal addr             : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
		
	R_1 <= R1;	
	R_2 <= R2;
	R_d <= R_dest;
        data_1 <= data1;	
	data_2 <= data2;	
	sign_ext <= signext;
        addr<= address;
		
ID_EX: process (clk)

begin
	if (clk'event AND clk = '1') then
  
		R1_out <= R_1;	
		R2_out <= R_2;
		R_dest_out <= R_dest;
                data_1_out <= data_1;	
		data_2_out <= data_2;	
		signext_out <= sign_ext;
                address_out <= addr;
    
    end if;
end process;
	
END BEHAVIOR;
