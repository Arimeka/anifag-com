# == Schema Information
#
# Table name: categories # Категории
#
#  id         :integer          not null, primary key # Категории
#  name       :string           default(""), not null # Название
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
