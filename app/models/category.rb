# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  category_group_permalink :citext           not null
#  description              :text
#  description_tsvector     :tsvector
#  name                     :string           not null
#  name_tsvector            :tsvector
#  permalink                :citext           not null, primary key
#  rank                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_categories_on_category_group_permalink  (category_group_permalink)
#  index_categories_on_created_at                (created_at)
#  index_categories_on_description_tsvector      (description_tsvector) USING gin
#  index_categories_on_name_tsvector             (name_tsvector) USING gin
#  index_categories_on_permalink                 (permalink) UNIQUE
#  index_categories_on_rank                      (rank)
#
# Foreign Keys
#
#  fk_rails_...  (category_group_permalink => category_groups.permalink)
#
class Category < ApplicationRecord
  self.primary_key = :permalink

  belongs_to :category_group,
             primary_key: :permalink,
             inverse_of:  :categories,
             foreign_key: :category_group_permalink

  has_many :categorizations,
           primary_key: :permalink,
           foreign_key: :category_permalink,
           inverse_of:  :category,
           dependent:   :destroy

  has_many :projects, -> { order(score: :desc) },
           through: :categorizations

  scope :by_rank, -> { where.not(rank: nil).order(rank: :asc) }
  scope :featured, -> { by_rank.limit(16).includes(:projects) }
  scope :recently_added, -> { order(created_at: :desc).limit(4).includes(:projects) }

  include PgSearch::Model
  pg_search_scope :search_scope,
                  against:   %i[name_tsvector description_tsvector],
                  using:     {
                    tsearch: {
                      tsvector_column: %w[name_tsvector description_tsvector],
                      prefix:          true,
                      dictionary:      "simple",
                    },
                  },
                  ranked_by: ":tsearch"

  def self.search(query)
    includes(:projects).search_scope(query)
  end

  def self.find_for_show!(permalink, order: Project::Order.new)
    includes(:category_group, projects: %i[rubygem github_repo])
      .order(order.sql)
      .find(permalink.try(:strip))
  end

  CATALOG_GITHUB_BASE_URL = "https://github.com/rubytoolbox/catalog/"

  def catalog_show_url
    catalog_github_url
  end

  def catalog_edit_url
    catalog_github_url edit: true
  end

  private

  def catalog_github_url(edit: false)
    type = edit ? "edit" : "tree"
    File.join CATALOG_GITHUB_BASE_URL, type, "master/catalog", category_group.permalink, "#{permalink}.yml"
  end
end
