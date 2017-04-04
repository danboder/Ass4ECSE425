-- DECODE STAGE CODE
-- LAST EDITED 3-19
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
	-- THIS MODULE TAKES THE 32-BIT WORD AND DIVIDES IT INTO THE NECESSARY ADDRESSES, OFFSETS, ETC.
	COMPONENT Split_32 IS
	PORT(
		instr				: IN STD_LOGIC_VECTOR(31 downto 0); -- 32-BIT INSTRUCTION WORD INPUT
		j_addr				: OUT STD_LOGIC_VECTOR(25 downto 0); -- JUMP ADDRESS
		imm				: OUT STD_LOGIC_VECTOR(15 downto 0); -- IMMEDIATE VALUE (PRE-EXTENSION)
		op, funct 			: OUT STD_LOGIC_VECTOR(5 downto 0); -- OP-CODE AND FUNCTION FLAGS
		s_addr, t_addr, d_addr, shamt	: OUT STD_LOGIC_VECTOR(4 downto 0) -- REGISTER ADDRESSES AND 5-BIT OFFSET SHAMT
	);
	END COMPONENT;
	-- THIS IS THE 32-BIT, 32 WORD REGISTER FILE CAPABLE OF WRITES AND READS
	COMPONENT registers is

   	port(
		
    	reset       : in std_logic;		
    	clk         : in std_logic;
    	regwrite	: in std_logic;
    	reg_1	: in std_logic_vector(4 downto 0); -- ADDRESS OF S-REG
    	reg_2	: in std_logic_vector(4 downto 0); -- ADDRESS OF T-REG
    	write_reg	: in std_logic_vector(4 downto 0); -- ADDRESS OF D-REG (PIPED BACK FROM WRITEBACK)
    	write_data	: in std_logic_vector(31 downto 0); -- DATA TO WRITE FOR WRITE-BACK
    	data_reg_1	: out std_logic_vector(31 downto 0); -- 32-BIT WORDS SAVED IN S- AND T- REGS
    	data_reg_2	: out std_logic_vector(31 downto 0); -- ^
	done        : in std_logic -- DONE BIT (USED TO WRITE THE FINAL register_file.txt

	);
	end COMPONENT;
	-- THIS COMPONENT PERFORMS BOTH ZERO- AND SIGN-EXTENSION AND OUTPUTS BOTH RESULTS
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