# == Schema Information
# Schema version: 20101106235748
#
# Table name: used_keywords
#
#  id         :integer         not null, primary key
#  keyword_id :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class UsedKeyword < ActiveRecord::Base
  belongs_to :keyword
  belongs_to :project
end
