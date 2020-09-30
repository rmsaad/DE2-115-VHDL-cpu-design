LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY cpu1 IS
	PORT(
		-- Input ports
		clk		: in	std_logic;
		mem_clk	: in	std_logic;
		rst		: in	std_logic;
		dataIn	: in	std_logic_vector(31 downto 0);
		
		-- Output ports
		dataOut		: out	std_logic_vector(31 downto 0);
		addrOut		: out	std_logic_vector(31 downto 0);
		wEn 		: out	std_logic;
		
		-- Debug data.
		dOutA, dOutB	: out	std_logic_vector(31 downto 0);
		dOutC, dOutZ	: out	std_logic;
		dOutIR			: out	std_logic_vector(31 downto 0);
		dOutPC			: out	std_logic_vector(31 downto 0);
		outT			: out	std_logic_vector(2 downto 0);
		wen_mem, en_mem : out std_logic);

END cpu1;

ARCHITECTURE behavior OF cpu1 IS

component reset_circuit is
	PORT
	(
		Reset : 		IN STD_LOGIC;
		Clk : 		IN STD_LOGIC;
		Enable_PD : OUT STD_LOGIC;
		Clr_PC : 	OUT STD_LOGIC
		);
END component;

component control IS
	PORT(
		clk, mclk : IN STD_LOGIC;
		enable : IN STD_LOGIC;
		statusC, statusZ : IN STD_LOGIC;
		INST : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		A_Mux, B_Mux : OUT STD_LOGIC;
		IM_MUX1, REG_Mux : OUT STD_LOGIC;
		IM_MUX2, DATA_Mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALU_op : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		inc_PC, ld_PC : OUT STD_LOGIC;
		clr_IR : OUT STD_LOGIC;
		ld_IR : OUT STD_LOGIC;
		clr_A, clr_B, clr_C, clr_Z : OUT STD_LOGIC;
		ld_A, ld_B, ld_C, ld_Z : OUT STD_LOGIC;
		T : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		wen, en : OUT STD_LOGIC);
END component;

component datapath IS
	PORT( Clk, mClk :				IN STD_LOGIC; -- clock Signal

-- Memory Signals
WEN, EN :						IN STD_LOGIC;

-- Register Control Signals(CLR and LD).
Clr_A, Ld_A :					IN STD_LOGIC;
Clr_B, Ld_B :					IN STD_LOGIC;
Clr_C, Ld_C :					IN STD_LOGIC;
Clr_Z, Ld_Z :					IN STD_LOGIC;
Clr_PC, Ld_PC :				IN STD_LOGIC;
Clr_IR, Ld_IR :				IN STD_LOGIC;

-- Register outputs (Some needed to feed back to control unit. Others pulled out for testing.)
OUT_A :							OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
OUT_B :							OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
OUT_C :							OUT STD_LOGIC;
OUT_Z :							OUT STD_LOGIC;
OUT_PC :							OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
OUT_IR :							OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

-- Special inputs to PC.
Inc_PC :							IN STD_LOGIC;

-- Address and Data Bus signals for debugging.
ADDR_OUT :						OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
DATA_IN :						IN STD_LOGIC_VECTOR(31 DOWNTO 0);
DATA_OUT,MEM_OUT,MEM_IN :	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
MEM_ADDR :						OUT unsigned(7 DOWNTO 0);

-- Various MUX controls.
DATA_Mux :						IN STD_LOGIC_VECTOR(1 DOWNTO 0);
REG_Mux :						IN STD_LOGIC;
A_MUX,B_MUX :					IN STD_LOGIC;
IM_MUX1 :						IN STD_LOGIC;
IM_MUX2 :						IN STD_LOGIC_VECTOR(1 DOWNTO 0);

-- ALU Operations.
ALU_Op :							IN STD_LOGIC_VECTOR(2 DOWNTO 0));

END component;

