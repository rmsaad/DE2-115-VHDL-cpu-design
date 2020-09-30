LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY data_mem IS
PORT(
		clk		: IN STD_LOGIC;
		addr		: IN UNSIGNED(7 DOWNTO 0);
		data_in	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		wen		: IN STD_LOGIC;
		en			: IN STD_LOGIC;
		data_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END data_mem;

ARCHITECTURE Description OF data_mem IS
signal sigOUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
type array2D is array (7 downto 0) of std_logic_vector(31 downto 0);
signal M : array2D;

BEGIN
PROCESS(clk)
BEGIN
    if (falling_edge(clk)) then
        if (en = '1') then
            if (wen = '0') then
                --Reading operation data_out = M{addr}
                sigOUT <= M(to_integer(addr));
            else
                --Writing operation M{addr} <= data_in, data_out = 0
                M(to_integer(addr)) <= data_in;
                sigOUT <= (sigOUT'range => '0');
            end if;
        else
                --no operation, data_out = 0
            sigOUT <= (sigOUT'range => '0');
        end if; 
    end if;
END PROCESS;

data_out <= sigOUT;
END Description;