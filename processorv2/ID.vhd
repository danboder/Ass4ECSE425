LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ID IS
	PORT(
		if_write, reset, clk, done		: IN STD_LOGIC;
		count, instruction, write_data	: IN STD_LOGIC_VECTOR(31 downto 0);
		write_reg			: IN STD_LOGIC_VECTOR(4 downto 0);
		count_out, s_data, t_data, sign, zero		: OUT STD_LOGIC_VECTOR(31 downto 0);
		j_addr						: OUT STD_LOGIC_VECTOR(25 downto 0);
		op, funct					: OUT STD_LOGIC_VECTOR(5 downto 0);
		d_addr, t_addr, shamt				: OUT STD_LOGIC_VECTOR(4 downto 0)
		
	);
END ID;

ARCHITECTURE behavior OF ID IS
	COMPONENT Split_32 IS
	PORT(
		instr				: IN STD_LOGIC_VECTOR(31 downto 0);
		j_addr				: OUT STD_LOGIC_VECTOR(25 downto 0);
		imm				: OUT STD_LOGIC_VECTOR(15 downto 0);
		op, funct 			: OUT STD_LOGIC_VECTOR(5 downto 0);
		s_addr, t_addr, d_addr, shamt	: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
	END COMPONENT;

	COMPONENT registers is

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
	end COMPONENT;

	COMPONENT Sign_extend IS
	PORT(
		Imm_in			: IN STD_LOGIC_VECTOR(15 downto 0);
		sign_ext, zero_ext	: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
	END COMPONENT;
	signal imm_temp : STD_LOGIC_VECTOR(15 downto 0);
	signal s_temp, t_temp : STD_LOGIC_VECTOR(4 downto 0);
BEGIN
	Spl : Split_32 PORT MAP (instruction, j_addr, imm_temp, op, funct, s_temp, t_temp, d_addr, shamt);
	Reg : registers PORT MAP (reset, clk, if_write, s_temp, t_temp, write_reg, write_data, s_data, t_data, done);
	S_E : Sign_extend PORT MAP (imm_temp, sign, zero);
	count_out <= count;
	t_addr <= t_temp;
	
END behavior;