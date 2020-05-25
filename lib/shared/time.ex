defmodule Imgserver.Shared.Time do
  def to_string({date, time}) do
    "#{date_to_string(date)} #{time_to_string(time)}"
  end

  def date_to_string({y, m, d}) do
    "#{y}-#{m}-#{d}"
  end

  def time_to_string({h, m, s}) do
    "#{h}:#{m}:#{s}"
  end
end