signal sen_out : std_logic; --en to control
signal sclr_pcout : std_logic; -- clr_pc to datapath
signal sc_out : std_logic; -- output statusC
signal sz_out : std_logic; -- output statusZ
signal spcmux : std_logic; -- pc mux
signal samux : std_logic; -- pc mux
signal sbmux : std_logic; -- pc mux
signal simmux1 : std_logic; -- im mux
signal sregmux : std_logic; -- reg mux
signal simmux2 : std_logic_vector(1 downto 0); -- im mux2
signal sdatamux : std_logic_vector(1 downto 0); -- data mux

signal sopee : std_logic_vector(2 downto 0); -- alu op
signal sincapc : std_logic; -- inc pc
signal sclr_pc : std_logic; -- clr pc
signal sldapc : std_logic; -- ld pc
signal sclr_ir : std_logic; -- clr ir
signal sldair : std_logic; -- ld ir
signal sclr_a : std_logic; -- clr a
signal sclr_b : std_logic; -- clr b
signal sclr_c : std_logic; -- clr c
signal sclr_z : std_logic; -- clr z
signal sldaa : std_logic; -- ld a
signal sldab : std_logic; -- ld b
signal sldac : std_logic; -- ld c
signal sldaz : std_logic; -- ld z
signal swehn : std_logic; -- wen signal
signal sehn : std_logic; -- en signal
signal souta, soutb, soutir : std_logic_vector(31 downto 0);
signal mem_a: unsigned(7 DOWNTO 0);


begin
	wen_mem <= swehn;
	en_mem <= sehn;
	dOutC <= sc_out;
	dOutZ <= sz_out;
	dOutA <= souta;
	dOutB <= soutb;
	dOutIR <= soutir;

	thereset: reset_circuit port map(
		reset => rst,
		clk => clk,
		Enable_PD => sen_out,
		Clr_PC => sclr_pcout);

	thecontrol: control port map(
		clk => clk,
		mclk => mem_clk,
		enable => sen_out,
		statusC => sc_out,
		statusZ => sz_out,
		INST => dataIn,
		A_Mux => samux,
		B_Mux => sbmux,
		IM_MUX1 => simmux1,
		REG_Mux => sregmux,
		IM_MUX2 => simmux2,
		DATA_Mux => sdatamux,
		ALU_op => sopee,
		inc_PC => sincapc,
		ld_PC => sldapc,
		clr_IR => sclr_ir,
		ld_IR => sldair,
		clr_A => sclr_a,
		clr_B => sclr_b,
		clr_C => sclr_c,
		clr_Z => sclr_z,
		ld_A => sldaa,
		ld_B => sldab,
		ld_C => sldac,
		ld_Z => sldaz,
		T => outT,
		wen => swehn,
		en => sehn);

	thedatapath: datapath port map(
		Clk => clk,
		mClk => mem_clk,
		WEN => swehn,
		EN => sehn,
		Clr_A => sclr_a,
		Ld_A => sldaa,
		Clr_B => sclr_b,
		Ld_B => sldab,
		Clr_C => sclr_c,
		Ld_C => sldac,
		Clr_Z => sclr_z,
		Ld_Z => sldaz,
		Clr_PC => sclr_pc,
		Ld_PC => sldapc,
		Clr_IR => sclr_ir,
		Ld_IR => sldair,
		OUT_A => souta,
		OUT_B => soutb,
		OUT_C => sc_out,
		OUT_Z => sz_out,
		OUT_PC => dOutPC,
		OUT_IR => soutir,
		Inc_PC => sincapc,
		ADDR_OUT => addrOut,
		DATA_IN => dataIn,
		DATA_OUT => dataOut,
		DATA_Mux => sdatamux,
		REG_Mux => sregmux,
		A_MUX => samux,
		B_MUX => sbmux,
		IM_MUX1 => simmux1,
		IM_MUX2 => simmux2,
		ALU_Op => sopee,
		MEM_ADDR => mem_a
		);
		
end behavior;