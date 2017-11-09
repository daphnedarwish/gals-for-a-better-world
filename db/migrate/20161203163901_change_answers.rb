class ChangeAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers,:selected_answer,:integer
    remove_column :answers,:option_one,:boolean
    remove_column :answers,:option_two,:boolean
    remove_column :answers,:option_three,:boolean
  end
end
