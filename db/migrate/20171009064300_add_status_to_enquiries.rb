class AddStatusToEnquiries < ActiveRecord::Migration[5.1]
  def change
  	add_column :enquiries, :status, :string
  end
end
