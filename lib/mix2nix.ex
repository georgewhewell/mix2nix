defmodule Mix2Nix do
  require Logger

  defp fail(reason) do
    IO.puts reason
    System.halt 1
  end

  def main(args) do
    with {options, [path], []} <- OptionParser.parse(args) do
      generate(path)
    else
      err -> fail("Wrong usage idiot")
    end
  end

  @spec eval_lockfile(abspath :: String.t) :: map
  def eval_lockfile(abspath) do
    Logger.info "Evaluating #{abspath}"
    case File.read(abspath) do
      {:ok, info} ->
        case Code.eval_string(info, [], file: abspath) do
          {lock, _binding} when is_map(lock) -> lock
          {_, _binding} -> %{}
        end
      {:error, _} ->
        %{}
    end
  end

  defp find_lockfile(abspath) do
    case File.stat abspath do
      {:ok, %{type: :regular}} -> abspath
      {:ok, %{type: :directory}} -> Path.join abspath, "mix.lock"
      {:error, :enoent} -> fail("Not found: #{abspath}")
    end
  end

  defp fetch_packages(%{} = packages) do
    IO.puts "Packages: #{inspect packages}"
    packages
    |> Enum.map(fn {name, dep} -> {name, {struct(Mix.Dep, dep)} end)
    IO.puts "great!"
    |> inspect |> IO.puts
  end

  defp generate(path) do
    path
    |> find_lockfile
    |> eval_lockfile
    |> fetch_packages
    # |> write_expressions
  end

end
