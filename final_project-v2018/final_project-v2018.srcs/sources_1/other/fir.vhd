library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir is
  generic(N      : integer := 16);
  Port (
     clk        : in  std_logic;
     board_clk  : in  std_logic;
     rst        : in  std_logic;
     x_in       : in  std_logic_vector(N-1 downto 0);
     y_out      : out std_logic_vector(N-1 downto 0);
     we_out     : out std_logic;                       -- write enable for the dpram
     address_out: out std_logic_vector(9 downto 0));    -- address for the dpram 
end fir;

architecture rtl of fir is
-- 198. 208. 212. 208. 198.
constant C0 : integer := 198;
constant C1 : integer := 208;
constant C2 : integer := 212;
constant C3 : integer := 208;
constant C4 : integer := 198;

component ffd is
    Port ( D : in std_logic_vector(N-1 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Q : out std_logic_vector(N-1 downto 0));
end component;

COMPONENT ila_2

PORT (
	clk : IN STD_LOGIC;
	probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	probe2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe5 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
	probe6 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	probe7 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END COMPONENT  ;

signal y_f1_f2 : std_logic_vector(N-1 downto 0);
signal y_f2_f3 : std_logic_vector(N-1 downto 0);
signal y_f3_f4 : std_logic_vector(N-1 downto 0);
signal y_f4_out : std_logic_vector(N-1 downto 0);
signal std_sum : std_logic_vector(N-1 downto 0);

signal s_in : signed(2*N-1 downto 0);
signal s_f1_f2 : signed(2*N-1 downto 0);
signal s_f2_f3 : signed(2*N-1 downto 0);
signal s_f3_f4 : signed(2*N-1 downto 0);
signal s_f4_out : signed(2*N-1 downto 0);

signal sum : signed(2*N-1 downto 0);
signal shifted_sum : signed(2*N-1 downto 0);
signal final_sum : signed(N-1 downto 0);

begin

-- sum <= s_in*C0 + s_f1_f2*C1 + s_f2_f3*C2 + s_f3_f4*C3 + s_f4_out*C4 when rising_edge(clk);
sum <= s_in + s_f1_f2 + s_f2_f3 + s_f3_f4 + s_f4_out when rising_edge(clk);
-- we shift right of 10 positions, because we have taken the constants multiplied by 2**10
shifted_sum <= shift_right(sum, 10); 
--shifted_sum <= sum;
final_sum <= resize(shifted_sum, N);

s_in <= signed(x_in)*C0;
s_f1_f2 <= signed(y_f1_f2)*C1;
s_f2_f3 <= signed(y_f2_f3)*C2;
s_f3_f4 <= signed(y_f3_f4)*C3;
s_f4_out <= signed(y_f4_out)*C4;

--s_in <= signed(x_in);
--s_f1_f2 <= signed(y_f1_f2);
--s_f2_f3 <= signed(y_f2_f3);
--s_f3_f4 <= signed(y_f3_f4);
--s_f4_out <= signed(y_f4_out);

std_sum <= std_logic_vector(final_sum);

fir_ila : ila_2
PORT MAP (
	clk => board_clk,
	probe0 => std_logic_vector(shifted_sum), 
	probe1 => std_logic_vector(final_sum),
	probe2 => std_logic_vector(sum), 
	probe3 => std_logic_vector(s_in), 
	probe4 => std_logic_vector(s_f1_f2), 
	probe5 => std_logic_vector(s_f2_f3), 
	probe6 => std_logic_vector(s_f3_f4),
	probe7 => std_logic_vector(s_f4_out)
);

ff1 : ffd port map (D => x_in, clk => clk, rst => rst, Q => y_f1_f2);
ff2 : ffd port map (D => y_f1_f2, clk => clk, rst => rst, Q => y_f2_f3);
ff3 : ffd port map (D => y_f2_f3, clk => clk, rst => rst, Q => y_f3_f4);
ff4 : ffd port map (D => y_f3_f4, clk => clk, rst => rst, Q => y_f4_out);
ff_out : ffd port map (D => std_sum, clk => clk, rst => rst, Q => y_out);  
end rtl;
