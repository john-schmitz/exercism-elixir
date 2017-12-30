defmodule SecretHandshake do
  @reverser 16

  def commands(code) when rem(code, @reverser) == 0, do: []

  def commands(code) do
    handshakes = do_commands([], code)

    if code / @reverser > 1 do
      handshakes |> Enum.reverse()
    else
      handshakes
    end
  end

  def do_commands(code) when code < 1, do: []
  def do_commands(handshakes, 0), do: handshakes

  def do_commands(handshakes, code) when code - 16 >= 0 do
    do_commands(handshakes, code - 16)
  end

  def do_commands(handshakes, code) when code - 8 >= 0 do
    do_commands(["jump" | handshakes], code - 8)
  end

  def do_commands(handshakes, code) when code - 4 >= 0 do
    do_commands(["close your eyes" | handshakes], code - 4)
  end

  def do_commands(handshakes, code) when code - 2 >= 0 do
    do_commands(["double blink" | handshakes], code - 2)
  end

  def do_commands(handshakes, code) when code - 1 >= 0 do
    do_commands(["wink" | handshakes], code - 1)
  end
end
