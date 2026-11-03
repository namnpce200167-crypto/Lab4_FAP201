library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab04 is
    port (
        i_clk : in  STD_LOGIC;   -- Clock 50MHz
        i_sw  : in  STD_LOGIC;   -- Switch input (active-low)
        o_led : out STD_LOGIC    -- LED output (active-low)
    );
end entity lab04;

architecture rtl of lab04 is

    -- Đồng bộ hóa switch (chống metastable)
    signal sw_sync0, sw_sync1 : STD_LOGIC := '1';

    -- Bộ đếm ổn định cho debounce
    -- 50MHz clock, muốn thời gian ổn định ~10ms
    -- 50_000_000 Hz * 0.01s = 500_000 chu kỳ -> cần 19 bit đếm
    constant DEBOUNCE_LIMIT : unsigned(18 downto 0) := to_unsigned(500000, 19);
    signal debounce_cnt : unsigned(18 downto 0) := (others => '0');

    -- Giá trị switch đã được lọc dội (debounced)
    signal sw_debounced      : STD_LOGIC := '1';
    signal sw_debounced_prev : STD_LOGIC := '1';

    -- Trạng thái LED
    signal led_reg : STD_LOGIC := '0';

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then

            ------------------------------------------------
            -- Bước 1: Đồng bộ hóa tín hiệu switch với clock
            ------------------------------------------------
            sw_sync0 <= i_sw;
            sw_sync1 <= sw_sync0;

            ------------------------------------------------
            -- Bước 2: Debounce
            ------------------------------------------------
            if (sw_sync1 = sw_debounced) then
                debounce_cnt <= (others => '0');
            else
                debounce_cnt <= debounce_cnt + 1;

                if (debounce_cnt = DEBOUNCE_LIMIT) then
                    sw_debounced <= sw_sync1;
                    debounce_cnt <= (others => '0');
                end if;
            end if;

            ------------------------------------------------
            -- Bước 3: Phát hiện cạnh "nhả nút"
            -- và toggle LED
            ------------------------------------------------
            sw_debounced_prev <= sw_debounced;

            if (sw_debounced_prev = '0' and sw_debounced = '1') then
                led_reg <= not led_reg;
            end if;

        end if;
    end process;

    -- LED active-low
    o_led <= not led_reg;

end architecture rtl;