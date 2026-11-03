library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab04_tb is
end entity lab04_tb;

architecture sim of lab04_tb is

    signal clk : STD_LOGIC := '0';
    signal sw  : STD_LOGIC := '1';
    signal led : STD_LOGIC;

    constant CLK_PERIOD : time := 20 ns;  -- 50MHz

begin

    uut: entity work.lab04
        port map (
            i_clk => clk,
            i_sw  => sw,
            o_led => led
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Mô phỏng nhấn nút có DỘI (bounce) khi nhả ra
    stim_process: process
    begin
        wait for 1000 ns;

        -- Nhấn xuống (giả lập vài lần dội lúc nhấn)
        sw <= '0'; wait for 50 ns;
        sw <= '1'; wait for 30 ns;   -- dội
        sw <= '0'; wait for 40 ns;
        sw <= '1'; wait for 20 ns;   -- dội
        sw <= '0'; wait for 5000 ns; -- giữ ổn định ở mức nhấn

        -- Thả ra (giả lập vài lần dội lúc thả)
        sw <= '1'; wait for 30 ns;
        sw <= '0'; wait for 40 ns;   -- dội
        sw <= '1'; wait for 25 ns;
        sw <= '0'; wait for 35 ns;   -- dội
        sw <= '1'; wait for 5000 ns; -- giữ ổn định ở mức nhả -> LED phải toggle đúng 1 lần

        wait;
    end process;

end architecture sim;