# == Schema Information
#
# Table name: categories # Категории
#
#  id         :integer          not null, primary key # Категории
#  name       :string           default(""), not null # Название
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  # Relations
  # ==================================================================================
  has_many :articles, through: :category_articles
  has_many :category_articles, dependent: :destroy
  # ==================================================================================
  # Relations
end
