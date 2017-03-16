LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY memory_tb IS
END memory_tb;

ARCHITECTURE behaviour OF memory_tb IS

--Declare the component that you are testing:
    COMPONENT memory IS
        GENERIC(
            ram_size : INTEGER := 8192;
            mem_delay : time := 1 ns;
            clock_period : time := 1 ns
        );
        PORT (
            clock: IN STD_LOGIC;
            writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            address: IN INTEGER RANGE 0 TO ram_size-1;
            memwrite: IN STD_LOGIC := '0';
            memread: IN STD_LOGIC := '0';
            readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            waitrequest: OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT read IS
        GENERIC(
            ram_size : INTEGER := 8192;
		    mem_delay : time := 1 ns;
		    clock_period : time := 1 ns
        );

        PORT (
            address: OUT INTEGER RANGE 0 TO ram_size-1;
		    memwrite: OUT STD_LOGIC;
		    waitrequest: IN STD_LOGIC;
		    begin_loading: IN STD_LOGIC;
		    load_to_memory: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            done: OUT STD_LOGIC
        );
    END COMPONENT;

    --all the input signals with initial values
    signal clk : std_logic := '0';
    constant clk_period : time := 1 ns;
    signal writedata: std_logic_vector(31 downto 0);
    signal address: INTEGER RANGE 0 TO 8192-1;
    signal memwrite: STD_LOGIC := '0';
    signal memread: STD_LOGIC := '0';
    signal readdata: STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal waitrequest: STD_LOGIC;
    signal done: STD_LOGIC;
    signal begin_loading: STD_LOGIC;

BEGIN

    --dut => Device Under Test
    dut: memory GENERIC MAP(
            ram_size => 8192
                )
                PORT MAP(
                    clk,
                    writedata,
                    address,
                    memwrite,
                    memread,
                    readdata,
                    waitrequest
                );

    reader: read
        port map(
            waitrequest => waitrequest,
            begin_loading => begin_loading,
            address => address,
            memwrite => memwrite,
            load_to_memory => writedata,
            done => done
        );

    clk_process : process
    BEGIN
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    test_process : process
    BEGIN
        begin_loading <= '1';
    end process;

 
END;
