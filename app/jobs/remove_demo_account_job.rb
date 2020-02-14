class RemoveDemoAccountJob < ApplicationJob
  queue_as :remove_demo_account

  def perform(account_id)
    account = Account.find(account_id)
    account.destroy
  end
end
