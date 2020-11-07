defmodule Extractor do
  use GenStage

  def init(partitions) do
    {:producer_consumer, :ok, dispatcher: {GenStage.PartitionDispatcher, partitions: partitions}}
  end

  def handle_events(lines, _from, _state) do
    lines = Enum.flat_map(lines, &Palavriado.extract_words/1)
    {:noreply, lines, :ok}
  end
end
