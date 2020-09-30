LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY datapath IS
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

END datapath;

ARCHITECTURE description OF datapath IS
	-- Component instantiations
	
	-- 32 bit ALU
	component ALU is
		port (
			a						:in	  std_logic_vector(31 downto 0);	   -- operand1
			b        			:in	  std_logic_vector(31 downto 0);		-- operand2
			operation         :in     std_logic_vector(2 downto 0);		-- operation
			result		      :inout  std_logic_vector(31 downto 0);		-- result
			carry_out 		   :out	  std_logic;	                     -- carry out flag
			zero					:out	  std_logic									-- zero flag
		);
	end component;
	
	-- 1  bit register
	component bit1register IS 
		PORT(
			d   : IN STD_LOGIC;
			ld  : IN STD_LOGIC; -- load/enable.
			clr : IN STD_LOGIC; -- async. clear.
			clk : IN STD_LOGIC; -- clock.
			q   : OUT STD_LOGIC -- output.
		);
	END component;

	-- 32 bit register
	component bit32register IS 
		PORT(
			d   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ld  : IN STD_LOGIC; -- load/enable.
			clr : IN STD_LOGIC; -- async. clear.
			clk : IN STD_LOGIC; -- clock.
			q   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- output
		);
	END component;
	
	-- Program Counter
	component pc IS 
		PORT(
			d   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ld  : IN STD_LOGIC; -- load/enable.
			clr : IN STD_LOGIC; -- async. clear.
			clk : IN STD_LOGIC; -- clock.
			inc : IN STD_LOGIC; 
			q   : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- output
		);
	END component;
	
	-- Data Memory
	component data_mem IS
	PORT(
			clk		: IN STD_LOGIC;
			addr		: IN UNSIGNED(7 DOWNTO 0);
			data_in	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			wen		: IN STD_LOGIC;
			en			: IN STD_LOGIC;
			data_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END component;
	
	-- 32 bit 2 to 1 Mux
	component mux2to1 is
		port (
			in0, in1 	:in	std_logic_vector(31 downto 0);	-- Mux in
			sel         :in	std_logic;		                  -- select
			y           :out  std_logic_vector(31 downto 0)		-- Mux out
		);
	end component;
	
	-- 32 bit 3 to 1 Mux
	component mux3to1 is
		port (
			in0, in1, in2		:in	std_logic_vector(31 downto 0);	-- Mux in
			sel               :in	std_logic_vector(1 downto 0);		-- select
			y                 :out  std_logic_vector(31 downto 0)		-- Mux out
		);
	end component;
	
	-- Upper Zero Extender
	component UZE is
		port (
			input			:in	std_logic_vector(31 downto 0);	   
			result		:out  std_logic_vector(31 downto 0)  		
		);
	end component;
	
	-- Lower Zero Extender
	component LZE is
		port (
			input			:in	std_logic_vector(31 downto 0);	  
			result		:out  std_logic_vector(31 downto 0) 
		);
	end component;
	
	-- Reducer Unit
	component RED is
	port (
		input			:in	std_logic_vector(31 downto 0);	   
		result		:out  unsigned(7 downto 0)  		
	);
	end component;
	
	-- Internal signals
	signal LZE_PC		:std_logic_vector(31 downto 0);
	signal DATA_BUS	:std_logic_vector(31 downto 0);
	signal A_MUX_A 	:std_logic_vector(31 downto 0);
	signal B_MUX_B 	:std_logic_vector(31 downto 0);
	signal ALU_C   	:std_logic;
	signal ALU_Z   	:std_logic;
	signal IMMUX1_ALU :std_logic_vector(31 downto 0);
	signal IMMUX2_ALU :std_logic_vector(31 downto 0);
	signal ALU_DMUX   :std_logic_vector(31 downto 0);
	signal RED_DMEM   :unsigned(7 downto 0);
	signal RMUX_DIN   :std_logic_vector(31 downto 0);
	signal O_IR       :std_logic_vector(31 downto 0);
	signal O_PC       :std_logic_vector(31 downto 0);
	signal O_A        :std_logic_vector(31 downto 0);
	signal O_B        :std_logic_vector(31 downto 0);
	signal M_OUT      :std_logic_vector(31 downto 0);
	signal LZE_A      :std_logic_vector(31 downto 0);
	signal LZE_B      :std_logic_vector(31 downto 0);
	signal UZ_I       :std_logic_vector(31 downto 0);
	signal LZE_I2		:std_logic_vector(31 downto 0);
	
BEGIN
	-- connections to IR Register
	IR:	bit32register  port map(d		   => DATA_BUS,
											ld       => Ld_IR,  
											clr		=> Clr_IR, 
											clk		=> Clk,
											q		   => O_IR);
   -- connections to PC
	PCOUNT:	pc          port map(d		   => LZE_PC,
											ld       => Ld_PC,  
											clr		=> Clr_PC, 
											clk		=> Clk,
											inc      => Inc_PC,
											q		   => O_PC);
	-- connections to A Register
	AREG:	bit32register  port map(d		   => A_MUX_A,
											ld       => Ld_A,  
											clr		=> Clr_A, 
											clk		=> Clk,
											q		   => O_A);		
	-- connections to B Register
	BREG:	bit32register  port map(d		   => B_MUX_B,
											ld       => Ld_B,  
											clr		=> Clr_B, 
											clk		=> Clk,
											q		   => O_B);
	-- connections to C Register
	CREG:	bit1register   port map(d		   => ALU_C,
											ld       => Ld_C,  
											clr		=> Clr_C, 
											clk		=> Clk,
											q		   => OUT_C);
	-- connections to Z Register
	ZREG:	bit1register   port map(d		   => ALU_Z,
											ld       => Ld_Z,  
											clr		=> Clr_Z, 
											clk		=> Clk,
											q		   => OUT_Z);
	-- connections to ALU
	A_L_U:	alu         port map(a		  		=> IMMUX1_ALU,
											b       		=> IMMUX2_ALU,  
											operation	=> ALU_Op, 
											result		=> ALU_DMUX,
											carry_out   => ALU_C,
											zero		   => ALU_Z);
   -- connections to DATA MEMORY
	DMEM:	data_mem       port map(clk		  	=> mClk,
											addr       	=> RED_DMEM,  
											data_in	   => RMUX_DIN, 
											wen		   => WEN,
											en          => EN,
											data_out		=> M_OUT);
	-- connections to A_MUX	
	AMux:	mux2to1        port map(in0	=> DATA_BUS,
											in1   => LZE_A,  
											sel	=> A_MUX, 
											y		=> A_MUX_A);
	-- connections to B_MUX	
	BMux:	mux2to1        port map(in0	=> DATA_BUS,
											in1   => LZE_B,  
											sel	=> B_MUX, 
											y		=> B_MUX_B);
	-- connections to REG_MUX	
	RMux:	mux2to1        port map(in0	=> O_A,
											in1   => O_B,  
											sel	=> REG_Mux, 
											y		=> RMUX_DIN);
	-- connections to IM_MUX1	
	IMux1:	mux2to1     port map(in0	=> O_A,
											in1   => UZ_I,  
											sel	=> IM_MUX1, 
											y		=> IMMUX1_ALU);
	-- connections to IM_MUX2	
	IMux2:	mux3to1     port map(in0	=> O_B,
											in1   => LZE_I2,
											in2	=> X"00000001",
											sel	=> IM_MUX2, 
											y		=> IMMUX2_ALU);
	-- connections to DATA_MUX	
	DMux:	mux3to1        port map(in0	=> DATA_IN,
											in1   => M_OUT,
											in2	=> ALU_DMUX,
											sel	=> DATA_Mux, 
											y		=> DATA_BUS);
	-- connections to LZE_A	
	LZE_A1:	LZE         port map(input	      => O_IR,
											result		=> LZE_A);
	-- connections to LZE_B	
	LZE_B1:	LZE         port map(input	      => O_IR,
											result		=> LZE_B);
	-- connections to LZE_P	
	LZE_P:	LZE         port map(input	      => O_IR,
											result		=> LZE_PC);
	-- connections to LZE_I	
	LZE_I:	LZE         port map(input	      => O_IR,
											result		=> LZE_I2);
	-- connections to UZE_I	
	UZE_I:	UZE         port map(input	      => O_IR,
											result		=> UZ_I);
	-- connections to REDU	
	REDU:	RED            port map(input	      => O_IR,
											result		=> RED_DMEM);
	-- Debugging										
	OUT_A 	<= O_A;
	OUT_B 	<= O_B;
	ADDR_OUT	<= O_PC;
	OUT_PC	<= O_PC;
	OUT_IR	<= O_IR;
	DATA_OUT <= DATA_BUS;
	MEM_OUT  <= M_OUT;
	MEM_IN   <= RMUX_DIN;
	MEM_ADDR <= RED_DMEM;
END description;

-- Question 1:
--INCA : On the first Clk cycle the A reg value gets sent to the Alu to be incremented by 1
--       Then gets sent through the data bus where on the next Clk cycle gets loaded in A reg

--ADDI:  The lower 16 bits of the IR register get sent to the ALU by first traveling through the
--       LZE and IM_MUX2 these bits then get added to A  signal and then get stored in A register

--LDBI:  The lower 16 bits of the IR travel through LZE and into B register where LD_b is set 
--

--LDA:   32 bits of IR travel through Red unit where it becomes unsigned 8 bit value and gets loaded into Data mem.
--			this is the address in which the A value will be stored. Value stored in A register travels to the Data Memory.
--       and gets stored in the address specified earlier. 

-- Question 2:
-- because the mClk lines up with the clock it only takes 40ns for one stage of an instruction to occur. This means since each instruction
-- has 3 stages it takes a minimum of 120ns for an instruction to execute. 

-- Question 3:
-- as stated earlier a reliable limit would be 120ns for a clock to occur. because a instruction needs to be sent to the IR, T0 and then registers need to 
-- be clocked again. and finally another clock would be needed for the new info to be stored in there respective registers. 