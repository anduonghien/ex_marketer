defmodule ExMarketer.Crawler.TaskSupervisor do
  alias ExMarketer.Crawler.Worker

  def start_chilld(keyword) do
    # TODO: Store the keyword to db
    record_id = 1

    Task.Supervisor.start_child(
      ExMarketer.TaskSupervisor,
      fn -> Worker.perform(record_id, keyword) end,
      restart: :transient
    )
  end
end