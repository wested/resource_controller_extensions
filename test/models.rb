ActiveRecord::Base.establish_connection :adapter  => 'sqlite3', :database => File.join(File.dirname(__FILE__), 'test.db')

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :projects, :force => true do |t|
      t.string :name
      t.timestamps
    end
    create_table :tasks, :force => true do |t|
      t.string :name
      t.integer :project_id
      t.boolean :complete
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Project < ActiveRecord::Base
  has_many :tasks
end

class Task < ActiveRecord::Base
  belongs_to :project
end
