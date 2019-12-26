library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipbus.all;

entity ipbus_dpram is
	generic(
		ADDR_WIDTH: natural
	);
	port(
		clk: in std_logic;
		rst: in std_logic;
		ipb_in: in ipb_wbus;
		ipb_out: out ipb_rbus;
		rclk: in std_logic;
		we: in std_logic := '0';
		d: in std_logic_vector(31 downto 0) := (others => '0');
		q: out std_logic_vector(31 downto 0);
		addr: in std_logic_vector(9 downto 0)
	);
	
end ipbus_dpram;

architecture rtl of ipbus_dpram is

	type ram_array is array(2 ** ADDR_WIDTH - 1 downto 0) of std_logic_vector(31 downto 0);
	shared variable ram: ram_array;
	signal sel, rsel: integer;
	signal ack: std_logic;
    -- debug
    --signal vio_ram: std_logic_vector(31 downto 0);
    --signal vio_addr: std_logic_vector(9 downto 0);
        
    --COMPONENT vio_dpram
    --  PORT (
    --    clk : IN STD_LOGIC;
    --    probe_in0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    --    probe_out0 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    --  );
    --END COMPONENT;
    
begin
    
	sel <= to_integer(unsigned(ipb_in.ipb_addr(addr_width-1 downto 0)));

	process(clk)
	begin
		if rising_edge(clk) then
			ipb_out.ipb_rdata <= ram(sel); -- Order of statements is important to infer read-first RAM!
			if ipb_in.ipb_strobe='1' and ipb_in.ipb_write='1' then
				ram(sel) := ipb_in.ipb_wdata;
			end if;
			ack <= ipb_in.ipb_strobe and not ack;
		end if;
	end process;
	
	ipb_out.ipb_ack <= ack;
	ipb_out.ipb_err <= '0';
	
	rsel <= to_integer(unsigned(addr));
	
	process(rclk)
	begin
		if falling_edge(rclk) then
			q <= ram(rsel); -- Order of statements is important to infer read-first RAM!
			if we = '1' then
				ram(rsel) := d;
			end if;
		end if;
	end process;
	
	--p_vio: process(vio_addr)
    --    variable i : integer;
    --    begin
    --       i := to_integer(unsigned(vio_addr));
    --       vio_ram <= ram(i); -- read ram
    --    end process;
        
	--vio_dpram0 : vio_dpram
    --  PORT MAP (
    --    clk => rclk,
    --    probe_in0 => vio_ram,
    --    probe_out0 => vio_addr
    -- );


end rtl;
