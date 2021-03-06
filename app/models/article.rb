# == Schema Information
#
# Table name: articles
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  body                    :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  rate                    :integer
#

class Article < ActiveRecord::Base
  acts_as_taggable_on :tags
  attr_accessible :body, :title, :tag_list, :attachment, :user_id
  belongs_to :user
  delegate :nickname, :to => :user, :prefix => true
  has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates :title, :presence => true, :uniqueness => true
  validates :body, :presence => true
  before_save :set_rate_before_save
  acts_as_favable
  has_many :rates, :as => :rateable

  self.per_page = 10


  def  favorite_it!(current_user)
    unless self.is_favorited_by_user?(current_user)
      self.favorited_by(current_user)
    end
  end

  def is_favorited_by_user?(user)
    article_user_favorites(user).any?
  end

  def article_user_favorites(user)
    Favorite.find_favorite_by_user_for_favable(user,self)
  end

  def favorited_by(user)
    self.favorites.create(:user_id => user.id)
  end

  def rated_by?(user)
    Rate.rateable_rated_by_user(user,self).any?
  end

  def rate!(user, rate)
    unless rated_by?(user)
      self.rates.create(:user_id => user.id)
      if self.rate.nil?
        self.rate = rate
      else
        self.rate = self.rate + rate
      end
      self.save
    end
  end

  def set_rate_before_save
    self.rate = self.rate || 0
  end
end
