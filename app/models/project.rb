# == Schema Information
# Schema version: 20101106235748
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  active      :boolean
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  basecamp_id :integer         default(0)
#  writer_id   :integer         default(0)
#  linker_id   :integer         default(0)
#  description :text
#  notes       :text
#

class Project < ActiveRecord::Base
  attr_accessible :name, :basecamp_id, :active, :writer_id, :linker_id, :description, :notes

  belongs_to :user
  has_many :used_keywords
  has_many :keywords,
    :through => :used_keywords,
    :source => :keyword
    
  validates_presence_of :name, :description
end
