class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.integer :survey_id
      t.string :question_text
      t.string :option_one
      t.string :option_two
      t.string :option_three
    end 
  end
end
