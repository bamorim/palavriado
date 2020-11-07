defmodule Palavriado.Pull.Counter do
  use GenStage

  def init(report_to_pid) do
    {:consumer, {report_to_pid, %{}}}
  end

  def handle_events(words, _from, {report_to_pid, counts}) do
    counts = Enum.reduce(words, counts, fn word, acc ->
      Map.update(acc, word, 1, & &1 + 1)
    end)

    {:noreply, [], {report_to_pid, counts}}
  end

  def terminate(:normal, {report_to_pid, counts}) do
    send(report_to_pid, {:done, self(), counts})
  end
end
