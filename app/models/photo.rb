# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord

  belongs_to(:owner, { :required => true, :class_name => "User", :foreign_key => "owner_id" })
  has_many(:likes, { :class_name => "Like", :foreign_key => "photo_id", :dependent => :destroy })
  has_many(:comments, { :class_name => "Comment", :foreign_key => "photo_id", :dependent => :destroy })
  
end
