defmodule Imgserver.Fs.File do
  alias Imgserver.Shared.Time, as: TimeUtil

  defstruct atime: "",
            ctime: "",
            mtime: "",
            size: 0,
            name: "",
            full_name: ""

  @type t() :: %__MODULE__{
          atime: String.t(),
          ctime: String.t(),
          mtime: String.t(),
          size: integer(),
          name: String.t(),
          full_name: String.t()
        }

  @spec from_stat(File.Stat.t(), Path.t(), Path.t()) :: __MODULE__.t()
  def from_stat(stat, name \\ "", full_name \\ "") do
    %__MODULE__{
      atime: TimeUtil.to_string(stat.atime),
      ctime: TimeUtil.to_string(stat.ctime),
      mtime: TimeUtil.to_string(stat.mtime),
      size: stat.size,
      name: name,
      full_name: full_name
    }
  end
end
