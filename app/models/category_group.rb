# frozen_string_literal: true

# == Schema Information
#
# Table name: category_groups
#
#  description :text
#  name        :string           not null
#  permalink   :citext           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_category_groups_on_permalink  (permalink) UNIQUE
#
class CategoryGroup < ApplicationRecord
  self.primary_key = :permalink

  has_many :categories,
           -> { order(name: :asc) },
           foreign_key: :category_group_permalink,
           inverse_of:  :category_group,
           dependent:   :destroy

  def self.for_welcome_page
    order(name: :asc).includes(:categories)
  end
end
