# frozen_string_literal: true

class RemoveForwardAgentFromHostingServers < ActiveRecord::Migration[5.0]
  def change
    remove_column(:hosting_servers, :forward_agent, :string, null: false)
  end
end
