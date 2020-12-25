# frozen_string_literal: true

# == Schema Information
#
# Table name: categorizations
#
#  id                 :bigint           not null, primary key
#  category_permalink :citext           not null
#  project_permalink  :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  categorizations_unique_index                 (category_permalink,project_permalink) UNIQUE
#  index_categorizations_on_category_permalink  (category_permalink)
#  index_categorizations_on_project_permalink   (project_permalink)
#
# Foreign Keys
#
#  fk_rails_...  (category_permalink => categories.permalink)
#  fk_rails_...  (project_permalink => projects.permalink)
#
class Categorization < ApplicationRecord
  belongs_to :category,
             primary_key: :permalink,
             inverse_of:  :categorizations,
             foreign_key: :category_permalink

  belongs_to :project,
             primary_key: :permalink,
             inverse_of:  :categorizations,
             foreign_key: :project_permalink
end
