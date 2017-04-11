-- VHDL FILE : OVERALL PIPELINED PROCESSOR
-- Last Edited 3-19
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pipelined_processor IS
	PORT(
	clk, enable, reset, done	: IN STD_LOGIC
	);
END pipelined_processor;

ARCHITECTURE behavior OF pipelined_processor IS
-- INSTANTIATION OF STAGE COMPONENTS AND REGISTERS
	--FETCH COMPONENT PERFORMS INSTRUCTION FETCH FROM INSTRUCTION MEMORY
	COMPONENT FETCH IS
	PORT(
		clk, enable, reset	: IN STD_LOGIC;
		if_branch	: IN STD_LOGIC;
		branch_addr	: IN STD_LOGIC_VECTOR (31 downto 0);
		count, instruction : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
	END COMPONENT;
	--REGISTER BETWEEN FETCH AND DECODE STAGES
	COMPONENT IF_ID IS
	PORT(
		clk				: IN STD_LOGIC;
		count_in, instruction_in : IN STD_LOGIC_VECTOR(31 downto 0);
		count_out, instruction_out : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
	END COMPONENT;
	--DECODE STAGE: SPLITS THE 32-bit WORD INTO ADDRESS POINTERS, IMMEDIATES, JUMP ADDRESSES, ETC.
	COMPONENT ID IS
	PORT(
		if_write, reset, clk, done		: IN STD_LOGIC;
		count, instruction, write_data	: IN STD_LOGIC_VECTOR(31 downto 0);
		write_reg			: IN STD_LOGIC_VECTOR(4 downto 0);
		count_out, s_data, t_data, sign, zero		: OUT STD_LOGIC_VECTOR(31 downto 0);
		j_addr						: OUT STD_LOGIC_VECTOR(25 downto 0);
		op, funct					: OUT STD_LOGIC_VECTOR(5 downto 0);
		d_addr, t_addr, shamt				: OUT STD_LOGIC_VECTOR(4 downto 0)
		
	);
	END COMPONENT;
	-- REGISTER BETWEEN DECODE AND EXECUTE
	COMPONENT ID_EX IS
	PORT(
		clk						: IN STD_LOGIC;
		PC, s_data, t_data, sign_ext, zero_ext		: IN STD_LOGIC_VECTOR(31 downto 0);
		op, funct					: IN STD_LOGIC_VECTOR(5 downto 0);
		shamt, t_addr, d_addr				: IN STD_LOGIC_VECTOR(4 downto 0);
		jump_addr					: IN STD_LOGIC_VECTOR(25 downto 0);
		PC_out, s_out, t_out, sign_out, zero_out	: OUT STD_LOGIC_VECTOR(31 downto 0);
		op_out, funct_out				: OUT STD_LOGIC_VECTOR(5 downto 0);
		shamt_out, t_addr_out, d_addr_out		: OUT STD_LOGIC_VECTOR(4 downto 0);
		jump_addr_out					: OUT STD_LOGIC_VECTOR(25 downto 0)
	);
	END COMPONENT;
	-- EXECUTE STAGE CONTAINS MOST OF THE CONTROL MULTIPLEXERS AND THE ALU
	COMPONENT EX IS
	PORT(
		PC, s_data, t_data, zero, sign	: IN STD_LOGIC_VECTOR(31 downto 0);
		op, funct			: IN STD_LOGIC_VECTOR(5 downto 0);
		shamt, t_addr, d_addr		: IN STD_LOGIC_VECTOR(4 downto 0);
		j_addr				: IN STD_LOGIC_VECTOR(25 downto 0);
		mode				: OUT INTEGER;
		equal				: OUT STD_LOGIC;
		result, t_out			: OUT STD_LOGIC_VECTOR(31 downto 0);
		wb_choose			: OUT STD_LOGIC;
		dest_addr			: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
	END COMPONENT;
	-- THE REGISTER BETWEEN EXECUTE AND MEMORY STAGES, CONTAINS SOME LOGIC COMPONENTS FOR EVALUATING BRANCHES
	COMPONENT EX_MEM IS
	PORT(
		clk, equal, choose_in	: IN STD_LOGIC;
		mode		: IN INTEGER;
		result, t_in	: IN STD_LOGIC_VECTOR(31 downto 0);
		d_addr		: IN STD_LOGIC_VECTOR(4 downto 0);
		choose_branch, choose_write_reg, write_mem, choose_wb, is_load	: OUT STD_LOGIC;
		r_data, t_out	: OUT STD_LOGIC_VECTOR(31 downto 0);
		d_addr_out	: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
	END COMPONENT;
	-- MEM STAGE CONTAINS THE DATA MEMORY AND ANOTHER CONTROL MODULE
	COMPONENT MEM IS
	PORT(
		clk, done	: IN STD_LOGIC;
		choose_b, choose_wb, choose_wr, choose_wm, is_load : IN STD_LOGIC;
		result, t_data	: IN STD_LOGIC_VECTOR(31 downto 0);
		dest_addr	: IN STD_LOGIC_VECTOR(4 downto 0);
		choose_b_out, choose_wb_out, choose_wr_out : OUT STD_LOGIC;
		b_addr, result_out, s_out		: OUT STD_LOGIC_VECTOR(31 downto 0);
		dest_addr_out		: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
	END COMPONENT;
	-- REGISTER BETWEEN MEMORY AND WRITE BACK
	COMPONENT MEM_WB IS
		PORT(
		clk, wb_choose, wr_choose		: IN STD_LOGIC;
		DM_in, s_in	: IN STD_LOGIC_VECTOR(31 downto 0);
		write_addr_in	: IN STD_LOGIC_VECTOR(4 downto 0);
		wb_out, wr_out	: OUT STD_LOGIC;
		DM_out, s_out	: OUT STD_LOGIC_VECTOR(31 downto 0);
		write_addr_out	: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
	END COMPONENT;
	-- THE WRITEBACK STAGE IS A SINGLE MULTIPLEXER
	COMPONENT mux_2 IS
	PORT(
		choose		: IN STD_LOGIC;
		A,B		: IN STD_LOGIC_VECTOR(31 downto 0);
		C		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
	END COMPONENT;

	SIGNAL if_branch, if_write : STD_LOGIC := '0';
	SIGNAL branch_addr, PC_F, INSTR_F, PC_d, INSTR_d, wd_d : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	--wd_d is the data written to dest reg for R-type instructions at input of DECODE(ID)
	SIGNAL dest_addr_d : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	--dest_addr_d is data reg to write to for R-type instrs at input of DECODE (ID)
	SIGNAL count_D, s_D, t_D, sign_D, zero_D : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	SIGNAL j_addr_D : STD_LOGIC_VECTOR(25 downto 0) := "00000000000000000000000000";
	SIGNAL op_D, funct_D : STD_LOGIC_VECTOR(5 downto 0) := "000000";
	SIGNAL d_addr_D, t_addr_D, shamt_D : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	--all outputs for DECODE (ID) have _D appended
	SIGNAL count_e, s_e, t_e, sign_e, zero_e : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	SIGNAL j_addr_e : STD_LOGIC_VECTOR(25 downto 0) := "00000000000000000000000000";
	SIGNAL op_e, funct_e : STD_LOGIC_VECTOR(5 downto 0) := "000000";
	SIGNAL d_addr_e, t_addr_e, shamt_e : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	--all inputs for EX have _e appended
	SIGNAL mode_E : INTEGER := 0;
	SIGNAL equal_E, wb_choose_E : STD_LOGIC := '0';
	SIGNAL result_E, t_out_E : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	SIGNAL dest_addr_E : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	--all outputs of EX have _E appended
	SIGNAL b_m, wr_m, wm_m, wb_m, il_m : STD_LOGIC := '0';
	SIGNAL r_data_m, t_out_m : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	SIGNAL d_addr_m : STD_LOGIC_VECTOR(4 downto 0) := "00000";
	--all inputs of MEM have _m appended
	SIGNAL wb_MEM, wr_MEM : STD_LOGIC := '0';
	SIGNAL result_MEM, s_MEM: STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	SIGNAL  dest_addr_MEM :STD_LOGIC_VECTOR(4 downto 0) := "00000";
	--all outputs of MEM have __M appended
	SIGNAL wb_w : STD_LOGIC := '0';
	SIGNAL result_w, s_w : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	--all inputs of WB appended _w
BEGIN
	I_F : FETCH PORT MAP(clk, enable, reset, if_branch, branch_addr, PC_F, INSTR_F);
	FD_reg : IF_ID PORT MAP(clk, PC_F, INSTR_F, PC_d, INSTR_d);
	DECODE : ID PORT MAP(if_write, reset, clk, done, PC_d, INSTR_d, wd_d, dest_addr_d, count_D, s_D, t_D, sign_D, zero_D, j_addr_D, op_D, funct_D, d_addr_D, t_addr_D, shamt_D);
	DE_reg : ID_EX PORT MAP(clk, count_D, s_D, t_D, sign_D, zero_D, op_D, funct_D, shamt_D, t_addr_D, d_addr_D, j_addr_D, count_e, s_e, t_e, sign_e, zero_e, op_e, funct_e, shamt_e, t_addr_e, d_addr_e, j_addr_e);
	EXEC : EX PORT MAP(count_e, s_e, t_e, sign_e, zero_e, op_e, funct_e, shamt_e, t_addr_e, d_addr_e, j_addr_e, mode_E, equal_E, result_E, t_out_E, wb_choose_E, dest_addr_E);
	EM_reg : EX_MEM PORT MAP(clk, equal_E, wb_choose_E, mode_E, result_E, t_out_E, dest_addr_E, b_m, wr_m, wm_m, wb_m, il_m, r_data_m, t_out_m, d_addr_m);
	DataMEM : MEM PORT MAP(clk, done, b_m, wb_m, wr_m, wm_m, il_m, r_data_m, t_out_m, d_addr_m, if_branch, wb_MEM, wr_MEM, branch_addr, result_MEM, s_MEM, dest_addr_MEM);
	MW_reg : MEM_WB PORT MAP(clk, wb_MEM, wr_MEM, result_MEM, s_MEM, dest_addr_MEM, wb_w, if_write, result_w, s_w, dest_addr_d);
	WB : mux_2 PORT MAP(wb_w, result_w, s_w, wd_d);

PROCESS(clk)
BEGIN
	if clk'event and clk = '1' then
		if wb_w = '0' then
			--report "result_w is " & integer'image(to_integer(unsigned(result_w)));
			--report "wb_out is " & integer'image(to_integer(unsigned(wd_d)));
			--report "address is " & integer'image(to_integer(unsigned(dest_addr_d)));
		end if;
	end if;
END PROCESS;

END behavior;