defmodule PurehavenWeb.Newsletter do
  import Ecto.Query
  alias Purehaven.Repo
  alias Purehaven.Newsletter.Subscription

  def subscribe(email) do
    with {:ok, %Subscription{}} <- validate_email(email),
         {:ok, _} <- check_if_subscribed(email),
         {:ok, subscription} <- create_subscription(email) do
      {:ok, subscription}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_email(email) do
    if Regex.match?(~r/@/, email) do
      {:ok, %Subscription{email: email}}
    else
      {:error, :invalid_email}
    end
  end

  defp check_if_subscribed(email) do
    case Repo.one(from s in Subscription, where: s.email == ^email) do
      nil -> {:ok, :not_subscribed}
      _ -> {:error, :already_subscribed}
    end
  end

  defp create_subscription(email) do
    %Subscription{email: email}
    |> Subscription.changeset(%{})
    |> Repo.insert()
  end
end
